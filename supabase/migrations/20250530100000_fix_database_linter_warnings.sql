-- Fix Database Linter Warnings Migration
-- This migration addresses security and performance warnings from Supabase linter

-- 1. Fix function search_path security warnings
-- Recreate functions with explicit SECURITY DEFINER and search_path settings

-- Function: is_task_completed
DROP FUNCTION IF EXISTS public.is_task_completed(uuid, integer);
CREATE OR REPLACE FUNCTION public.is_task_completed(task_uuid uuid, recurrence_idx integer DEFAULT NULL)
RETURNS boolean 
LANGUAGE plpgsql 
SECURITY DEFINER
SET search_path = public
AS $$
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
$$;

-- Function: get_user_completion_stats
DROP FUNCTION IF EXISTS public.get_user_completion_stats(timestamp with time zone, timestamp with time zone);
CREATE OR REPLACE FUNCTION public.get_user_completion_stats(
    start_date timestamp with time zone DEFAULT (now() - interval '30 days'),
    end_date timestamp with time zone DEFAULT now()
)
RETURNS jsonb 
LANGUAGE plpgsql 
SECURITY DEFINER
SET search_path = public
AS $$
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
$$;

-- Function: user_has_unread_alerts
DROP FUNCTION IF EXISTS public.user_has_unread_alerts();
CREATE OR REPLACE FUNCTION public.user_has_unread_alerts()
RETURNS boolean 
LANGUAGE plpgsql 
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    unread_count integer;
BEGIN
    SELECT COUNT(*)
    INTO unread_count
    FROM (
        SELECT 1 FROM public.alerts WHERE user_id = auth.uid() AND read = false
        UNION ALL
        SELECT 1 FROM public.action_alerts WHERE user_id = auth.uid() AND read = false
    ) AS combined_alerts;
    
    RETURN unread_count > 0;
END;
$$;

-- Function: get_unread_alert_count
DROP FUNCTION IF EXISTS public.get_unread_alert_count();
CREATE OR REPLACE FUNCTION public.get_unread_alert_count()
RETURNS integer 
LANGUAGE plpgsql 
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    total_count integer;
BEGIN
    SELECT COUNT(*)
    INTO total_count
    FROM (
        SELECT 1 FROM public.alerts WHERE user_id = auth.uid() AND read = false
        UNION ALL
        SELECT 1 FROM public.action_alerts WHERE user_id = auth.uid() AND read = false
    ) AS combined_alerts;
    
    RETURN total_count;
END;
$$;

-- Function: mark_all_user_alerts_read
DROP FUNCTION IF EXISTS public.mark_all_user_alerts_read();
CREATE OR REPLACE FUNCTION public.mark_all_user_alerts_read()
RETURNS void 
LANGUAGE plpgsql 
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    UPDATE public.alerts 
    SET read = true 
    WHERE user_id = auth.uid() AND read = false;
    
    UPDATE public.action_alerts 
    SET read = true 
    WHERE user_id = auth.uid() AND read = false;
END;
$$;

-- 2. Fix multiple permissive policies for reference_groups table
-- First, check if the table exists and create it if needed
CREATE TABLE IF NOT EXISTS public.reference_groups (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    description text,
    owner_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now()
);

-- Enable RLS if not already enabled
ALTER TABLE public.reference_groups ENABLE ROW LEVEL SECURITY;

-- Drop all existing policies to avoid conflicts
DROP POLICY IF EXISTS "Reference groups are viewable by owner" ON public.reference_groups;
DROP POLICY IF EXISTS "Reference groups are viewable by creator" ON public.reference_groups;
DROP POLICY IF EXISTS "Reference groups can be created by authenticated users" ON public.reference_groups;
DROP POLICY IF EXISTS "Reference groups can be updated by owner" ON public.reference_groups;
DROP POLICY IF EXISTS "Reference groups can be updated by creator" ON public.reference_groups;
DROP POLICY IF EXISTS "Reference groups can be deleted by owner" ON public.reference_groups;
DROP POLICY IF EXISTS "Reference groups can be deleted by creator" ON public.reference_groups;
DROP POLICY IF EXISTS reference_groups_select_policy ON public.reference_groups;
DROP POLICY IF EXISTS reference_groups_insert_policy ON public.reference_groups;
DROP POLICY IF EXISTS reference_groups_update_policy ON public.reference_groups;
DROP POLICY IF EXISTS reference_groups_delete_policy ON public.reference_groups;

-- Create consolidated, optimized RLS policies (one per action)
CREATE POLICY reference_groups_select_policy 
ON public.reference_groups 
FOR SELECT 
USING (owner_id = auth.uid());

CREATE POLICY reference_groups_insert_policy 
ON public.reference_groups 
FOR INSERT 
WITH CHECK (owner_id = auth.uid());

CREATE POLICY reference_groups_update_policy 
ON public.reference_groups 
FOR UPDATE 
USING (owner_id = auth.uid())
WITH CHECK (owner_id = auth.uid());

CREATE POLICY reference_groups_delete_policy 
ON public.reference_groups 
FOR DELETE 
USING (owner_id = auth.uid());

-- Create references table if it doesn't exist (related to reference_groups)
CREATE TABLE IF NOT EXISTS public.references (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    description text,
    reference_group_id uuid REFERENCES public.reference_groups(id) ON DELETE SET NULL,
    owner_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now()
);

-- Enable RLS for references table
ALTER TABLE public.references ENABLE ROW LEVEL SECURITY;

