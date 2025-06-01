-- References Management System Database Schema
-- Run this script in your Supabase SQL editor to create the required tables

-- Create extension for UUID generation if not exists
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create reference_groups table
CREATE TABLE IF NOT EXISTS public.reference_groups (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  owner_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Create references table
CREATE TABLE IF NOT EXISTS public.references (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  reference_group_id UUID REFERENCES public.reference_groups(id) ON DELETE SET NULL,
  owner_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Create entity_references junction table
-- Note: This assumes you have an 'entities' table. 
-- If not, you can create it or modify the reference as needed.
CREATE TABLE IF NOT EXISTS public.entity_references (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  entity_id UUID NOT NULL, -- You may need to add proper foreign key reference later
  reference_id UUID REFERENCES public.references(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE(entity_id, reference_id)
);

-- Enable Row Level Security (RLS) on all tables
ALTER TABLE public.reference_groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.references ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.entity_references ENABLE ROW LEVEL SECURITY;

-- RLS policies for reference_groups
CREATE POLICY "Reference groups are viewable by owner"
  ON public.reference_groups FOR SELECT
  USING (owner_id = auth.uid());

CREATE POLICY "Reference groups can be created by authenticated users"
  ON public.reference_groups FOR INSERT
  WITH CHECK (owner_id = auth.uid());

CREATE POLICY "Reference groups can be updated by owner"
  ON public.reference_groups FOR UPDATE
  USING (owner_id = auth.uid());

CREATE POLICY "Reference groups can be deleted by owner"
  ON public.reference_groups FOR DELETE
  USING (owner_id = auth.uid());

-- RLS policies for references
CREATE POLICY "References are viewable by owner"
  ON public.references FOR SELECT
  USING (owner_id = auth.uid());

CREATE POLICY "References can be created by authenticated users"
  ON public.references FOR INSERT
  WITH CHECK (owner_id = auth.uid());

CREATE POLICY "References can be updated by owner"
  ON public.references FOR UPDATE
  USING (owner_id = auth.uid());

CREATE POLICY "References can be deleted by owner"
  ON public.references FOR DELETE
  USING (owner_id = auth.uid());

-- RLS policies for entity_references
-- Note: These policies assume entities table has a 'created_by' or 'owner_id' column
-- Modify accordingly based on your entities table structure
CREATE POLICY "Entity references are viewable by entity owner"
  ON public.entity_references FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.entities 
      WHERE entities.id = entity_references.entity_id 
      AND (entities.created_by = auth.uid() OR entities.owner_id = auth.uid())
    )
  );

CREATE POLICY "Entity references can be created by entity owner"
  ON public.entity_references FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.entities 
      WHERE entities.id = entity_references.entity_id 
      AND (entities.created_by = auth.uid() OR entities.owner_id = auth.uid())
    )
  );

CREATE POLICY "Entity references can be deleted by entity owner"
  ON public.entity_references FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.entities 
      WHERE entities.id = entity_references.entity_id 
      AND (entities.created_by = auth.uid() OR entities.owner_id = auth.uid())
    )
  );

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_references_group_id ON public.references(reference_group_id);
CREATE INDEX IF NOT EXISTS idx_references_owner_id ON public.references(owner_id);
CREATE INDEX IF NOT EXISTS idx_references_name ON public.references(name);
CREATE INDEX IF NOT EXISTS idx_reference_groups_owner_id ON public.reference_groups(owner_id);
CREATE INDEX IF NOT EXISTS idx_reference_groups_name ON public.reference_groups(name);
CREATE INDEX IF NOT EXISTS idx_entity_references_entity_id ON public.entity_references(entity_id);
CREATE INDEX IF NOT EXISTS idx_entity_references_reference_id ON public.entity_references(reference_id);

-- Insert some sample data (optional - remove if not needed)
-- This will create some example reference groups and references
INSERT INTO public.reference_groups (name, owner_id) 
SELECT 'Colors', auth.uid()
WHERE NOT EXISTS (
  SELECT 1 FROM public.reference_groups 
  WHERE name = 'Colors' AND owner_id = auth.uid()
);

INSERT INTO public.reference_groups (name, owner_id) 
SELECT 'Priority Levels', auth.uid()
WHERE NOT EXISTS (
  SELECT 1 FROM public.reference_groups 
  WHERE name = 'Priority Levels' AND owner_id = auth.uid()
);

-- Sample references for the Colors group
INSERT INTO public.references (name, reference_group_id, owner_id)
SELECT 'Red', rg.id, auth.uid()
FROM public.reference_groups rg
WHERE rg.name = 'Colors' AND rg.owner_id = auth.uid()
AND NOT EXISTS (
  SELECT 1 FROM public.references r
  WHERE r.name = 'Red' AND r.reference_group_id = rg.id
);

INSERT INTO public.references (name, reference_group_id, owner_id)
SELECT 'Blue', rg.id, auth.uid()
FROM public.reference_groups rg
WHERE rg.name = 'Colors' AND rg.owner_id = auth.uid()
AND NOT EXISTS (
  SELECT 1 FROM public.references r
  WHERE r.name = 'Blue' AND r.reference_group_id = rg.id
);

INSERT INTO public.references (name, reference_group_id, owner_id)
SELECT 'Green', rg.id, auth.uid()
FROM public.reference_groups rg
WHERE rg.name = 'Colors' AND rg.owner_id = auth.uid()
AND NOT EXISTS (
  SELECT 1 FROM public.references r
  WHERE r.name = 'Green' AND r.reference_group_id = rg.id
);

-- Sample references for the Priority Levels group
INSERT INTO public.references (name, reference_group_id, owner_id)
SELECT 'High', rg.id, auth.uid()
FROM public.reference_groups rg
WHERE rg.name = 'Priority Levels' AND rg.owner_id = auth.uid()
AND NOT EXISTS (
  SELECT 1 FROM public.references r
  WHERE r.name = 'High' AND r.reference_group_id = rg.id
);

INSERT INTO public.references (name, reference_group_id, owner_id)
SELECT 'Medium', rg.id, auth.uid()
FROM public.reference_groups rg
WHERE rg.name = 'Priority Levels' AND rg.owner_id = auth.uid()
AND NOT EXISTS (
  SELECT 1 FROM public.references r
  WHERE r.name = 'Medium' AND r.reference_group_id = rg.id
);

INSERT INTO public.references (name, reference_group_id, owner_id)
SELECT 'Low', rg.id, auth.uid()
FROM public.reference_groups rg
WHERE rg.name = 'Priority Levels' AND rg.owner_id = auth.uid()
AND NOT EXISTS (
  SELECT 1 FROM public.references r
  WHERE r.name = 'Low' AND r.reference_group_id = rg.id
);

-- Add some ungrouped references as examples
INSERT INTO public.references (name, owner_id)
SELECT 'Active', auth.uid()
WHERE NOT EXISTS (
  SELECT 1 FROM public.references 
  WHERE name = 'Active' AND owner_id = auth.uid() AND reference_group_id IS NULL
);

INSERT INTO public.references (name, owner_id)
SELECT 'Inactive', auth.uid()
WHERE NOT EXISTS (
  SELECT 1 FROM public.references 
  WHERE name = 'Inactive' AND owner_id = auth.uid() AND reference_group_id IS NULL
);

-- Success message
SELECT 'References management system tables created successfully!' as result; 