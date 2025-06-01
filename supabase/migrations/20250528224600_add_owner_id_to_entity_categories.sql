-- Add owner_id column to entity_categories table
ALTER TABLE public.entity_categories
ADD COLUMN IF NOT EXISTS owner_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;

-- Add an index for performance on owner_id
CREATE INDEX IF NOT EXISTS idx_entity_categories_owner_id ON public.entity_categories(owner_id);

-- Enable Row Level Security (RLS) on the table if not already enabled
ALTER TABLE public.entity_categories ENABLE ROW LEVEL SECURITY;

-- Drop existing RLS policies for entity_categories if they exist to avoid conflicts
-- It's safer to drop and recreate, especially if the old policies might be incorrect or incomplete.
DROP POLICY IF EXISTS "Allow authenticated users to read categories" ON public.entity_categories;
DROP POLICY IF EXISTS "Allow individual insert access" ON public.entity_categories;
DROP POLICY IF EXISTS "Allow individual update access" ON public.entity_categories;
DROP POLICY IF EXISTS "Allow individual delete access" ON public.entity_categories;
DROP POLICY IF EXISTS "Allow select for owner" ON public.entity_categories;
DROP POLICY IF EXISTS "Allow insert for owner" ON public.entity_categories;
DROP POLICY IF EXISTS "Allow update for owner" ON public.entity_categories;
DROP POLICY IF EXISTS "Allow delete for owner" ON public.entity_categories;
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON public.entity_categories;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.entity_categories;
DROP POLICY IF EXISTS "Enable update for authenticated users" ON public.entity_categories;
DROP POLICY IF EXISTS "Enable delete for authenticated users" ON public.entity_categories;


-- RLS Policies for entity_categories
-- 1. Allow users to select their own categories.
CREATE POLICY "Allow select for owner"
ON public.entity_categories
FOR SELECT
USING (auth.uid() = owner_id);

-- 2. Allow users to insert categories for themselves.
CREATE POLICY "Allow insert for owner"
ON public.entity_categories
FOR INSERT
WITH CHECK (auth.uid() = owner_id);

-- 3. Allow users to update their own categories.
CREATE POLICY "Allow update for owner"
ON public.entity_categories
FOR UPDATE
USING (auth.uid() = owner_id)
WITH CHECK (auth.uid() = owner_id);

-- 4. Allow users to delete their own categories.
CREATE POLICY "Allow delete for owner"
ON public.entity_categories
FOR DELETE
USING (auth.uid() = owner_id);

-- Grant usage on schema public and auth to postgres and anon, service_role
GRANT USAGE ON SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT USAGE ON SCHEMA auth TO postgres, anon, authenticated, service_role;

-- Grant all privileges on table entity_categories to postgres and service_role
GRANT ALL ON TABLE public.entity_categories TO postgres, service_role;

-- Grant select, insert, update, delete privileges to authenticated users
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.entity_categories TO authenticated;

-- Grant select to anon users (if you want public read access, otherwise remove or modify)
-- For categories, it's common to restrict read to owners or specific sharing rules.
-- If categories are not meant to be public, this policy should be more restrictive or removed.
-- For now, assuming categories are owner-specific.
-- GRANT SELECT ON TABLE public.entity_categories TO anon;

-- Ensure the owner_id is populated for existing rows if necessary.
-- This depends on application logic. If categories can exist without owners (e.g. system defaults),
-- this step might need adjustment or be handled by a backfill script.
-- For now, we assume new categories will have owner_id, and existing ones might need manual update or a default.
-- Example: UPDATE public.entity_categories SET owner_id = auth.uid() WHERE owner_id IS NULL;
-- This is a placeholder; actual backfill logic depends on requirements.
