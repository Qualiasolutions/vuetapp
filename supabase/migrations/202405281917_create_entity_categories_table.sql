-- Create the entity_categories table
CREATE TABLE public.entity_categories (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    description text,
    icon text,
    owner_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    color text,
    priority integer,
    last_accessed_at timestamp with time zone,
    is_professional boolean DEFAULT false NOT NULL,
    parent_id uuid REFERENCES public.entity_categories(id) ON DELETE SET NULL
);

-- Add indexes for performance
CREATE INDEX idx_entity_categories_owner_id ON public.entity_categories (owner_id);
CREATE INDEX idx_entity_categories_parent_id ON public.entity_categories (parent_id);

-- Enable Row Level Security (RLS)
ALTER TABLE public.entity_categories ENABLE ROW LEVEL SECURITY;

-- Policy for users to view their own categories
CREATE POLICY "Users can view their own entity categories." ON public.entity_categories
FOR SELECT USING (auth.uid() = owner_id);

-- Policy for users to create their own categories
CREATE POLICY "Users can create entity categories." ON public.entity_categories
FOR INSERT WITH CHECK (auth.uid() = owner_id);

-- Policy for users to update their own categories
CREATE POLICY "Users can update their own entity categories." ON public.entity_categories
FOR UPDATE USING (auth.uid() = owner_id);

-- Policy for users to delete their own categories
CREATE POLICY "Users can delete their own entity categories." ON public.entity_categories
FOR DELETE USING (auth.uid() = owner_id);

-- Set up trigger for updated_at
CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.entity_categories
FOR EACH ROW EXECUTE FUNCTION moddatetime('updated_at');
