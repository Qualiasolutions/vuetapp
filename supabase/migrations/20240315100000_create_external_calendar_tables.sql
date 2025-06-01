CREATE TYPE public.ical_calendar_type AS ENUM (
  'unknown',
  'google',
  'icloud',
  'outlook'
);

CREATE TYPE public.ical_share_type AS ENUM (
  'off',
  'busy',
  'full'
);

CREATE TYPE public.sync_status_type AS ENUM (
  'pending',
  'success',
  'failed',
  'never'
);

CREATE TABLE public.ical_integrations (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  ical_name TEXT NOT NULL,
  ical_url TEXT NOT NULL,
  ical_type public.ical_calendar_type NOT NULL DEFAULT 'unknown',
  share_type public.ical_share_type NOT NULL DEFAULT 'off',
  last_synced_at TIMESTAMPTZ,
  sync_status public.sync_status_type DEFAULT 'never',
  sync_error_message TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.ical_integrations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can select their own ical integrations" 
ON public.ical_integrations FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own ical integrations" 
ON public.ical_integrations FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own ical integrations" 
ON public.ical_integrations FOR UPDATE 
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own ical integrations" 
ON public.ical_integrations FOR DELETE 
USING (auth.uid() = user_id);

CREATE INDEX idx_ical_integrations_user_id ON public.ical_integrations(user_id);

-- Table for storing individual iCalendar events
CREATE TABLE public.ical_events (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  ical_integration_id uuid NOT NULL REFERENCES public.ical_integrations(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  start_date_time TIMESTAMPTZ NOT NULL,
  end_date_time TIMESTAMPTZ NOT NULL,
  rrule TEXT,
  original_event_id TEXT, -- UID from VEVENT
  original_event_start_time TIMESTAMPTZ, -- DTSTART from VEVENT (for recurring instances)
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.ical_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can select their own ical events" 
ON public.ical_events FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own ical events" -- if sync is client-driven
ON public.ical_events FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own ical events" -- if sync is client-driven
ON public.ical_events FOR UPDATE 
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own ical events" -- if sync is client-driven
ON public.ical_events FOR DELETE 
USING (auth.uid() = user_id);

CREATE INDEX idx_ical_events_user_id ON public.ical_events(user_id);
CREATE INDEX idx_ical_events_integration_id ON public.ical_events(ical_integration_id);
CREATE INDEX idx_ical_events_start_time ON public.ical_events(start_date_time);
CREATE INDEX idx_ical_events_original_event_id ON public.ical_events(original_event_id);

-- Function to update 'updated_at' timestamp automatically
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_ical_integrations_updated_at
BEFORE UPDATE ON public.ical_integrations
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_ical_events_updated_at
BEFORE UPDATE ON public.ical_events
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column(); 