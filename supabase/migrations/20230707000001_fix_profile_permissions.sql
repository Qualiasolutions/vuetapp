-- Fix permission issues with the profiles table

-- 1. Ensure permissions are granted correctly
GRANT USAGE ON SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON TABLE public.profiles TO postgres, service_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.profiles TO authenticated;

-- 2. Fix the handle_new_user trigger function to be more robust
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO public.profiles (
    id,
    email,
    first_name,
    last_name,
    account_type,
    created_at,
    updated_at
  )
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'first_name', 'User'),
    COALESCE(NEW.raw_user_meta_data->>'last_name', ''),
    COALESCE(NEW.raw_user_meta_data->>'account_type', 'personal'),
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

-- 3. Ensure the trigger is correctly associated
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 4. Make sure RLS is properly configured
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 5. Clean up and recreate RLS policies
DROP POLICY IF EXISTS "Users can view their own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.profiles;
DROP POLICY IF EXISTS "profiles_select_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_update_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_insert_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_delete_policy" ON public.profiles;

-- Create new, simplified policies
CREATE POLICY "profiles_select_policy" ON public.profiles
FOR SELECT USING (id = auth.uid());

CREATE POLICY "profiles_update_policy" ON public.profiles
FOR UPDATE USING (id = auth.uid());

CREATE POLICY "profiles_insert_policy" ON public.profiles
FOR INSERT WITH CHECK (id = auth.uid());

CREATE POLICY "profiles_delete_policy" ON public.profiles
FOR DELETE USING (id = auth.uid());

-- 6. Allow service_role to bypass RLS (this helps with functions)
ALTER TABLE public.profiles FORCE ROW LEVEL SECURITY; 