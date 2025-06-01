-- Fix RLS performance issues for profiles table
-- This addresses Supabase advisor warnings about auth function re-evaluation and multiple permissive policies

-- Drop all existing policies to start clean
DROP POLICY IF EXISTS "Users can view their own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.profiles;
DROP POLICY IF EXISTS "profiles_select_own" ON public.profiles;
DROP POLICY IF EXISTS "profiles_update_own" ON public.profiles;
DROP POLICY IF EXISTS "profiles_insert_own" ON public.profiles;
DROP POLICY IF EXISTS "Profiles view policy" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Allow anyone to insert profiles" ON public.profiles;

-- Create optimized RLS policies with proper auth function usage
-- Using (select auth.uid()) instead of auth.uid() to avoid re-evaluation per row

-- Policy for viewing own profile
CREATE POLICY "profiles_select_policy" ON public.profiles
FOR SELECT USING (id = (select auth.uid()));

-- Policy for updating own profile
CREATE POLICY "profiles_update_policy" ON public.profiles
FOR UPDATE USING (id = (select auth.uid()));

-- Policy for inserting own profile
CREATE POLICY "profiles_insert_policy" ON public.profiles
FOR INSERT WITH CHECK (id = (select auth.uid()));

-- Policy for deleting own profile (if needed)
CREATE POLICY "profiles_delete_policy" ON public.profiles
FOR DELETE USING (id = (select auth.uid()));

-- Ensure RLS is enabled
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Grant necessary permissions (ensure clean permissions)
REVOKE ALL ON TABLE public.profiles FROM anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.profiles TO authenticated;
GRANT SELECT ON TABLE public.profiles TO anon; -- Allow anon to read for public profiles if needed

-- Add comment for documentation
COMMENT ON TABLE public.profiles IS 'User profiles with optimized RLS policies to prevent auth function re-evaluation';
