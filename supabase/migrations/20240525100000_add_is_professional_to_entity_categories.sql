-- Add is_professional column to entity_categories table
ALTER TABLE public.entity_categories
ADD COLUMN IF NOT EXISTS is_professional BOOLEAN DEFAULT false;

-- Optionally, you might want to update existing rows if they should have a specific default
-- For example, if all current categories are personal:
-- UPDATE public.entity_categories SET is_professional = false WHERE is_professional IS NULL;
