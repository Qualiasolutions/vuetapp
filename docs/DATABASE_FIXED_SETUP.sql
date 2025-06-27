-- docs/DATABASE_FIXED_SETUP.sql
-- Vuet App - Comprehensive Database Setup Script (FIXED version)
-- Version 1.1 - 2025-06-27
-- This script sets up all necessary database components for the Vuet Flutter application,
-- including extensions, triggers, tables, indexes, Row Level Security (RLS) policies,
-- and seeds the initial tag data.
-- This version specifically addresses the missing 'public.entity_members' table error.
-- Execute this script top-to-bottom in your Supabase SQL Editor.

--------------------------------------------------------------------------------
-- SECTION 1: Enable Required Extensions
-- These extensions are necessary for UUID generation and advanced text search (for GIN indexes).
--------------------------------------------------------------------------------
create extension if not exists "uuid-ossp";
create extension if not exists pg_trgm;

--------------------------------------------------------------------------------
-- SECTION 2: Helper Trigger Function for 'updated_at' Timestamps
-- This function automatically updates the 'updated_at' column on row modifications.
--------------------------------------------------------------------------------
create or replace function public.trigger_set_timestamp()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

--------------------------------------------------------------------------------
-- SECTION 3: Create Core Tables (tags, entity_tags, entity_members)
-- 'tags' stores the master list of all available tags.
-- 'entity_tags' is a junction table for the many-to-many relationship between
-- entities and tags.
-- 'entity_members' is a junction table for the many-to-many relationship between
-- entities and users (members).
--------------------------------------------------------------------------------
-- Create 'tags' table
create table if not exists public.tags (
  code        text primary key,
  label       text        not null,
  -- category_id references public.entity_categories(id), which is UUID
  category_id uuid references public.entity_categories(id),
  icon_name   text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- Attach the 'updated_at' trigger to the 'tags' table
drop trigger if exists set_timestamp_tags on public.tags;
create trigger set_timestamp_tags
before update on public.tags
for each row execute function public.trigger_set_timestamp();

-- Create 'entity_tags' table
create table if not exists public.entity_tags (
  -- entity_id references public.entities(id), which is UUID
  entity_id   uuid not null
    references public.entities(id) on delete cascade,
  tag_code    text not null
    references public.tags(code)   on delete cascade,
  created_at  timestamptz not null default now(),
  primary key (entity_id, tag_code)
);

-- Create 'entity_members' table (FIXED: This table was missing)
create table if not exists public.entity_members (
  entity_id   uuid not null
    references public.entities(id) on delete cascade,
  member_id   uuid not null
    references auth.users(id)      on delete cascade,
  role        text not null default 'member', -- e.g., 'owner', 'member', 'viewer'
  created_at  timestamptz not null default now(),
  primary key (entity_id, member_id)
);

--------------------------------------------------------------------------------
-- SECTION 4: Create Indexes for Performance
-- Indexes improve query performance, especially for filtering and joins.
--------------------------------------------------------------------------------
create index if not exists idx_entity_tags_entity_id on public.entity_tags(entity_id);
create index if not exists idx_tags_category_id      on public.tags(category_id);
-- GIN index for efficient searching within 'tag_code' (used with pg_trgm)
create index if not exists idx_entity_tags_tag_code  on public.entity_tags using gin (tag_code gin_trgm_ops);
create index if not exists idx_entity_members_entity_id on public.entity_members(entity_id);
create index if not exists idx_entity_members_member_id on public.entity_members(member_id);

--------------------------------------------------------------------------------
-- SECTION 5: Enable Row Level Security (RLS)
-- RLS ensures that users can only access data they are authorized to see.
--------------------------------------------------------------------------------
alter table public.tags         enable row level security;
alter table public.entity_tags  enable row level security;
alter table public.entity_members enable row level security; -- Enable RLS for the new table

--------------------------------------------------------------------------------
-- SECTION 6: Define RLS Policies
-- These policies control read, insert, and delete access for 'tags',
-- 'entity_tags', and 'entity_members' tables based on user roles and
-- entity ownership/membership.
--------------------------------------------------------------------------------
-- Policies for 'tags' table:
-- Allow authenticated users to read all tags
create policy "tags_select" on public.tags
for select using (auth.role() = 'authenticated' or auth.role() = 'service_role');

-- Allow 'service_role' full access to 'tags' table
create policy "tags_all_service" on public.tags
for all to service_role
using (true) with check (true);


-- Policies for 'entity_tags' table:
-- Allow owners/members of an entity to read/insert/delete tags
create policy "entity_tags_select" on public.entity_tags
for select using (
  exists (
    select 1 from public.entities e
    left join public.entity_members em on e.id = em.entity_id
    where e.id = entity_id
      and (e.owner = auth.uid() or em.member_id = auth.uid()) -- Corrected member_id reference
  )
);

create policy "entity_tags_insert" on public.entity_tags
for insert with check (
  exists (
    select 1 from public.entities e
    left join public.entity_members em on e.id = em.entity_id
    where e.id = entity_id
      and (e.owner = auth.uid() or em.member_id = auth.uid()) -- Corrected member_id reference
  )
);

create policy "entity_tags_delete" on public.entity_tags
for delete using (
  exists (
    select 1 from public.entities e
    left join public.entity_members em on e.id = em.entity_id
    where e.id = entity_id
      and (e.owner = auth.uid() or em.member_id = auth.uid()) -- Corrected member_id reference
  )
);

-- Allow 'service_role' full access to 'entity_tags' table
create policy "entity_tags_all_service" on public.entity_tags
for all to service_role using (true) with check (true);


-- Policies for 'entity_members' table (FIXED: Added policies for this table)
-- Allow users to view their own entity memberships
create policy "entity_members_select" on public.entity_members
for select using (member_id = auth.uid() or exists (select 1 from public.entities where id = entity_id and owner = auth.uid()));

-- Allow users to create entity memberships for entities they own
create policy "entity_members_insert" on public.entity_members
for insert with check (exists (select 1 from public.entities where id = entity_id and owner = auth.uid()));

-- Allow users to delete entity memberships for entities they own
create policy "entity_members_delete" on public.entity_members
for delete using (exists (select 1 from public.entities where id = entity_id and owner = auth.uid()));

-- Allow 'service_role' full access to 'entity_members' table
create policy "entity_members_all_service" on public.entity_members
for all to service_role using (true) with check (true);


--------------------------------------------------------------------------------
-- SECTION 7: Seed Initial Tag Data
-- Inserts a comprehensive set of tags for all 9 categories.
-- 'ON CONFLICT (code) DO UPDATE' handles re-runs gracefully, updating existing
-- tags if their label, category_id, or icon_name has changed.
--------------------------------------------------------------------------------
insert into public.tags (code, label, category_id, icon_name) values
-- PETS Tags
('PETS__FEEDING','Feeding Schedule',(select id from public.entity_categories where name='PETS'),'restaurant'),
('PETS__EXERCISE','Exercise',(select id from public.entity_categories where name='PETS'),'directions_run'),
('PETS__GROOMING','Grooming',(select id from public.entity_categories where name='PETS'),'content_cut'),
('PETS__HEALTH','Health',(select id from public.entity_categories where name='PETS'),'favorite'),

-- SOCIAL INTERESTS Tags
('SOCIAL_INTERESTS__INFORMATION__PUBLIC','Social Information',(select id from public.entity_categories where name='SOCIAL_INTERESTS'),'people'),
('SOCIAL_INTERESTS__BIRTHDAY','Birthday',(select id from public.entity_categories where name='SOCIAL_INTERESTS'),'cake'),
('SOCIAL_INTERESTS__ANNIVERSARY','Anniversary',(select id from public.entity_categories where name='SOCIAL_INTERESTS'),'auto_awesome'),
('SOCIAL_INTERESTS__HOLIDAY','Holiday',(select id from public.entity_categories where name='SOCIAL_INTERESTS'),'celebration'),

-- EDUCATION Tags
('EDUCATION__INFORMATION__PUBLIC','Education Info',(select id from public.entity_categories where name='EDUCATION'),'school'),
('EDUCATION__ASSIGNMENT','Assignment',(select id from public.entity_categories where name='EDUCATION'),'assignment'),
('EDUCATION__EXAM','Exam',(select id from public.entity_categories where name='EDUCATION'),'quiz'),

-- CAREER Tags
('CAREER__INFORMATION__PUBLIC','Career Info',(select id from public.entity_categories where name='CAREER'),'work'),
('CAREER__MEETING','Meeting',(select id from public.entity_categories where name='CAREER'),'meeting_room'),
('CAREER__DEADLINE','Deadline',(select id from public.entity_categories where name='CAREER'),'event_busy'),

-- TRAVEL Tags
('TRAVEL__INFORMATION__PUBLIC','Travel Info',(select id from public.entity_categories where name='TRAVEL'),'flight'),
('TRAVEL__BOOKING','Booking',(select id from public.entity_categories where name='TRAVEL'),'book_online'),
('TRAVEL__PACKING','Packing',(select id from public.entity_categories where name='TRAVEL'),'luggage'),
('TRAVEL__FLIGHT','Flight',(select id from public.entity_categories where name='TRAVEL'),'airplanemode_active'),

-- HEALTH & BEAUTY Tags
('HEALTH_BEAUTY__APPOINTMENT','Health Appointment',(select id from public.entity_categories where name='HEALTH_BEAUTY'),'calendar_today'),
('HEALTH_BEAUTY__MEDICATION','Medication',(select id from public.entity_categories where name='HEALTH_BEAUTY'),'medication'),
('HEALTH_BEAUTY__FITNESS','Fitness Goal',(select id from public.entity_categories where name='HEALTH_BEAUTY'),'fitness_center'),
('HEALTH_BEAUTY__ROUTINE','Beauty Routine',(select id from public.entity_categories where name='HEALTH_BEAUTY'),'face_retouching_natural'),
('HEALTH_BEAUTY__CHECKUP','Medical Checkup',(select id from public.entity_categories where name='HEALTH_BEAUTY'),'health_and_safety'),

-- HOME / GARDEN / FOOD / LAUNDRY Tags
('HOME__MAINTENANCE','Home Maintenance',(select id from public.entity_categories where name='HOME'),'build'),
('HOME__CLEANING','House Cleaning',(select id from public.entity_categories where name='HOME'),'cleaning_services'),
('HOME__REPAIR','Home Repair',(select id from public.entity_categories where name='HOME'),'handyman'),
('HOME__UTILITY','Utility Management',(select id from public.entity_categories where name='HOME'),'electrical_services'),

('GARDEN__PLANTING','Garden Planting',(select id from public.entity_categories where name='GARDEN'),'eco'),
('GARDEN__WATERING','Garden Watering',(select id from public.entity_categories where name='GARDEN'),'water_drop'),
('GARDEN__MAINTENANCE','Garden Maintenance',(select id from public.entity_categories where name='GARDEN'),'grass'),

('FOOD__SHOPPING','Food Shopping',(select id from public.entity_categories where name='FOOD'),'shopping_cart'),
('FOOD__COOKING','Meal Preparation',(select id from public.entity_categories where name='FOOD'),'soup_kitchen'),
('FOOD__MEAL_PLAN','Meal Planning',(select id from public.entity_categories where name='FOOD'),'restaurant_menu'),

('LAUNDRY__WASHING','Laundry Washing',(select id from public.entity_categories where name='LAUNDRY'),'wash'),
('LAUNDRY__IRONING','Ironing',(select id from public.entity_categories where name='LAUNDRY'),'iron'),
('LAUNDRY__DRY_CLEANING','Dry Cleaning',(select id from public.entity_categories where name='LAUNDRY'),'local_laundry_service'),

-- FINANCE Tags
('FINANCE__PAYMENT','Payment Due',(select id from public.entity_categories where name='FINANCE'),'payment'),
('FINANCE__BUDGET','Budget Review',(select id from public.entity_categories where name='FINANCE'),'savings'),
('FINANCE__TAX','Tax Preparation',(select id from public.entity_categories where name='FINANCE'),'receipt'),
('FINANCE__INVESTMENT','Investment Review',(select id from public.entity_categories where name='FINANCE'),'trending_up'),
('FINANCE__INSURANCE','Insurance Review',(select id from public.entity_categories where name='FINANCE'),'security'),

-- TRANSPORT Tags
('TRANSPORT__MOT_DUE','MOT Due',(select id from public.entity_categories where name='TRANSPORT'),'fact_check'),
('TRANSPORT__INSURANCE_DUE','Insurance Due',(select id from public.entity_categories where name='TRANSPORT'),'security'),
('TRANSPORT__SERVICE_DUE','Service Due',(select id from public.entity_categories where name='TRANSPORT'),'build'),
('TRANSPORT__TAX_DUE','Road Tax Due',(select id from public.entity_categories where name='TRANSPORT'),'receipt'),
('TRANSPORT__MAINTENANCE','Vehicle Maintenance',(select id from public.entity_categories where name='TRANSPORT'),'car_repair'),

-- CHARITY & RELIGION Tags
('CHARITY_RELIGION__DONATION','Donation',(select id from public.entity_categories where name='CHARITY_RELIGION'),'volunteer_activism'),
('CHARITY_RELIGION__VOLUNTEER','Volunteer Work',(select id from public.entity_categories where name='CHARITY_RELIGION'),'people'),
('CHARITY_RELIGION__EVENT','Religious Event',(select id from public.entity_categories where name='CHARITY_RELIGION'),'event'),
('CHARITY_RELIGION__SERVICE','Religious Service',(select id from public.entity_categories where name='CHARITY_RELIGION'),'church'),
('CHARITY_RELIGION__PRAYER','Prayer/Meditation',(select id from public.entity_categories where name='CHARITY_RELIGION'),'self_improvement')

ON CONFLICT (code) DO UPDATE SET
    label = EXCLUDED.label,
    category_id = EXCLUDED.category_id,
    icon_name = EXCLUDED.icon_name,
    updated_at = now();

--------------------------------------------------------------------------------
-- SECTION 8: Verification Queries
-- These queries help verify that the setup was successful.
-- Run them individually after executing the script above.
--------------------------------------------------------------------------------
-- Verify tags table
-- select count(*) from public.tags;
-- Expected: 60+ rows

-- Verify entity_tags table structure
-- \d public.entity_tags
-- Expected: entity_id, tag_code, created_at columns

-- Verify entity_members table structure
-- \d public.entity_members
-- Expected: entity_id, member_id, role, created_at columns

-- Verify RLS policies
-- select tablename, policyname from pg_policies where schemaname = 'public' and (tablename = 'tags' or tablename = 'entity_tags' or tablename = 'entity_members');
-- Expected: Multiple policies for each table

-- Test tag selection (as authenticated user)
-- select code, label from public.tags limit 5;
-- Expected: 5 tag rows

-- Test entity_members existence
-- select exists(select 1 from information_schema.tables where table_schema = 'public' and table_name = 'entity_members');
-- Expected: true
