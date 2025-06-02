-- Add subcategory_id to entities table
ALTER TABLE public.entities
ADD COLUMN IF NOT EXISTS subcategory_id UUID;

-- Add foreign key constraint to entity_subcategories table
-- Assuming entity_subcategories table exists and has a UUID primary key 'id'
ALTER TABLE public.entities
ADD CONSTRAINT fk_entities_subcategory
FOREIGN KEY (subcategory_id)
REFERENCES public.entity_subcategories(id)
ON DELETE SET NULL;

-- Add index for performance
CREATE INDEX IF NOT EXISTS idx_entities_subcategory_id
ON public.entities(subcategory_id);

COMMENT ON COLUMN public.entities.subcategory_id IS 'Foreign key to the entity_subcategories table, linking an entity to a specific subcategory.'; 