-- Add activity_type column to the timeblocks table
ALTER TABLE public.timeblocks
ADD COLUMN IF NOT EXISTS activity_type TEXT;

-- Add an index if this column will be frequently queried or filtered on
-- CREATE INDEX IF NOT EXISTS idx_timeblocks_activity_type ON public.timeblocks(activity_type);

-- Note: Since activityType is nullable in the model (String?),
-- the database column should also be nullable (TEXT without NOT NULL).
