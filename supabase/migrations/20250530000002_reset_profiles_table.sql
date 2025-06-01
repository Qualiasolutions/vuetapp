-- Reset profiles table for simplified authentication
-- This migration only affects the public.profiles table

-- 1. Drop existing policies on profiles
DROP POLICY IF EXISTS "Users can view their own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.profiles;
DROP POLICY IF EXISTS "profiles_select_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_update_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_insert_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_delete_policy" ON public.profiles;

-- 2. Drop existing trigger on profiles table
DROP TRIGGER IF EXISTS update_profiles_updated_at ON public.profiles;

-- 3. Drop and recreate profiles table with simplified structure
DROP TABLE IF EXISTS public.profiles CASCADE;

CREATE TABLE public.profiles (
    id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email text UNIQUE NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    account_type text NOT NULL DEFAULT 'personal' CHECK (account_type IN ('personal', 'professional')),
    professional_category_id uuid,
    phone text,
    professional_email text,
    professional_phone text,
    date_of_birth date,
    member_color text DEFAULT '#0066cc',
    family_role text DEFAULT 'owner' CHECK (family_role IN ('owner', 'member')),
    family_id uuid,
    onboarding_completed boolean DEFAULT false,
    subscription_status text DEFAULT 'free' CHECK (subscription_status IN ('free', 'premium', 'family')),
    avatar_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

-- 4. Enable Row Level Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 5. Grant proper permissions
GRANT USAGE ON SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON TABLE public.profiles TO postgres, service_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.profiles TO authenticated;

-- 6. Create simplified RLS policies
CREATE POLICY "profiles_select_policy" ON public.profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "profiles_insert_policy" ON public.profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "profiles_update_policy" ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "profiles_delete_policy" ON public.profiles
    FOR DELETE USING (auth.uid() = id);

-- 7. Create indexes for performance
CREATE INDEX idx_profiles_email ON public.profiles (email);
CREATE INDEX idx_profiles_family_id ON public.profiles (family_id);
CREATE INDEX idx_profiles_account_type ON public.profiles (account_type);

-- 8. Use existing update_updated_at_column function for profiles updated_at trigger
CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 9. Ensure service_role can bypass RLS when needed
ALTER TABLE public.profiles FORCE ROW LEVEL SECURITY;

-- 10. Add helpful comments
COMMENT ON TABLE public.profiles IS 'User profiles with simplified authentication';
