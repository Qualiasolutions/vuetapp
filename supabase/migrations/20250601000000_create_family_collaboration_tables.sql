-- Migration: 20250601000000_create_family_collaboration_tables.sql
-- Description: Creates tables and policies for family collaboration features

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================================================
-- TABLES
-- =============================================================================

-- Families table
CREATE TABLE IF NOT EXISTS public.families (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    family_image_url TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    max_members INTEGER NOT NULL DEFAULT 10,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Family members table
CREATE TABLE IF NOT EXISTS public.family_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    family_id UUID NOT NULL REFERENCES public.families(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('owner', 'admin', 'member')),
    permissions JSONB NOT NULL DEFAULT '{"can_invite": false, "can_edit": false, "can_view_all": true}'::jsonb,
    member_color TEXT NOT NULL DEFAULT '#4285F4',
    nickname TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (family_id, user_id)
);

-- Family invitations table
CREATE TABLE IF NOT EXISTS public.family_invitations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    family_id UUID NOT NULL REFERENCES public.families(id) ON DELETE CASCADE,
    invited_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    invited_email TEXT NOT NULL,
    invited_user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'declined', 'expired')),
    invitation_code TEXT NOT NULL UNIQUE,
    message TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    expires_at TIMESTAMPTZ NOT NULL DEFAULT (now() + interval '7 days')
);

-- =============================================================================
-- INDEXES
-- =============================================================================

-- Indexes for families table
CREATE INDEX IF NOT EXISTS idx_families_owner_id ON public.families(owner_id);

-- Indexes for family_members table
CREATE INDEX IF NOT EXISTS idx_family_members_family_id ON public.family_members(family_id);
CREATE INDEX IF NOT EXISTS idx_family_members_user_id ON public.family_members(user_id);
CREATE INDEX IF NOT EXISTS idx_family_members_role ON public.family_members(role);

-- Indexes for family_invitations table
CREATE INDEX IF NOT EXISTS idx_family_invitations_family_id ON public.family_invitations(family_id);
CREATE INDEX IF NOT EXISTS idx_family_invitations_invited_by ON public.family_invitations(invited_by);
CREATE INDEX IF NOT EXISTS idx_family_invitations_invited_email ON public.family_invitations(invited_email);
CREATE INDEX IF NOT EXISTS idx_family_invitations_invited_user_id ON public.family_invitations(invited_user_id);
CREATE INDEX IF NOT EXISTS idx_family_invitations_status ON public.family_invitations(status);
CREATE INDEX IF NOT EXISTS idx_family_invitations_invitation_code ON public.family_invitations(invitation_code);

-- =============================================================================
-- TRIGGERS
-- =============================================================================

-- Update timestamp trigger function
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add triggers for updated_at columns
CREATE TRIGGER update_families_updated_at
BEFORE UPDATE ON public.families
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_family_members_updated_at
BEFORE UPDATE ON public.family_members
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_family_invitations_updated_at
BEFORE UPDATE ON public.family_invitations
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =============================================================================
-- HELPER FUNCTIONS
-- =============================================================================

-- Function to check if a user is a member of a family
CREATE OR REPLACE FUNCTION public.is_family_member(family_id UUID, user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.family_members
        WHERE family_id = $1 AND user_id = $2 AND is_active = true
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get a user's role in a family
CREATE OR REPLACE FUNCTION public.get_family_role(family_id UUID, user_id UUID)
RETURNS TEXT AS $$
DECLARE
    user_role TEXT;
BEGIN
    SELECT role INTO user_role
    FROM public.family_members
    WHERE family_id = $1 AND user_id = $2 AND is_active = true;
    
    RETURN user_role;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if a user has a specific permission in a family
CREATE OR REPLACE FUNCTION public.has_family_permission(family_id UUID, user_id UUID, permission TEXT)
RETURNS BOOLEAN AS $$
DECLARE
    user_role TEXT;
    user_permissions JSONB;
BEGIN
    -- Get user's role and permissions
    SELECT 
        fm.role, fm.permissions INTO user_role, user_permissions
    FROM 
        public.family_members fm
    WHERE 
        fm.family_id = $1 AND fm.user_id = $2 AND fm.is_active = true;
    
    -- If user is not found, return false
    IF user_role IS NULL THEN
        RETURN false;
    END IF;
    
    -- Owner has all permissions
    IF user_role = 'owner' THEN
        RETURN true;
    END IF;
    
    -- Admin has most permissions except those that might be explicitly denied
    IF user_role = 'admin' AND permission != 'can_delete_family' THEN
        RETURN COALESCE((user_permissions->$3)::boolean, true);
    END IF;
    
    -- Regular members only have permissions explicitly granted
    RETURN COALESCE((user_permissions->$3)::boolean, false);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to create a new invitation code
CREATE OR REPLACE FUNCTION public.generate_invitation_code()
RETURNS TEXT AS $$
DECLARE
    chars TEXT := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    result TEXT := '';
    i INTEGER := 0;
    rand INTEGER := 0;
BEGIN
    FOR i IN 1..8 LOOP
        rand := floor(random() * length(chars) + 1);
        result := result || substr(chars, rand, 1);
    END LOOP;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Function to automatically add owner as a family member with owner role
CREATE OR REPLACE FUNCTION public.add_owner_as_family_member()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.family_members (
        family_id, 
        user_id, 
        role, 
        permissions
    ) VALUES (
        NEW.id, 
        NEW.owner_id, 
        'owner', 
        '{"can_invite": true, "can_edit": true, "can_view_all": true, "can_delete_family": true}'::jsonb
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to add owner as family member when family is created
CREATE TRIGGER add_owner_to_family_members
AFTER INSERT ON public.families
FOR EACH ROW EXECUTE FUNCTION public.add_owner_as_family_member();

-- =============================================================================
-- ROW LEVEL SECURITY POLICIES
-- =============================================================================

-- Enable RLS on all tables
ALTER TABLE public.families ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.family_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.family_invitations ENABLE ROW LEVEL SECURITY;

-- Create policies for families table
CREATE POLICY "Users can view families they are members of" 
ON public.families FOR SELECT 
USING (
    auth.uid() = owner_id OR 
    EXISTS (
        SELECT 1 FROM public.family_members 
        WHERE family_id = id AND user_id = auth.uid() AND is_active = true
    )
);

CREATE POLICY "Only owners can insert families" 
ON public.families FOR INSERT 
WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Only owners can update their families" 
ON public.families FOR UPDATE 
USING (auth.uid() = owner_id)
WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Only owners can delete their families" 
ON public.families FOR DELETE 
USING (auth.uid() = owner_id);

-- Create policies for family_members table
CREATE POLICY "Users can view family members of families they belong to" 
ON public.family_members FOR SELECT 
USING (
    user_id = auth.uid() OR 
    EXISTS (
        SELECT 1 FROM public.family_members 
        WHERE family_id = family_members.family_id AND user_id = auth.uid() AND is_active = true
    )
);

CREATE POLICY "Only family owners and admins with permission can insert family members" 
ON public.family_members FOR INSERT 
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.family_members fm
        WHERE fm.family_id = family_id AND fm.user_id = auth.uid() 
        AND (fm.role = 'owner' OR (fm.role = 'admin' AND (fm.permissions->>'can_invite')::boolean = true))
    )
);

