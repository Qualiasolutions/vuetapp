-- Create the entities table
CREATE TABLE public.entities (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    description text,
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    category_id uuid REFERENCES public.entity_categories(id) ON DELETE SET NULL,
    image_url text,
    parent_id uuid REFERENCES public.entities(id) ON DELETE SET NULL,
    subtype text NOT NULL, -- Corresponds to EntitySubtype enum
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_hidden boolean DEFAULT false,
    custom_fields jsonb,
    attachments text[],
    due_date timestamp with time zone,
    status text,
    linked_task_id uuid, -- For future integration
    linked_routine_id uuid -- For future integration
);

-- Add indexes for performance
CREATE INDEX idx_entities_user_id ON public.entities (user_id);
CREATE INDEX idx_entities_category_id ON public.entities (category_id);
CREATE INDEX idx_entities_parent_id ON public.entities (parent_id);
CREATE INDEX idx_entities_subtype ON public.entities (subtype);

-- Enable Row Level Security (RLS)
ALTER TABLE public.entities ENABLE ROW LEVEL SECURITY;

-- Policy for users to view their own entities
CREATE POLICY "Users can view their own entities." ON public.entities
FOR SELECT USING (auth.uid() = user_id);

-- Policy for users to create their own entities
CREATE POLICY "Users can create entities." ON public.entities
FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Policy for users to update their own entities
CREATE POLICY "Users can update their own entities." ON public.entities
FOR UPDATE USING (auth.uid() = user_id);

-- Policy for users to delete their own entities
CREATE POLICY "Users can delete their own entities." ON public.entities
FOR DELETE USING (auth.uid() = user_id);

-- Set up trigger for updated_at
CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.entities
FOR EACH ROW EXECUTE FUNCTION moddatetime('updated_at');
