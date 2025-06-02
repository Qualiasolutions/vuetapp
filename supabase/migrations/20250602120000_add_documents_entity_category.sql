-- Add 'Documents' to entity_categories table
INSERT INTO public.entity_categories (id, name, description, icon, color, created_at, updated_at, owner_id)
VALUES ('2c776088-c889-41c2-9963-5d6e7f8a9b0d', 'Documents', 'Category for managing various types of documents.', 'folder_icon', '#FFD700', NOW(), NOW(), NULL)
ON CONFLICT (id) DO NOTHING;

COMMENT ON TABLE public.entity_categories IS 'Main structural categories for entities (e.g., Pets, Home, Work, Documents).'; 