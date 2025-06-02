-- Add unique constraint to entity_subcategories.name
ALTER TABLE public.entity_subcategories
ADD CONSTRAINT entity_subcategories_name_unique UNIQUE (name);

COMMENT ON CONSTRAINT entity_subcategories_name_unique ON public.entity_subcategories IS 'Ensures that the name of each entity subcategory is unique.'; 