-- Migration to standardize owner_id fields across all tables
-- This ensures consistency between entities (user_id) and entity_categories (owner_id)

-- Rename user_id to owner_id in entities table
ALTER TABLE public.entities 
RENAME COLUMN user_id TO owner_id;

-- Drop the old index on user_id and create new one on owner_id
DROP INDEX IF EXISTS idx_entities_user_id;
CREATE INDEX idx_entities_owner_id ON public.entities (owner_id);

-- Update RLS policies for entities table to use owner_id instead of user_id
DROP POLICY IF EXISTS "Users can view their own entities." ON public.entities;
DROP POLICY IF EXISTS "Users can create entities." ON public.entities;
DROP POLICY IF EXISTS "Users can update their own entities." ON public.entities;
DROP POLICY IF EXISTS "Users can delete their own entities." ON public.entities;

-- Create new RLS policies using owner_id
CREATE POLICY "Users can view their own entities." ON public.entities
FOR SELECT USING (auth.uid() = owner_id);

CREATE POLICY "Users can create entities." ON public.entities
FOR INSERT WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can update their own entities." ON public.entities
FOR UPDATE USING (auth.uid() = owner_id);

CREATE POLICY "Users can delete their own entities." ON public.entities
FOR DELETE USING (auth.uid() = owner_id);
