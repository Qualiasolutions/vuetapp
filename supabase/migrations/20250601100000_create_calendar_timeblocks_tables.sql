-- Migration: 20250601100000_create_calendar_timeblocks_tables.sql
-- Description: Creates tables and policies for calendar and timeblocks features

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================================================
-- TABLES
-- =============================================================================

-- Calendar Events table
CREATE TABLE IF NOT EXISTS public.calendar_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT,
    location TEXT,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    all_day BOOLEAN NOT NULL DEFAULT false,
    owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    family_id UUID REFERENCES public.families(id) ON DELETE SET NULL,
    color TEXT,
    recurrence_rule TEXT, -- iCalendar RRULE format
    recurrence_exception_dates TEXT[], -- Dates when recurring event doesn't occur
    reminder_minutes INTEGER[], -- Array of minutes before event for reminders
    is_private BOOLEAN NOT NULL DEFAULT false,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Event Attendees table
CREATE TABLE IF NOT EXISTS public.event_attendees (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES public.calendar_events(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT,
    name TEXT,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'declined', 'tentative')),
    is_organizer BOOLEAN NOT NULL DEFAULT false,
    response_timestamp TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT attendee_has_user_or_email CHECK (user_id IS NOT NULL OR email IS NOT NULL)
);

-- Timeblocks table
CREATE TABLE IF NOT EXISTS public.timeblocks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT,
    day_of_week INTEGER NOT NULL CHECK (day_of_week BETWEEN 1 AND 7), -- 1 for Monday, 7 for Sunday
    start_time TEXT NOT NULL, -- HH:mm:ss format
    end_time TEXT NOT NULL, -- HH:mm:ss format
    color TEXT, -- Hex color code e.g., #RRGGBB
    description TEXT,
    activity_type TEXT, -- work, exercise, personal, etc.
    linked_routine_id UUID REFERENCES public.routines(id) ON DELETE SET NULL,
    linked_task_id UUID REFERENCES public.tasks(id) ON DELETE SET NULL,
    sync_with_calendar BOOLEAN NOT NULL DEFAULT false,
    external_calendar_event_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- External Calendar Sync table
CREATE TABLE IF NOT EXISTS public.external_calendar_sync (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    calendar_id TEXT NOT NULL, -- External calendar identifier
    calendar_name TEXT NOT NULL,
    provider TEXT NOT NULL, -- google, apple, outlook, etc.
    sync_token TEXT, -- Token for incremental sync
    last_synced_at TIMESTAMPTZ,
    is_active BOOLEAN NOT NULL DEFAULT true,
    color TEXT, -- Color for this calendar's events
    sync_direction TEXT NOT NULL DEFAULT 'import' CHECK (sync_direction IN ('import', 'export', 'bidirectional')),
    settings JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, calendar_id, provider)
);

-- External Calendar Events table (for caching external events)
CREATE TABLE IF NOT EXISTS public.external_calendar_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    external_calendar_id UUID NOT NULL REFERENCES public.external_calendar_sync(id) ON DELETE CASCADE,
    external_event_id TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    location TEXT,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    all_day BOOLEAN NOT NULL DEFAULT false,
    color TEXT,
    recurrence_rule TEXT,
    organizer TEXT,
    attendees JSONB,
    is_recurring BOOLEAN NOT NULL DEFAULT false,
    is_instance BOOLEAN NOT NULL DEFAULT false,
    parent_event_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, external_calendar_id, external_event_id)
);

-- =============================================================================
-- INDEXES
-- =============================================================================

-- Calendar Events indexes
CREATE INDEX IF NOT EXISTS idx_calendar_events_owner_id ON public.calendar_events(owner_id);
CREATE INDEX IF NOT EXISTS idx_calendar_events_family_id ON public.calendar_events(family_id);
CREATE INDEX IF NOT EXISTS idx_calendar_events_start_time ON public.calendar_events(start_time);
CREATE INDEX IF NOT EXISTS idx_calendar_events_end_time ON public.calendar_events(end_time);
CREATE INDEX IF NOT EXISTS idx_calendar_events_all_day ON public.calendar_events(all_day);

-- Event Attendees indexes
CREATE INDEX IF NOT EXISTS idx_event_attendees_event_id ON public.event_attendees(event_id);
CREATE INDEX IF NOT EXISTS idx_event_attendees_user_id ON public.event_attendees(user_id);
CREATE INDEX IF NOT EXISTS idx_event_attendees_email ON public.event_attendees(email);
CREATE INDEX IF NOT EXISTS idx_event_attendees_status ON public.event_attendees(status);

