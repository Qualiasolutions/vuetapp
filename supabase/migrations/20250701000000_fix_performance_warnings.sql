-- Fix Database Performance Warnings Migration
-- This migration addresses performance warnings from Supabase linter:
-- 1. Auth RLS Initialization Plan warnings - optimize auth.uid() calls
-- 2. Multiple Permissive Policies warnings - consolidate redundant policies

-- ============================================================================
-- 1. Fix auth.uid() performance in RLS policies by using (select auth.uid())
-- ============================================================================

-- Fix for student_entities table
DROP POLICY IF EXISTS "Users can manage their own student entities" ON public.student_entities;
CREATE POLICY "Users can manage their own student entities" 
ON public.student_entities 
USING (owner_id = (SELECT auth.uid()))
WITH CHECK (owner_id = (SELECT auth.uid()));

-- Fix for school_entities table
DROP POLICY IF EXISTS "Users can manage their own school entities" ON public.school_entities;
CREATE POLICY "Users can manage their own school entities" 
ON public.school_entities 
USING (owner_id = (SELECT auth.uid()))
WITH CHECK (owner_id = (SELECT auth.uid()));

-- Fix for school_term_entities table
DROP POLICY IF EXISTS "Users can manage their own school term entities" ON public.school_term_entities;
CREATE POLICY "Users can manage their own school term entities" 
ON public.school_term_entities 
USING (owner_id = (SELECT auth.uid()))
WITH CHECK (owner_id = (SELECT auth.uid()));

-- Fix for academic_plan_entities table
DROP POLICY IF EXISTS "Users can manage their own academic plan entities" ON public.academic_plan_entities;
CREATE POLICY "Users can manage their own academic plan entities" 
ON public.academic_plan_entities 
USING (owner_id = (SELECT auth.uid()))
WITH CHECK (owner_id = (SELECT auth.uid()));

-- Fix for school_break_entities table
DROP POLICY IF EXISTS "Users can manage their own school break entities" ON public.school_break_entities;
CREATE POLICY "Users can manage their own school break entities" 
ON public.school_break_entities 
USING (owner_id = (SELECT auth.uid()))
WITH CHECK (owner_id = (SELECT auth.uid()));

-- Fix for birthdays table
DROP POLICY IF EXISTS "Allow_all_access_for_user_own_birthdays" ON public.birthdays;
CREATE POLICY "Allow_all_access_for_user_own_birthdays" 
ON public.birthdays 
USING (user_id = (SELECT auth.uid()))
WITH CHECK (user_id = (SELECT auth.uid()));

-- ============================================================================
-- 2. Fix multiple permissive policies by consolidating redundant policies
-- ============================================================================

-- Fix for entity_categories table - consolidate SELECT policies
DROP POLICY IF EXISTS "Entity categories write policy" ON public.entity_categories;
DROP POLICY IF EXISTS "Entity categories access policy" ON public.entity_categories;
CREATE POLICY "Entity categories access policy" 
ON public.entity_categories 
FOR SELECT 
USING (public OR owner_id = (SELECT auth.uid()));

-- ============================================================================
-- Fix for school_entities - consolidate multiple policies into single policies per action
-- ============================================================================

-- Drop redundant policies
DROP POLICY IF EXISTS "Users can view their school entities" ON public.school_entities;
DROP POLICY IF EXISTS "Users can insert their school entities" ON public.school_entities;
DROP POLICY IF EXISTS "Users can update their school entities" ON public.school_entities;
DROP POLICY IF EXISTS "Users can delete their school entities" ON public.school_entities;

-- The "Users can manage their own school entities" policy is now the only policy and handles all actions

-- ============================================================================
-- Fix for school_term_entities - consolidate multiple policies into single policies per action
-- ============================================================================

-- Drop redundant policies
DROP POLICY IF EXISTS "Users can view their school term entities" ON public.school_term_entities;
DROP POLICY IF EXISTS "Users can insert their school term entities" ON public.school_term_entities;
DROP POLICY IF EXISTS "Users can update their school term entities" ON public.school_term_entities;
DROP POLICY IF EXISTS "Users can delete their school term entities" ON public.school_term_entities;

-- The "Users can manage their own school term entities" policy is now the only policy and handles all actions

-- ============================================================================
-- Fix for student_entities - consolidate multiple policies into single policies per action
-- ============================================================================

-- Drop redundant policies
DROP POLICY IF EXISTS "Users can view their student entities" ON public.student_entities;
DROP POLICY IF EXISTS "Users can insert their student entities" ON public.student_entities;
DROP POLICY IF EXISTS "Users can update their student entities" ON public.student_entities;
DROP POLICY IF EXISTS "Users can delete their student entities" ON public.student_entities;

-- The "Users can manage their own student entities" policy is now the only policy and handles all actions 