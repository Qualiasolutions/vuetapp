-- Make icon column nullable in entity_subcategories
ALTER TABLE public.entity_subcategories
ALTER COLUMN icon DROP NOT NULL;

COMMENT ON COLUMN public.entity_subcategories.icon IS 'Icon identifier for the subcategory. Can be NULL if no specific icon is assigned.'; 