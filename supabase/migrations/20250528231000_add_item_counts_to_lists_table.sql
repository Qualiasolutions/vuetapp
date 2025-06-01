-- Add total_items and completed_items columns to the lists table
ALTER TABLE public.lists
ADD COLUMN IF NOT EXISTS total_items INTEGER NOT NULL DEFAULT 0,
ADD COLUMN IF NOT EXISTS completed_items INTEGER NOT NULL DEFAULT 0;

-- Optional: Add RLS policies if they were missed or need adjustment for these new columns
-- However, existing policies on the 'lists' table should generally cover new columns
-- unless specific per-column permissions are desired.
-- For now, we assume existing table-level RLS is sufficient.

-- Backfill existing rows if necessary (example: set to 0 if they are new)
-- UPDATE public.lists SET total_items = 0 WHERE total_items IS NULL;
-- UPDATE public.lists SET completed_items = 0 WHERE completed_items IS NULL;
-- Since we added NOT NULL DEFAULT 0, backfill for NULLs isn't strictly needed for new columns
-- but can be useful if the columns existed before without a default.
