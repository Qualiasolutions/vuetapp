-- Add missing indexes for foreign keys to improve query performance
-- This addresses Supabase advisor INFO warnings about unindexed foreign keys

-- Add index for entity_subcategories.category_id foreign key
CREATE INDEX IF NOT EXISTS idx_entity_subcategories_category_id 
ON public.entity_subcategories (category_id);

-- Add index for lists.owner_id foreign key  
CREATE INDEX IF NOT EXISTS idx_lists_owner_id 
ON public.lists (owner_id);

-- Add comments for documentation
COMMENT ON INDEX idx_entity_subcategories_category_id IS 'Index for entity_subcategories.category_id foreign key to improve JOIN performance';
COMMENT ON INDEX idx_lists_owner_id IS 'Index for lists.owner_id foreign key to improve user-specific list queries';
