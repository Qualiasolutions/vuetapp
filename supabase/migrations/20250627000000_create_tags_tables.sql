-- 20250627000000_create_tags_tables.sql
-- Migration to add the tags system for "I WANT TO" functionality

-- Create tags table to store all available tags
CREATE TABLE IF NOT EXISTS public.tags (
    code TEXT PRIMARY KEY,
    label TEXT NOT NULL,
    -- entity_categories.id is UUID, so use the same type for FK
    category_id UUID REFERENCES public.entity_categories(id),
    icon_name TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Create entity_tags junction table for many-to-many relationship
CREATE TABLE IF NOT EXISTS public.entity_tags (
    entity_id   UUID NOT NULL REFERENCES public.entities(id) ON DELETE CASCADE,
    tag_code TEXT NOT NULL REFERENCES public.tags(code) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (entity_id, tag_code)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_entity_tags_entity_id   ON public.entity_tags USING btree (entity_id);
CREATE INDEX IF NOT EXISTS idx_entity_tags_tag_code ON public.entity_tags USING gin (tag_code gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_tags_category_id ON public.tags USING btree (category_id);

-- Enable the pg_trgm extension if not already enabled (for GIN index)
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Add trigger for updated_at timestamp on tags table
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_timestamp_tags
BEFORE UPDATE ON public.tags
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Set up RLS policies
ALTER TABLE public.tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.entity_tags ENABLE ROW LEVEL SECURITY;

-- Tags table policies (read-only for authenticated users)
CREATE POLICY "Allow read access for all authenticated users" ON public.tags
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow all access for service role" ON public.tags
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

-- Entity tags policies (entity owners or members can manage tags)
CREATE POLICY "Allow read access for entity owners or members" ON public.entity_tags
    FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.entities e
            LEFT JOIN public.entity_members em ON e.id = em.entity_id
            WHERE e.id = entity_id AND (e.owner = auth.uid() OR em.member = auth.uid())
        )
    );

CREATE POLICY "Allow insert for entity owners or members" ON public.entity_tags
    FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.entities e
            LEFT JOIN public.entity_members em ON e.id = em.entity_id
            WHERE e.id = entity_id AND (e.owner = auth.uid() OR em.member = auth.uid())
        )
    );

CREATE POLICY "Allow delete for entity owners or members" ON public.entity_tags
    FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.entities e
            LEFT JOIN public.entity_members em ON e.id = em.entity_id
            WHERE e.id = entity_id AND (e.owner = auth.uid() OR em.member = auth.uid())
        )
    );

CREATE POLICY "Allow all access for service role" ON public.entity_tags
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

-- Seed data for tags
INSERT INTO public.tags (code, label, category_id, icon_name) VALUES
-- Pet tags
('PETS__FEEDING', 'Feeding Schedule', (SELECT id FROM public.entity_categories WHERE name = 'PETS'), 'restaurant'),
('PETS__EXERCISE', 'Exercise', (SELECT id FROM public.entity_categories WHERE name = 'PETS'), 'directions_run'),
('PETS__GROOMING', 'Grooming', (SELECT id FROM public.entity_categories WHERE name = 'PETS'), 'content_cut'),
('PETS__HEALTH', 'Health', (SELECT id FROM public.entity_categories WHERE name = 'PETS'), 'favorite'),

-- Social Interest tags
('SOCIAL_INTERESTS__INFORMATION__PUBLIC', 'Social Information', (SELECT id FROM public.entity_categories WHERE name = 'SOCIAL_INTERESTS'), 'people'),
('SOCIAL_INTERESTS__BIRTHDAY', 'Birthday', (SELECT id FROM public.entity_categories WHERE name = 'SOCIAL_INTERESTS'), 'cake'),
('SOCIAL_INTERESTS__ANNIVERSARY', 'Anniversary', (SELECT id FROM public.entity_categories WHERE name = 'SOCIAL_INTERESTS'), 'auto_awesome'),
('SOCIAL_INTERESTS__HOLIDAY', 'Holiday', (SELECT id FROM public.entity_categories WHERE name = 'SOCIAL_INTERESTS'), 'celebration'),

-- Education tags
('EDUCATION__INFORMATION__PUBLIC', 'Education Information', (SELECT id FROM public.entity_categories WHERE name = 'EDUCATION'), 'school'),
('EDUCATION__ASSIGNMENT', 'Assignment', (SELECT id FROM public.entity_categories WHERE name = 'EDUCATION'), 'assignment'),
('EDUCATION__EXAM', 'Exam', (SELECT id FROM public.entity_categories WHERE name = 'EDUCATION'), 'quiz'),

-- Career tags
('CAREER__INFORMATION__PUBLIC', 'Career Information', (SELECT id FROM public.entity_categories WHERE name = 'CAREER'), 'work'),
('CAREER__MEETING', 'Meeting', (SELECT id FROM public.entity_categories WHERE name = 'CAREER'), 'meeting_room'),
('CAREER__DEADLINE', 'Deadline', (SELECT id FROM public.entity_categories WHERE name = 'CAREER'), 'event_busy'),