-- Create optimized RLS policies for references table
DROP POLICY IF EXISTS references_select_policy ON public.references;
DROP POLICY IF EXISTS references_insert_policy ON public.references;
DROP POLICY IF EXISTS references_update_policy ON public.references;
DROP POLICY IF EXISTS references_delete_policy ON public.references;

CREATE POLICY references_select_policy 
ON public.references 
FOR SELECT 
USING (owner_id = auth.uid());

CREATE POLICY references_insert_policy 
ON public.references 
FOR INSERT 
WITH CHECK (owner_id = auth.uid());

CREATE POLICY references_update_policy 
ON public.references 
FOR UPDATE 
USING (owner_id = auth.uid())
WITH CHECK (owner_id = auth.uid());

CREATE POLICY references_delete_policy 
ON public.references 
FOR DELETE 
USING (owner_id = auth.uid());

-- Create entity_references table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.entity_references (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    entity_id uuid NOT NULL REFERENCES public.entities(id) ON DELETE CASCADE,
    reference_id uuid NOT NULL REFERENCES public.references(id) ON DELETE CASCADE,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    
    UNIQUE(entity_id, reference_id)
);

-- Enable RLS for entity_references table
ALTER TABLE public.entity_references ENABLE ROW LEVEL SECURITY;

-- Create optimized RLS policies for entity_references table
DROP POLICY IF EXISTS entity_references_select_policy ON public.entity_references;
DROP POLICY IF EXISTS entity_references_insert_policy ON public.entity_references;
DROP POLICY IF EXISTS entity_references_update_policy ON public.entity_references;
DROP POLICY IF EXISTS entity_references_delete_policy ON public.entity_references;

CREATE POLICY entity_references_select_policy 
ON public.entity_references 
FOR SELECT 
USING (
    entity_id IN (
        SELECT id FROM public.entities WHERE owner_id = auth.uid()
    )
);

CREATE POLICY entity_references_insert_policy 
ON public.entity_references 
FOR INSERT 
WITH CHECK (
    entity_id IN (
        SELECT id FROM public.entities WHERE owner_id = auth.uid()
    ) AND
    reference_id IN (
        SELECT id FROM public.references WHERE owner_id = auth.uid()
    )
);

CREATE POLICY entity_references_update_policy 
ON public.entity_references 
FOR UPDATE 
USING (
    entity_id IN (
        SELECT id FROM public.entities WHERE owner_id = auth.uid()
    )
)
WITH CHECK (
    entity_id IN (
        SELECT id FROM public.entities WHERE owner_id = auth.uid()
    ) AND
    reference_id IN (
        SELECT id FROM public.references WHERE owner_id = auth.uid()
    )
);

CREATE POLICY entity_references_delete_policy 
ON public.entity_references 
FOR DELETE 
USING (
    entity_id IN (
        SELECT id FROM public.entities WHERE owner_id = auth.uid()
    )
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_reference_groups_owner_id ON public.reference_groups(owner_id);
CREATE INDEX IF NOT EXISTS idx_reference_groups_name ON public.reference_groups(name);

CREATE INDEX IF NOT EXISTS idx_references_owner_id ON public.references(owner_id);
CREATE INDEX IF NOT EXISTS idx_references_group_id ON public.references(reference_group_id);
CREATE INDEX IF NOT EXISTS idx_references_name ON public.references(name);

CREATE INDEX IF NOT EXISTS idx_entity_references_entity_id ON public.entity_references(entity_id);
CREATE INDEX IF NOT EXISTS idx_entity_references_reference_id ON public.entity_references(reference_id);

-- Create update triggers for timestamps
CREATE OR REPLACE FUNCTION public.update_reference_groups_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.update_references_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers
DROP TRIGGER IF EXISTS reference_groups_updated_at_trigger ON public.reference_groups;
CREATE TRIGGER reference_groups_updated_at_trigger
    BEFORE UPDATE ON public.reference_groups
    FOR EACH ROW
    EXECUTE FUNCTION public.update_reference_groups_updated_at();

DROP TRIGGER IF EXISTS references_updated_at_trigger ON public.references;
CREATE TRIGGER references_updated_at_trigger
    BEFORE UPDATE ON public.references
    FOR EACH ROW
    EXECUTE FUNCTION public.update_references_updated_at();

-- Grant permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON public.reference_groups TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.references TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.entity_references TO authenticated;

-- Grant execute permissions on functions
GRANT EXECUTE ON FUNCTION public.is_task_completed(uuid, integer) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_user_completion_stats(timestamp with time zone, timestamp with time zone) TO authenticated;
GRANT EXECUTE ON FUNCTION public.user_has_unread_alerts() TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_unread_alert_count() TO authenticated;
GRANT EXECUTE ON FUNCTION public.mark_all_user_alerts_read() TO authenticated;

-- Add comments for documentation
COMMENT ON FUNCTION public.is_task_completed(uuid, integer) IS 'Check if a task is completed with secure search_path';
COMMENT ON FUNCTION public.get_user_completion_stats(timestamp with time zone, timestamp with time zone) IS 'Get user completion statistics with secure search_path';
COMMENT ON FUNCTION public.user_has_unread_alerts() IS 'Check if user has unread alerts with secure search_path';
COMMENT ON FUNCTION public.get_unread_alert_count() IS 'Get count of unread alerts with secure search_path';
COMMENT ON FUNCTION public.mark_all_user_alerts_read() IS 'Mark all user alerts as read with secure search_path';

COMMENT ON TABLE public.reference_groups IS 'Reference groups table with optimized RLS policies';
COMMENT ON TABLE public.references IS 'References table with optimized RLS policies';
COMMENT ON TABLE public.entity_references IS 'Entity-reference relationships with optimized RLS policies';
