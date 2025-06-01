-- Remove unused indexes that are not currently needed
-- This addresses Supabase advisor INFO warnings about unused indexes
-- Keep indexes that may be needed for core functionality even if not currently used

-- Remove unused indexes that are clearly not needed in current implementation

-- Remove unused family_id index from profiles (family features not fully implemented yet)
DROP INDEX IF EXISTS idx_profiles_family_id;

-- Remove unused professional category index (professional features minimal)
DROP INDEX IF EXISTS idx_entity_categories_created_by;

-- Remove unused subscription indexes (subscription features not implemented)
DROP INDEX IF EXISTS idx_subscriptions_plan_type;

-- Remove unused task category created_by index (not using created_by tracking for categories)
DROP INDEX IF EXISTS idx_task_categories_created_by;

-- Keep other indexes even if unused as they are likely needed for:
-- - Core list functionality (list_items, lists indexes)
-- - Task management (tasks indexes) 
-- - Routine functionality (routine_task_templates indexes)
-- - Chat/LANA features (chat_messages indexes)
-- - Family/group features (when implemented)
-- - Shopping features (shopping_list_delegations indexes)
-- - Setup completion tracking

-- Add comment for documentation
COMMENT ON SCHEMA public IS 'Cleaned up unused indexes while preserving those needed for core functionality';