-- Travel tags
('TRAVEL__INFORMATION__PUBLIC', 'Travel Information', (SELECT id FROM public.entity_categories WHERE name = 'TRAVEL'), 'flight'),
('TRAVEL__BOOKING', 'Booking', (SELECT id FROM public.entity_categories WHERE name = 'TRAVEL'), 'book_online'),
('TRAVEL__PACKING', 'Packing', (SELECT id FROM public.entity_categories WHERE name = 'TRAVEL'), 'luggage'),

-- Health & Beauty tags
('HEALTH_BEAUTY__APPOINTMENT', 'Appointment', (SELECT id FROM public.entity_categories WHERE name = 'HEALTH_BEAUTY'), 'calendar_today'),
('HEALTH_BEAUTY__REMINDER', 'Reminder', (SELECT id FROM public.entity_categories WHERE name = 'HEALTH_BEAUTY'), 'alarm'),
('HEALTH_BEAUTY__MEDICATION', 'Medication', (SELECT id FROM public.entity_categories WHERE name = 'HEALTH_BEAUTY'), 'medication'),

-- Home tags
('HOME__INFORMATION__PUBLIC', 'Home Information', (SELECT id FROM public.entity_categories WHERE name = 'HOME'), 'home'),
('HOME__MAINTENANCE', 'Maintenance', (SELECT id FROM public.entity_categories WHERE name = 'HOME'), 'build'),
('HOME__CLEANING', 'Cleaning', (SELECT id FROM public.entity_categories WHERE name = 'HOME'), 'cleaning_services'),

-- Garden tags
('GARDEN__INFORMATION__PUBLIC', 'Garden Information', (SELECT id FROM public.entity_categories WHERE name = 'GARDEN'), 'local_florist'),
('GARDEN__MAINTENANCE', 'Maintenance', (SELECT id FROM public.entity_categories WHERE name = 'GARDEN'), 'grass'),
('GARDEN__PLANTING', 'Planting', (SELECT id FROM public.entity_categories WHERE name = 'GARDEN'), 'eco'),

-- Food tags
('FOOD__INFORMATION__PUBLIC', 'Food Information', (SELECT id FROM public.entity_categories WHERE name = 'FOOD'), 'restaurant_menu'),
('FOOD__SHOPPING', 'Shopping', (SELECT id FROM public.entity_categories WHERE name = 'FOOD'), 'shopping_cart'),
('FOOD__COOKING', 'Cooking', (SELECT id FROM public.entity_categories WHERE name = 'FOOD'), 'soup_kitchen'),

-- Laundry tags
('LAUNDRY__INFORMATION__PUBLIC', 'Laundry Information', (SELECT id FROM public.entity_categories WHERE name = 'LAUNDRY'), 'local_laundry_service'),
('LAUNDRY__WASHING', 'Washing', (SELECT id FROM public.entity_categories WHERE name = 'LAUNDRY'), 'wash'),
('LAUNDRY__IRONING', 'Ironing', (SELECT id FROM public.entity_categories WHERE name = 'LAUNDRY'), 'iron'),

-- Finance tags
('FINANCE__INFORMATION__PUBLIC', 'Finance Information', (SELECT id FROM public.entity_categories WHERE name = 'FINANCE'), 'account_balance_wallet'),
('FINANCE__PAYMENT', 'Payment', (SELECT id FROM public.entity_categories WHERE name = 'FINANCE'), 'payment'),
('FINANCE__BUDGET', 'Budget', (SELECT id FROM public.entity_categories WHERE name = 'FINANCE'), 'savings'),

-- Transport tags
('TRANSPORT__INFORMATION__PUBLIC', 'Transport Information', (SELECT id FROM public.entity_categories WHERE name = 'TRANSPORT'), 'directions_car'),
('TRANSPORT__MAINTENANCE', 'Maintenance', (SELECT id FROM public.entity_categories WHERE name = 'TRANSPORT'), 'build'),
('TRANSPORT__INSURANCE', 'Insurance', (SELECT id FROM public.entity_categories WHERE name = 'TRANSPORT'), 'policy'),

-- Charity & Religion tags (new)
('CHARITY_RELIGION__DONATION', 'Donation', (SELECT id FROM public.entity_categories WHERE name = 'CHARITY_RELIGION'), 'volunteer_activism'),
('CHARITY_RELIGION__EVENT', 'Event', (SELECT id FROM public.entity_categories WHERE name = 'CHARITY_RELIGION'), 'event'),
('CHARITY_RELIGION__SERVICE', 'Service', (SELECT id FROM public.entity_categories WHERE name = 'CHARITY_RELIGION'), 'church')

ON CONFLICT (code) DO UPDATE SET
    label = EXCLUDED.label,
    category_id = EXCLUDED.category_id,
    icon_name = EXCLUDED.icon_name,
    updated_at = now();
