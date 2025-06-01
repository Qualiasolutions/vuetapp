-- Fix Authentication and Profile Creation Issues
-- This migration addresses the foreign key constraint violations and missing RPC function

-- First, let's create the missing create_user_profile function that AuthService expects
CREATE OR REPLACE FUNCTION public.create_user_profile(
    p_user_id UUID,
    p_email TEXT,
    p_first_name TEXT,
    p_last_name TEXT,
    p_account_type TEXT DEFAULT 'personal',
    p_subscription_status TEXT DEFAULT 'free'
)
RETURNS JSON
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
DECLARE
    profile_record public.profiles%ROWTYPE;
    result JSON;
BEGIN
    -- Check if user exists in auth.users
    IF NOT EXISTS (SELECT 1 FROM auth.users WHERE id = p_user_id) THEN
        RETURN JSON_BUILD_OBJECT(
            'success', FALSE,
            'error', 'user_not_found',
            'message', 'Auth user not found'
        );
    END IF;

    -- Validate account_type
    IF p_account_type NOT IN ('personal', 'professional') THEN
        RETURN JSON_BUILD_OBJECT(
            'success', FALSE,
            'error', 'invalid_data',
            'message', 'Invalid account type'
        );
    END IF;

    -- Validate subscription_status
    IF p_subscription_status NOT IN ('free', 'premium', 'family') THEN
        RETURN JSON_BUILD_OBJECT(
            'success', FALSE,
            'error', 'invalid_data',
            'message', 'Invalid subscription status'
        );
    END IF;

    -- Insert or update profile
    INSERT INTO public.profiles (
        id,
        email,
        first_name,
        last_name,
        account_type,
        family_id,
        subscription_status,
        created_at,
        updated_at
    )
    VALUES (
        p_user_id,
        p_email,
        p_first_name,
        p_last_name,
        p_account_type,
        p_user_id, -- Self-reference for family owners
        p_subscription_status,
        NOW(),
        NOW()
    )
    ON CONFLICT (id) DO UPDATE SET
        email = EXCLUDED.email,
        first_name = EXCLUDED.first_name,
        last_name = EXCLUDED.last_name,
        account_type = EXCLUDED.account_type,
        subscription_status = EXCLUDED.subscription_status,
        updated_at = NOW()
    RETURNING * INTO profile_record;

    -- Return success with profile data
    RETURN JSON_BUILD_OBJECT(
        'success', TRUE,
        'profile', ROW_TO_JSON(profile_record)
    );

EXCEPTION
    WHEN unique_violation THEN
        RETURN JSON_BUILD_OBJECT(
            'success', FALSE,
            'error', 'email_already_exists',
            'message', 'An account with this email already exists'
        );
    WHEN foreign_key_violation THEN
        RETURN JSON_BUILD_OBJECT(
            'success', FALSE,
            'error', 'database_error',
            'message', 'User reference not found in authentication system'
        );
    WHEN check_violation THEN
        RETURN JSON_BUILD_OBJECT(
            'success', FALSE,
            'error', 'invalid_data',
            'message', 'Invalid data provided for user profile'
        );
    WHEN OTHERS THEN
        -- Log the error details
        RAISE WARNING 'Failed to create/update profile for user %: % - %', p_user_id, SQLSTATE, SQLERRM;
        RETURN JSON_BUILD_OBJECT(
            'success', FALSE,
            'error', 'database_error',
            'message', 'An unexpected error occurred: ' || SQLERRM
        );
END;
$$;

-- Update the trigger function to be more robust and handle timing issues
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
    -- Use a BEGIN/EXCEPTION block to handle any timing issues
    BEGIN
        -- Small delay to ensure auth.users record is fully committed
        PERFORM pg_sleep(0.1);
        
        -- Insert new profile with data from auth.users metadata
        INSERT INTO public.profiles (
            id,
            email,
            first_name,
            last_name,
            account_type,
            family_id,
            created_at,
            updated_at
        )
        VALUES (
            NEW.id,
            NEW.email,
            COALESCE(NEW.raw_user_meta_data->>'first_name', 'User'),
            COALESCE(NEW.raw_user_meta_data->>'last_name', ''),
            COALESCE(NEW.raw_user_meta_data->>'account_type', 'personal'),
            NEW.id, -- Self-reference for family owners
            NOW(),
            NOW()
        )
        ON CONFLICT (id) DO UPDATE SET
            email = EXCLUDED.email,
            first_name = EXCLUDED.first_name,
            last_name = EXCLUDED.last_name,
            account_type = EXCLUDED.account_type,
            updated_at = NOW();
        
        RETURN NEW;
    EXCEPTION
        WHEN foreign_key_violation THEN
            -- If foreign key fails, log warning but don't fail the auth user creation
            RAISE WARNING 'Foreign key violation when creating profile for user %: %', NEW.id, SQLERRM;
            RETURN NEW;
        WHEN unique_violation THEN
            -- Profile already exists, just update it
            UPDATE public.profiles SET
                email = NEW.email,
                updated_at = NOW()
            WHERE id = NEW.id;
            RETURN NEW;
        WHEN OTHERS THEN
            -- Log error but don't fail the auth user creation
            RAISE WARNING 'Failed to create profile for user % (will be handled by explicit call): %', NEW.id, SQLERRM;
            RETURN NEW;
    END;