-- Timeblocks indexes
CREATE INDEX IF NOT EXISTS idx_timeblocks_user_id ON public.timeblocks(user_id);
CREATE INDEX IF NOT EXISTS idx_timeblocks_day_of_week ON public.timeblocks(day_of_week);
CREATE INDEX IF NOT EXISTS idx_timeblocks_linked_routine_id ON public.timeblocks(linked_routine_id);
CREATE INDEX IF NOT EXISTS idx_timeblocks_linked_task_id ON public.timeblocks(linked_task_id);
CREATE INDEX IF NOT EXISTS idx_timeblocks_activity_type ON public.timeblocks(activity_type);

-- External Calendar Sync indexes
CREATE INDEX IF NOT EXISTS idx_external_calendar_sync_user_id ON public.external_calendar_sync(user_id);
CREATE INDEX IF NOT EXISTS idx_external_calendar_sync_provider ON public.external_calendar_sync(provider);
CREATE INDEX IF NOT EXISTS idx_external_calendar_sync_is_active ON public.external_calendar_sync(is_active);

-- External Calendar Events indexes
CREATE INDEX IF NOT EXISTS idx_external_calendar_events_user_id ON public.external_calendar_events(user_id);
CREATE INDEX IF NOT EXISTS idx_external_calendar_events_external_calendar_id ON public.external_calendar_events(external_calendar_id);
CREATE INDEX IF NOT EXISTS idx_external_calendar_events_start_time ON public.external_calendar_events(start_time);
CREATE INDEX IF NOT EXISTS idx_external_calendar_events_end_time ON public.external_calendar_events(end_time);

-- =============================================================================
-- TRIGGERS
-- =============================================================================

-- Update timestamp trigger function (if not already created)
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add triggers for updated_at columns
CREATE TRIGGER update_calendar_events_updated_at
BEFORE UPDATE ON public.calendar_events
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_event_attendees_updated_at
BEFORE UPDATE ON public.event_attendees
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_timeblocks_updated_at
BEFORE UPDATE ON public.timeblocks
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_external_calendar_sync_updated_at
BEFORE UPDATE ON public.external_calendar_sync
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_external_calendar_events_updated_at
BEFORE UPDATE ON public.external_calendar_events
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =============================================================================
-- HELPER FUNCTIONS
-- =============================================================================

-- Function to check if user can access a calendar event
CREATE OR REPLACE FUNCTION public.can_access_calendar_event(event_id UUID, user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    event_record RECORD;
    is_attendee BOOLEAN;
    is_family_member BOOLEAN;
BEGIN
    -- Get the event record
    SELECT * INTO event_record FROM public.calendar_events WHERE id = event_id;
    
    -- If event doesn't exist, return false
    IF event_record IS NULL THEN
        RETURN FALSE;
    END IF;
    
    -- If user is the owner, they can access
    IF event_record.owner_id = user_id THEN
        RETURN TRUE;
    END IF;
    
    -- Check if user is an attendee
    SELECT EXISTS (
        SELECT 1 FROM public.event_attendees 
        WHERE event_id = event_record.id AND user_id = $2
    ) INTO is_attendee;
    
    IF is_attendee THEN
        RETURN TRUE;
    END IF;
    
    -- If event has family_id, check if user is a family member
    IF event_record.family_id IS NOT NULL THEN
        SELECT EXISTS (
            SELECT 1 FROM public.family_members 
            WHERE family_id = event_record.family_id AND user_id = $2 AND is_active = TRUE
        ) INTO is_family_member;
        
        IF is_family_member THEN
            RETURN TRUE;
        END IF;
    END IF;
    
    -- If none of the above, user cannot access the event
    RETURN FALSE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================================================
-- ROW LEVEL SECURITY POLICIES
-- =============================================================================

-- Enable RLS on all tables
ALTER TABLE public.calendar_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.event_attendees ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.timeblocks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.external_calendar_sync ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.external_calendar_events ENABLE ROW LEVEL SECURITY;

-- Calendar Events policies
CREATE POLICY "Users can view their own events and events they're invited to" 
ON public.calendar_events FOR SELECT 
USING (
    owner_id = auth.uid() OR 
    EXISTS (
        SELECT 1 FROM public.event_attendees 
        WHERE event_id = id AND user_id = auth.uid()
    ) OR
    (
        family_id IS NOT NULL AND 
        EXISTS (
            SELECT 1 FROM public.family_members 
            WHERE family_id = calendar_events.family_id AND user_id = auth.uid() AND is_active = true
        )
    )
);

CREATE POLICY "Users can insert their own events" 
ON public.calendar_events FOR INSERT 
WITH CHECK (owner_id = auth.uid());

CREATE POLICY "Users can update their own events" 
ON public.calendar_events FOR UPDATE 
USING (owner_id = auth.uid())
WITH CHECK (owner_id = auth.uid());

CREATE POLICY "Users can delete their own events" 
ON public.calendar_events FOR DELETE 
USING (owner_id = auth.uid());

-- Event Attendees policies
CREATE POLICY "Users can view attendees for events they can access" 
ON public.event_attendees FOR SELECT 
USING (
    user_id = auth.uid() OR 
    EXISTS (
        SELECT 1 FROM public.calendar_events 
        WHERE id = event_id AND (
            owner_id = auth.uid() OR
            EXISTS (
                SELECT 1 FROM public.event_attendees ea 
                WHERE ea.event_id = event_id AND ea.user_id = auth.uid()
            ) OR
            (
                family_id IS NOT NULL AND 
                EXISTS (
                    SELECT 1 FROM public.family_members 
                    WHERE family_id = calendar_events.family_id AND user_id = auth.uid() AND is_active = true
                )
            )
        )
    )
);

CREATE POLICY "Event owners can insert attendees" 
ON public.event_attendees FOR INSERT 
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.calendar_events 
        WHERE id = event_id AND owner_id = auth.uid()
    )
);

