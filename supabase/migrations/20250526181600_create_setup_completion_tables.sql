per-- Create category setup completions table
CREATE TABLE IF NOT EXISTS category_setup_completions (
  id SERIAL PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  category_id TEXT NOT NULL,
  completed_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, category_id)
);

-- Create entity type setup completions table
CREATE TABLE IF NOT EXISTS entity_type_setup_completions (
  id SERIAL PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  entity_type_name TEXT NOT NULL,
  completed_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, entity_type_name)
);

-- Enable RLS
ALTER TABLE category_setup_completions ENABLE ROW LEVEL SECURITY;
ALTER TABLE entity_type_setup_completions ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for category_setup_completions
CREATE POLICY "Users can view their own category setup completions" ON category_setup_completions
  FOR SELECT USING ((SELECT auth.uid()) = user_id);

CREATE POLICY "Users can insert their own category setup completions" ON category_setup_completions
  FOR INSERT WITH CHECK ((SELECT auth.uid()) = user_id);

CREATE POLICY "Users can update their own category setup completions" ON category_setup_completions
  FOR UPDATE USING ((SELECT auth.uid()) = user_id);

CREATE POLICY "Users can delete their own category setup completions" ON category_setup_completions
  FOR DELETE USING ((SELECT auth.uid()) = user_id);

-- Create RLS policies for entity_type_setup_completions
CREATE POLICY "Users can view their own entity type setup completions" ON entity_type_setup_completions
  FOR SELECT USING ((SELECT auth.uid()) = user_id);

CREATE POLICY "Users can insert their own entity type setup completions" ON entity_type_setup_completions
  FOR INSERT WITH CHECK ((SELECT auth.uid()) = user_id);

CREATE POLICY "Users can update their own entity type setup completions" ON entity_type_setup_completions
  FOR UPDATE USING ((SELECT auth.uid()) = user_id);

CREATE POLICY "Users can delete their own entity type setup completions" ON entity_type_setup_completions
  FOR DELETE USING ((SELECT auth.uid()) = user_id);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_category_setup_completions_user_id ON category_setup_completions(user_id);
CREATE INDEX IF NOT EXISTS idx_category_setup_completions_category_id ON category_setup_completions(category_id);
CREATE INDEX IF NOT EXISTS idx_entity_type_setup_completions_user_id ON entity_type_setup_completions(user_id);
CREATE INDEX IF NOT EXISTS idx_entity_type_setup_completions_entity_type ON entity_type_setup_completions(entity_type_name);