END;
$$;

-- Recreate the trigger to ensure it uses the updated function
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Grant execute permission on the new function
GRANT EXECUTE ON FUNCTION public.create_user_profile TO authenticated;
GRANT EXECUTE ON FUNCTION public.create_user_profile TO anon;

-- Create a function to check if profile exists and create if missing
CREATE OR REPLACE FUNCTION public.ensure_user_profile(user_id UUID DEFAULT auth.uid())
RETURNS JSON
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
DECLARE
    profile_record public.profiles%ROWTYPE;
    auth_user auth.users%ROWTYPE;
BEGIN
    -- Get the auth user first
    SELECT * INTO auth_user FROM auth.users WHERE id = user_id;
    
    IF NOT FOUND THEN
        RETURN JSON_BUILD_OBJECT(
            'success', FALSE,
            'error', 'user_not_found',
            'message', 'Auth user not found'
        );
    END IF;

    -- Check if profile exists
    SELECT * INTO profile_record FROM public.profiles WHERE id = user_id;
    
    IF FOUND THEN
        -- Profile exists, return it
        RETURN JSON_BUILD_OBJECT(
            'success', TRUE,
            'profile', ROW_TO_JSON(profile_record)
        );
    ELSE
        -- Profile doesn't exist, create it using metadata from auth.users
        RETURN public.create_user_profile(
            auth_user.id,
            auth_user.email,
            COALESCE(auth_user.raw_user_meta_data->>'first_name', 'User'),
            COALESCE(auth_user.raw_user_meta_data->>'last_name', ''),
            COALESCE(auth_user.raw_user_meta_data->>'account_type', 'personal'),
            'free'
        );
    END IF;
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION public.ensure_user_profile TO authenticated;

-- Create an index to improve performance of profile lookups
CREATE INDEX IF NOT EXISTS idx_profiles_lookup ON public.profiles(id, email);

-- Add a function to safely get or create user profile
CREATE OR REPLACE FUNCTION public.get_or_create_profile(user_id UUID DEFAULT auth.uid())
RETURNS TABLE (
    id UUID,
    email TEXT,
    first_name TEXT,
    last_name TEXT,
    account_type TEXT,
    professional_category_id UUID,
    phone TEXT,
    professional_email TEXT,
    professional_phone TEXT,
    date_of_birth DATE,
    member_color TEXT,
    family_role TEXT,
    family_id UUID,
    onboarding_completed BOOLEAN,
    subscription_status TEXT,
    avatar_url TEXT,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
)
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
DECLARE
    profile_exists BOOLEAN := FALSE;
    auth_user auth.users%ROWTYPE;
BEGIN
    -- Check if profile exists
    SELECT EXISTS(SELECT 1 FROM public.profiles WHERE public.profiles.id = user_id) INTO profile_exists;
    
    IF NOT profile_exists THEN
        -- Get auth user data
        SELECT * INTO auth_user FROM auth.users WHERE auth.users.id = user_id;
        
        IF FOUND THEN
            -- Create profile if auth user exists
            INSERT INTO public.profiles (
                id,
                email,
                first_name,
                last_name,
                account_type,
                family_id,
                created_at,
                updated_at
            )
            VALUES (
                auth_user.id,
                auth_user.email,
                COALESCE(auth_user.raw_user_meta_data->>'first_name', 'User'),
                COALESCE(auth_user.raw_user_meta_data->>'last_name', ''),
                COALESCE(auth_user.raw_user_meta_data->>'account_type', 'personal'),
                auth_user.id,
                NOW(),
                NOW()
            )
            ON CONFLICT (id) DO NOTHING;
        END IF;
    END IF;
    
    -- Return the profile
    RETURN QUERY
    SELECT p.*
    FROM public.profiles p
    WHERE p.id = user_id;
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION public.get_or_create_profile TO authenticated;
