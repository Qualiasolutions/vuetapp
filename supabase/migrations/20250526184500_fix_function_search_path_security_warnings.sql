-- Fix function search path security warnings by setting search_path explicitly
-- This migration addresses the Supabase linter warnings about mutable search_path

-- Update handle_new_user function with secure search_path
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
  -- Use a more efficient INSERT with minimal data
  -- Only insert essential fields to reduce processing time
  INSERT INTO public.profiles (
    id,
    email,
    first_name,
    last_name,
    account_type,
    subscription_status,
    onboarding_completed,
    member_color,
    family_role,
    family_id,
    created_at,
    updated_at
  )
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'first_name', ''),
    COALESCE(NEW.raw_user_meta_data->>'last_name', ''),
    COALESCE(NEW.raw_user_meta_data->>'account_type', 'personal'),
    'free',
    false,
    '#0066cc',
    'owner',
    NEW.id, -- Self-reference for family owners
    NOW(),
    NOW()
  )
  ON CONFLICT (id) DO NOTHING; -- Prevent duplicate key errors
  
  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Log the error but don't fail the auth user creation
    RAISE WARNING 'Failed to create profile for user %: %', NEW.id, SQLERRM;
    RETURN NEW;
END;
$$;

-- Update optimize_auth_connection_settings function with secure search_path
CREATE OR REPLACE FUNCTION public.optimize_auth_connection_settings()
RETURNS VOID
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
  -- Set statement timeout to prevent long-running queries
  PERFORM set_config('statement_timeout', '30s', false);
  
  -- Set lock timeout to prevent deadlocks
  PERFORM set_config('lock_timeout', '10s', false);
  
  -- Optimize work memory for better query performance
  PERFORM set_config('work_mem', '4MB', false);
END;
$$;

-- Update check_profile_exists function with secure search_path
CREATE OR REPLACE FUNCTION public.check_profile_exists(user_id UUID)
RETURNS BOOLEAN
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE id = user_id
  );
END;
$$;

-- Ensure the trigger is properly set up for handle_new_user
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Add comment explaining the security fix
COMMENT ON FUNCTION public.handle_new_user() IS 'Trigger function to create user profile after auth user creation. Fixed search_path security warning.';
COMMENT ON FUNCTION public.optimize_auth_connection_settings() IS 'Optimizes database connection settings for auth operations. Fixed search_path security warning.';
COMMENT ON FUNCTION public.check_profile_exists(UUID) IS 'Checks if a user profile exists for the given user ID. Fixed search_path security warning.';