CREATE POLICY "Only family owners and admins with permission can update family members" 
ON public.family_members FOR UPDATE 
USING (
    user_id = auth.uid() OR
    EXISTS (
        SELECT 1 FROM public.family_members fm
        WHERE fm.family_id = family_id AND fm.user_id = auth.uid() 
        AND (fm.role = 'owner' OR (fm.role = 'admin' AND (fm.permissions->>'can_edit')::boolean = true))
    )
);

CREATE POLICY "Only family owners can delete family members" 
ON public.family_members FOR DELETE 
USING (
    EXISTS (
        SELECT 1 FROM public.family_members fm
        WHERE fm.family_id = family_id AND fm.user_id = auth.uid() AND fm.role = 'owner'
    )
);

-- Create policies for family_invitations table
CREATE POLICY "Users can view invitations for their families or sent to them" 
ON public.family_invitations FOR SELECT 
USING (
    invited_by = auth.uid() OR 
    invited_user_id = auth.uid() OR
    invited_email = (SELECT email FROM auth.users WHERE id = auth.uid()) OR
    EXISTS (
        SELECT 1 FROM public.family_members 
        WHERE family_id = family_invitations.family_id AND user_id = auth.uid() AND is_active = true
    )
);

CREATE POLICY "Only family owners and admins with permission can insert invitations" 
ON public.family_invitations FOR INSERT 
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.family_members fm
        WHERE fm.family_id = family_id AND fm.user_id = auth.uid() 
        AND (fm.role = 'owner' OR (fm.role = 'admin' AND (fm.permissions->>'can_invite')::boolean = true))
    )
);

CREATE POLICY "Users can update invitations they sent or received" 
ON public.family_invitations FOR UPDATE 
USING (
    invited_by = auth.uid() OR 
    invited_user_id = auth.uid() OR
    invited_email = (SELECT email FROM auth.users WHERE id = auth.uid()) OR
    EXISTS (
        SELECT 1 FROM public.family_members fm
        WHERE fm.family_id = family_id AND fm.user_id = auth.uid() AND fm.role = 'owner'
    )
);

CREATE POLICY "Only family owners and senders can delete invitations" 
ON public.family_invitations FOR DELETE 
USING (
    invited_by = auth.uid() OR
    EXISTS (
        SELECT 1 FROM public.family_members fm
        WHERE fm.family_id = family_id AND fm.user_id = auth.uid() AND fm.role = 'owner'
    )
);

-- =============================================================================
-- DEFAULT PERMISSIONS
-- =============================================================================

-- Grant usage on schema
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;

-- Grant access to tables
GRANT SELECT, INSERT, UPDATE, DELETE ON public.families TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.family_members TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.family_invitations TO authenticated;

-- Grant execute on functions
GRANT EXECUTE ON FUNCTION public.is_family_member TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_family_role TO authenticated;
GRANT EXECUTE ON FUNCTION public.has_family_permission TO authenticated;
GRANT EXECUTE ON FUNCTION public.generate_invitation_code TO authenticated;

-- Grant usage on sequences
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO authenticated;