CREATE POLICY "Event owners can update attendees" 
ON public.event_attendees FOR UPDATE 
USING (
    EXISTS (
        SELECT 1 FROM public.calendar_events 
        WHERE id = event_id AND owner_id = auth.uid()
    )
);

CREATE POLICY "Attendees can update their own status" 
ON public.event_attendees FOR UPDATE 
USING (user_id = auth.uid())
WITH CHECK (
    user_id = auth.uid() AND 
    (
        NEW.status IS DISTINCT FROM OLD.status OR
        NEW.response_timestamp IS DISTINCT FROM OLD.response_timestamp
    )
);

CREATE POLICY "Event owners can delete attendees" 
ON public.event_attendees FOR DELETE 
USING (
    EXISTS (
        SELECT 1 FROM public.calendar_events 
        WHERE id = event_id AND owner_id = auth.uid()
    )
);

-- Timeblocks policies
CREATE POLICY "Users can view their own timeblocks" 
ON public.timeblocks FOR SELECT 
USING (user_id = auth.uid());

CREATE POLICY "Users can insert their own timeblocks" 
ON public.timeblocks FOR INSERT 
WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update their own timeblocks" 
ON public.timeblocks FOR UPDATE 
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete their own timeblocks" 
ON public.timeblocks FOR DELETE 
USING (user_id = auth.uid());

-- External Calendar Sync policies
CREATE POLICY "Users can view their own external calendar connections" 
ON public.external_calendar_sync FOR SELECT 
USING (user_id = auth.uid());

CREATE POLICY "Users can insert their own external calendar connections" 
ON public.external_calendar_sync FOR INSERT 
WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update their own external calendar connections" 
ON public.external_calendar_sync FOR UPDATE 
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete their own external calendar connections" 
ON public.external_calendar_sync FOR DELETE 
USING (user_id = auth.uid());

-- External Calendar Events policies
CREATE POLICY "Users can view their own external calendar events" 
ON public.external_calendar_events FOR SELECT 
USING (user_id = auth.uid());

CREATE POLICY "Users can insert their own external calendar events" 
ON public.external_calendar_events FOR INSERT 
WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update their own external calendar events" 
ON public.external_calendar_events FOR UPDATE 
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete their own external calendar events" 
ON public.external_calendar_events FOR DELETE 
USING (user_id = auth.uid());

-- =============================================================================
-- DEFAULT PERMISSIONS
-- =============================================================================

-- Grant usage on schema
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;

-- Grant access to tables
GRANT SELECT, INSERT, UPDATE, DELETE ON public.calendar_events TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.event_attendees TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.timeblocks TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.external_calendar_sync TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.external_calendar_events TO authenticated;

-- Grant execute on functions
GRANT EXECUTE ON FUNCTION public.can_access_calendar_event TO authenticated;

-- Grant usage on sequences
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO authenticated;
