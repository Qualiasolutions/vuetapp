-- Create Alerts Tables Migration
-- This migration creates the database tables for the alerts system

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create alerts table
CREATE TABLE IF NOT EXISTS public.alerts (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id uuid NOT NULL REFERENCES public.tasks(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    type text NOT NULL CHECK (type IN ('TASK_LIMIT_EXCEEDED', 'TASK_CONFLICT', 'UNPREFERRED_DAY', 'BLOCKED_DAY')),
    read boolean NOT NULL DEFAULT false,
    additional_data jsonb NULL,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    
    -- Constraints
    CONSTRAINT alerts_type_valid CHECK (type IN ('TASK_LIMIT_EXCEEDED', 'TASK_CONFLICT', 'UNPREFERRED_DAY', 'BLOCKED_DAY'))
);

-- Create action_alerts table  
CREATE TABLE IF NOT EXISTS public.action_alerts (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    action_id uuid NOT NULL REFERENCES public.task_actions(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    type text NOT NULL CHECK (type IN ('TASK_LIMIT_EXCEEDED', 'TASK_CONFLICT', 'UNPREFERRED_DAY', 'BLOCKED_DAY')),
    read boolean NOT NULL DEFAULT false,
    additional_data jsonb NULL,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    
    -- Constraints
    CONSTRAINT action_alerts_type_valid CHECK (type IN ('TASK_LIMIT_EXCEEDED', 'TASK_CONFLICT', 'UNPREFERRED_DAY', 'BLOCKED_DAY'))
);

-- Create indexes for performance
-- Alerts table indexes
CREATE INDEX IF NOT EXISTS idx_alerts_user_id ON public.alerts(user_id);
CREATE INDEX IF NOT EXISTS idx_alerts_task_id ON public.alerts(task_id);
CREATE INDEX IF NOT EXISTS idx_alerts_type ON public.alerts(type);
CREATE INDEX IF NOT EXISTS idx_alerts_read ON public.alerts(read);
CREATE INDEX IF NOT EXISTS idx_alerts_created_at ON public.alerts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_alerts_user_task ON public.alerts(user_id, task_id);
CREATE INDEX IF NOT EXISTS idx_alerts_user_unread ON public.alerts(user_id, read) WHERE read = false;

-- Action alerts table indexes
CREATE INDEX IF NOT EXISTS idx_action_alerts_user_id ON public.action_alerts(user_id);
CREATE INDEX IF NOT EXISTS idx_action_alerts_action_id ON public.action_alerts(action_id);
CREATE INDEX IF NOT EXISTS idx_action_alerts_type ON public.action_alerts(type);
CREATE INDEX IF NOT EXISTS idx_action_alerts_read ON public.action_alerts(read);
CREATE INDEX IF NOT EXISTS idx_action_alerts_created_at ON public.action_alerts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_action_alerts_user_action ON public.action_alerts(user_id, action_id);
CREATE INDEX IF NOT EXISTS idx_action_alerts_user_unread ON public.action_alerts(user_id, read) WHERE read = false;

-- Enable Row Level Security
ALTER TABLE public.alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.action_alerts ENABLE ROW LEVEL SECURITY;

-- RLS Policies for alerts table
-- Users can only see their own alerts
CREATE POLICY alerts_select_policy 
ON public.alerts 
FOR SELECT 
USING (user_id = auth.uid());

-- Users can only insert alerts for themselves
CREATE POLICY alerts_insert_policy 
ON public.alerts 
FOR INSERT 
WITH CHECK (user_id = auth.uid());

-- Users can only update their own alerts
CREATE POLICY alerts_update_policy 
ON public.alerts 
FOR UPDATE 
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Users can only delete their own alerts
CREATE POLICY alerts_delete_policy 
ON public.alerts 
FOR DELETE 
USING (user_id = auth.uid());

-- RLS Policies for action_alerts table
-- Users can only see their own action alerts
CREATE POLICY action_alerts_select_policy 
ON public.action_alerts 
FOR SELECT 
USING (user_id = auth.uid());

-- Users can only insert action alerts for themselves
CREATE POLICY action_alerts_insert_policy 
ON public.action_alerts 
FOR INSERT 
WITH CHECK (user_id = auth.uid());

-- Users can only update their own action alerts
CREATE POLICY action_alerts_update_policy 
ON public.action_alerts 
FOR UPDATE 
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Users can only delete their own action alerts
CREATE POLICY action_alerts_delete_policy 
ON public.action_alerts 
FOR DELETE 
USING (user_id = auth.uid());

-- Create triggers to automatically update updated_at
CREATE OR REPLACE FUNCTION public.update_alerts_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for both tables
CREATE TRIGGER alerts_updated_at_trigger
    BEFORE UPDATE ON public.alerts
    FOR EACH ROW
    EXECUTE FUNCTION public.update_alerts_updated_at();

CREATE TRIGGER action_alerts_updated_at_trigger
    BEFORE UPDATE ON public.action_alerts
    FOR EACH ROW
    EXECUTE FUNCTION public.update_alerts_updated_at();

-- Create helper functions
-- Function to check if user has unread alerts
CREATE OR REPLACE FUNCTION public.user_has_unread_alerts()
RETURNS boolean AS $$
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
$$ LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public;

-- Function to get unread alert count for user
CREATE OR REPLACE FUNCTION public.get_unread_alert_count()
RETURNS integer AS $$
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
$$ LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public;

-- Function to mark all user alerts as read
CREATE OR REPLACE FUNCTION public.mark_all_user_alerts_read()
RETURNS void AS $$
BEGIN
    UPDATE public.alerts 
    SET read = true 
    WHERE user_id = auth.uid() AND read = false;
    
    UPDATE public.action_alerts 
    SET read = true 
    WHERE user_id = auth.uid() AND read = false;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public;

-- Grant necessary permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON public.alerts TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.action_alerts TO authenticated;
GRANT EXECUTE ON FUNCTION public.user_has_unread_alerts TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_unread_alert_count TO authenticated;
GRANT EXECUTE ON FUNCTION public.mark_all_user_alerts_read TO authenticated; 