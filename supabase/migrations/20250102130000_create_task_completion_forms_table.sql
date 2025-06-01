-- Create Task Completion Forms Table Migration
-- This migration creates the database table for the advanced task completion forms system

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create task_completion_forms table
CREATE TABLE IF NOT EXISTS public.task_completion_forms (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id uuid NOT NULL REFERENCES public.tasks(id) ON DELETE CASCADE,
    completion_datetime timestamp with time zone NOT NULL DEFAULT now(),
    recurrence_index integer NULL,
    ignore boolean NOT NULL DEFAULT false,
    complete boolean NOT NULL DEFAULT true,
    partial boolean NOT NULL DEFAULT false,
    completed_by_user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    notes text NULL,
    rescheduled_date timestamp with time zone NULL,
    completion_type text NOT NULL DEFAULT 'complete' CHECK (completion_type IN ('complete', 'reschedule', 'partial', 'skip', 'cancel')),
    additional_data jsonb NULL,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    
    -- Constraints
    CONSTRAINT task_completion_forms_completion_logic CHECK (
        (complete = true AND partial = false AND ignore = false) OR
        (partial = true AND complete = false) OR
        (ignore = true AND complete = false AND partial = false)
    ),
    CONSTRAINT task_completion_forms_recurrence_valid CHECK (
        recurrence_index IS NULL OR recurrence_index >= 0
    ),
    CONSTRAINT task_completion_forms_rescheduled_date_valid CHECK (
        (completion_type = 'reschedule' AND rescheduled_date IS NOT NULL) OR
        (completion_type != 'reschedule')
    )
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_task_completion_forms_task_id ON public.task_completion_forms(task_id);
CREATE INDEX IF NOT EXISTS idx_task_completion_forms_user_id ON public.task_completion_forms(completed_by_user_id);
CREATE INDEX IF NOT EXISTS idx_task_completion_forms_completion_datetime ON public.task_completion_forms(completion_datetime DESC);
CREATE INDEX IF NOT EXISTS idx_task_completion_forms_task_recurrence ON public.task_completion_forms(task_id, recurrence_index) WHERE recurrence_index IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_task_completion_forms_completion_type ON public.task_completion_forms(completion_type);
CREATE INDEX IF NOT EXISTS idx_task_completion_forms_complete_status ON public.task_completion_forms(complete, ignore) WHERE complete = true AND ignore = false;

-- Create unique constraint for non-recurring task completions
CREATE UNIQUE INDEX IF NOT EXISTS idx_task_completion_forms_unique_task_completion 
ON public.task_completion_forms(task_id, completed_by_user_id) 
WHERE recurrence_index IS NULL AND ignore = false AND complete = true;

-- Create unique constraint for recurring task completions
CREATE UNIQUE INDEX IF NOT EXISTS idx_task_completion_forms_unique_recurrence_completion 
ON public.task_completion_forms(task_id, recurrence_index, completed_by_user_id) 
WHERE recurrence_index IS NOT NULL AND ignore = false AND complete = true;

-- Enable Row Level Security
ALTER TABLE public.task_completion_forms ENABLE ROW LEVEL SECURITY;

-- RLS Policies
-- Users can only see their own completion forms
CREATE POLICY task_completion_forms_select_policy 
ON public.task_completion_forms 
FOR SELECT 
USING (completed_by_user_id = auth.uid());

-- Users can only insert completion forms for themselves
CREATE POLICY task_completion_forms_insert_policy 
ON public.task_completion_forms 
FOR INSERT 
WITH CHECK (completed_by_user_id = auth.uid());

-- Users can only update their own completion forms
CREATE POLICY task_completion_forms_update_policy 
ON public.task_completion_forms 
FOR UPDATE 
USING (completed_by_user_id = auth.uid())
WITH CHECK (completed_by_user_id = auth.uid());

-- Users can only delete their own completion forms
CREATE POLICY task_completion_forms_delete_policy 
ON public.task_completion_forms 
FOR DELETE 
USING (completed_by_user_id = auth.uid());

-- Create trigger to automatically update updated_at
CREATE OR REPLACE FUNCTION public.update_task_completion_forms_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER task_completion_forms_updated_at_trigger
    BEFORE UPDATE ON public.task_completion_forms
    FOR EACH ROW
    EXECUTE FUNCTION public.update_task_completion_forms_updated_at();

-- Create function to check if task is completed
CREATE OR REPLACE FUNCTION public.is_task_completed(task_uuid uuid, recurrence_idx integer DEFAULT NULL)
RETURNS boolean AS $$
DECLARE
    completion_count integer;
BEGIN
    SELECT COUNT(*)
    INTO completion_count
    FROM public.task_completion_forms
    WHERE task_id = task_uuid
      AND (recurrence_idx IS NULL OR recurrence_index = recurrence_idx)
      AND complete = true
      AND ignore = false
      AND completed_by_user_id = auth.uid();
    
    RETURN completion_count > 0;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public;

-- Create function to get completion statistics
CREATE OR REPLACE FUNCTION public.get_user_completion_stats(
    start_date timestamp with time zone DEFAULT (now() - interval '30 days'),
    end_date timestamp with time zone DEFAULT now()
)
RETURNS jsonb AS $$
DECLARE
    stats jsonb;
BEGIN
    SELECT jsonb_build_object(
        'total_completions', COUNT(*),
        'completed_tasks', COUNT(*) FILTER (WHERE complete = true AND ignore = false),
        'partial_completions', COUNT(*) FILTER (WHERE partial = true),
        'rescheduled_tasks', COUNT(*) FILTER (WHERE completion_type = 'reschedule'),
        'skipped_tasks', COUNT(*) FILTER (WHERE completion_type = 'skip'),
        'cancelled_tasks', COUNT(*) FILTER (WHERE completion_type = 'cancel'),
        'completion_rate', CASE 
            WHEN COUNT(*) > 0 THEN 
                ROUND((COUNT(*) FILTER (WHERE complete = true AND ignore = false))::numeric / COUNT(*)::numeric, 2)
            ELSE 0 
        END,
        'period_start', start_date,
        'period_end', end_date
    )
    INTO stats
    FROM public.task_completion_forms
    WHERE completed_by_user_id = auth.uid()
      AND completion_datetime BETWEEN start_date AND end_date;
    
    RETURN stats;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public;

-- Grant necessary permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON public.task_completion_forms TO authenticated;
GRANT USAGE ON SEQUENCE task_completion_forms_id_seq TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_task_completed TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_user_completion_stats TO authenticated; 