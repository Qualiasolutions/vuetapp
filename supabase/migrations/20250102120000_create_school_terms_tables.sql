-- Create School Terms Tables Migration
-- This migration creates the database tables for the school terms management system

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create school_years table
CREATE TABLE public.school_years (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    start_date date NOT NULL,
    end_date date NOT NULL,
    school_id uuid NOT NULL REFERENCES public.entities(id) ON DELETE CASCADE,
    year varchar(63) NOT NULL DEFAULT '',
    show_on_calendars boolean NOT NULL DEFAULT false,
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    
    -- Constraints
    CONSTRAINT school_years_date_order CHECK (start_date < end_date),
    CONSTRAINT school_years_year_not_empty CHECK (year != '')
);

-- Create school_terms table
CREATE TABLE public.school_terms (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name varchar(127) NOT NULL DEFAULT '',
    start_date date NOT NULL,
    end_date date NOT NULL,
    school_year_id uuid NOT NULL REFERENCES public.school_years(id) ON DELETE CASCADE,
    show_on_calendars boolean NOT NULL DEFAULT false,
    show_only_start_and_end boolean NOT NULL DEFAULT true,
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    
    -- Constraints
    CONSTRAINT school_terms_date_order CHECK (start_date < end_date),
    CONSTRAINT school_terms_name_not_empty CHECK (name != '')
);

-- Create school_breaks table
CREATE TABLE public.school_breaks (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name varchar(127) NOT NULL DEFAULT '',
    start_date date NOT NULL,
    end_date date NOT NULL,
    school_year_id uuid NOT NULL REFERENCES public.school_years(id) ON DELETE CASCADE,
    show_on_calendars boolean NOT NULL DEFAULT false,
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    
    -- Constraints
    CONSTRAINT school_breaks_date_order CHECK (start_date < end_date),
    CONSTRAINT school_breaks_name_not_empty CHECK (name != '')
);

-- Create indexes for performance
CREATE INDEX idx_school_years_user_id ON public.school_years (user_id);
CREATE INDEX idx_school_years_school_id ON public.school_years (school_id);
CREATE INDEX idx_school_years_start_date ON public.school_years (start_date);
CREATE INDEX idx_school_years_show_on_calendars ON public.school_years (show_on_calendars);

CREATE INDEX idx_school_terms_user_id ON public.school_terms (user_id);
CREATE INDEX idx_school_terms_school_year_id ON public.school_terms (school_year_id);
CREATE INDEX idx_school_terms_start_date ON public.school_terms (start_date);
CREATE INDEX idx_school_terms_show_on_calendars ON public.school_terms (show_on_calendars);

CREATE INDEX idx_school_breaks_user_id ON public.school_breaks (user_id);
CREATE INDEX idx_school_breaks_school_year_id ON public.school_breaks (school_year_id);
CREATE INDEX idx_school_breaks_start_date ON public.school_breaks (start_date);
CREATE INDEX idx_school_breaks_show_on_calendars ON public.school_breaks (show_on_calendars);

-- Enable Row Level Security (RLS)
ALTER TABLE public.school_years ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.school_terms ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.school_breaks ENABLE ROW LEVEL SECURITY;

-- RLS Policies for school_years
CREATE POLICY "Users can view their own school years" ON public.school_years
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create school years" ON public.school_years
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own school years" ON public.school_years
FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own school years" ON public.school_years
FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for school_terms
CREATE POLICY "Users can view their own school terms" ON public.school_terms
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create school terms" ON public.school_terms
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own school terms" ON public.school_terms
FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own school terms" ON public.school_terms
FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for school_breaks
CREATE POLICY "Users can view their own school breaks" ON public.school_breaks
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create school breaks" ON public.school_breaks
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own school breaks" ON public.school_breaks
FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own school breaks" ON public.school_breaks
FOR DELETE USING (auth.uid() = user_id);

-- Set up triggers for updated_at timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_school_years_updated_at BEFORE UPDATE ON public.school_years
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_school_terms_updated_at BEFORE UPDATE ON public.school_terms
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_school_breaks_updated_at BEFORE UPDATE ON public.school_breaks
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Add helpful comments
COMMENT ON TABLE public.school_years IS 'Stores academic years for schools';
COMMENT ON TABLE public.school_terms IS 'Stores academic terms within school years';
COMMENT ON TABLE public.school_breaks IS 'Stores breaks/holidays within school years';

COMMENT ON COLUMN public.school_years.school_id IS 'References the school entity';
COMMENT ON COLUMN public.school_terms.school_year_id IS 'References the parent school year';
COMMENT ON COLUMN public.school_breaks.school_year_id IS 'References the parent school year';
COMMENT ON COLUMN public.school_terms.show_only_start_and_end IS 'Whether to show full duration or just start/end dates on calendars'; 