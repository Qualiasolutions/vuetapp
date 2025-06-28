-- docs/COMPLETE_FRESH_SCHEMA.sql
-- Vuet App - COMPLETE PRODUCTION-READY SUPABASE SCHEMA
-- Version 1.0 - 2025-06-27
-- This script creates a fresh, bulletproof Supabase database schema for the Vuet Flutter application.
-- It includes all necessary tables, relationships, indexes, Row Level Security (RLS) policies,
-- and seeds initial data for a 100% functional category and "I WANT TO" system.
--
-- Designed to be copied and pasted into a NEW Supabase project's SQL Editor.
--
-- IMPORTANT: Run this script top-to-bottom. If you encounter errors, ensure your project
-- is truly fresh or drop conflicting tables/policies manually before re-running.

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
-- SECTION 3: Create Core Tables
-- Defines the fundamental tables for user profiles, categories, entities,
-- tasks, and their relationships.
--------------------------------------------------------------------------------

-- 3.1: profiles table (for user metadata)
-- Linked to auth.users via id
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique,
  avatar_url text,
  full_name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_profiles on public.profiles;
create trigger set_timestamp_profiles
before update on public.profiles
for each row execute function public.trigger_set_timestamp();


-- 3.2: entity_categories table (top-level categories)
-- These are the 9 main categories displayed in the grid.
create table if not exists public.entity_categories (
  id uuid primary key default uuid_generate_v4(),
  name text not null unique, -- e.g., 'PETS', 'SOCIAL_INTERESTS', 'EDUCATION'
  display_name text not null, -- e.g., 'Pets', 'Social Interests'
  icon_name text, -- Material icon name string
  sort_order integer not null unique,
  is_premium boolean not null default false,
  is_displayed_on_grid boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_entity_categories on public.entity_categories;
create trigger set_timestamp_entity_categories
before update on public.entity_categories
for each row execute function public.trigger_set_timestamp();


-- 3.3: entity_subcategories table (second-level categorization)
-- Defines sub-options within main categories (e.g., 'Feeding Schedule' under 'Pets').
create table if not exists public.entity_subcategories (
  id uuid primary key default uuid_generate_v4(),
  category_id uuid not null references public.entity_categories(id) on delete cascade,
  name text not null, -- e.g., 'FEEDING_SCHEDULE', 'MY_PETS'
  display_name text not null, -- e.g., 'Feeding Schedule', 'My Pets'
  icon_name text,
  sort_order integer not null,
  entity_type_names text[] not null default '{}', -- List of associated entity subtypes (e.g., 'Pet', 'Vet')
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (category_id, name)
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_entity_subcategories on public.entity_subcategories;
create trigger set_timestamp_entity_subcategories
before update on public.entity_subcategories
for each row execute function public.trigger_set_timestamp();


-- 3.4: entities table (core polymorphic entity storage)
-- This table stores all user-created items (pets, students, homes, etc.).
create table if not exists public.entities (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references auth.users(id) on delete cascade, -- Owner of the entity
  category_id uuid references public.entity_categories(id) on delete set null,
  subcategory_id uuid references public.entity_subcategories(id) on delete set null,
  name text not null,
  description text,
  image_url text,
  subtype text not null, -- Corresponds to EntitySubtype enum (e.g., 'Pet', 'Student', 'HomeProperty')
  is_hidden boolean default false,
  custom_fields jsonb, -- For flexible schema extension
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_entities on public.entities;
create trigger set_timestamp_entities
before update on public.entities
for each row execute function public.trigger_set_timestamp();


-- 3.5: entity_members table (many-to-many for collaboration)
-- Links entities to users who are members (not necessarily owners).
create table if not exists public.entity_members (
  entity_id uuid not null references public.entities(id) on delete cascade,
  member_id uuid not null references auth.users(id) on delete cascade,
  role text not null default 'member', -- e.g., 'owner', 'member', 'viewer'
  created_at timestamptz not null default now(),
  primary key (entity_id, member_id)
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_entity_members on public.entity_members;
create trigger set_timestamp_entity_members
before update on public.entity_members
for each row execute function public.trigger_set_timestamp();


-- 3.6: tags table (master list of "I WANT TO" tags)
-- Stores predefined quick action tags (e.g., 'PETS__FEEDING').
create table if not exists public.tags (
  code text primary key, -- e.g., 'PETS__FEEDING'
  label text not null, -- e.g., 'Feeding Schedule'
  category_id uuid references public.entity_categories(id), -- Optional link to a category
  icon_name text, -- Material icon name string
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_tags on public.tags;
create trigger set_timestamp_tags
before update on public.tags
for each row execute function public.trigger_set_timestamp();


-- 3.7: entity_tags table (junction table for entity-tag relationship)
-- Links specific entities to specific tags, enabling filtered task views.
create table if not exists public.entity_tags (
  entity_id uuid not null references public.entities(id) on delete cascade,
  tag_code text not null references public.tags(code) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (entity_id, tag_code)
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_entity_tags on public.entity_tags;
create trigger set_timestamp_entity_tags
before update on public.entity_tags
for each row execute function public.trigger_set_timestamp();


-- 3.8: tasks table (unified task/appointment model)
-- Stores all tasks, which can be linked to entities and tags.
create table if not exists public.tasks (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references auth.users(id) on delete cascade, -- Owner of the task
  title text not null,
  description text,
  due_date timestamptz,
  status text not null default 'pending', -- e.g., 'pending', 'completed', 'overdue'
  priority text not null default 'medium', -- e.g., 'low', 'medium', 'high'
  is_recurring boolean not null default false,
  recurrence_rule text, -- e.g., 'FREQ=DAILY;INTERVAL=1'
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_tasks on public.tasks;
create trigger set_timestamp_tasks
before update on public.tasks
for each row execute function public.trigger_set_timestamp();


-- 3.9: task_entities table (junction table for task-entity relationship)
-- Links tasks to entities (many-to-many).
create table if not exists public.task_entities (
  task_id uuid not null references public.tasks(id) on delete cascade,
  entity_id uuid not null references public.entities(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (task_id, entity_id)
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_task_entities on public.task_entities;
create trigger set_timestamp_task_entities
before update on public.task_entities
for each row execute function public.trigger_set_timestamp();


--------------------------------------------------------------------------------
-- SECTION 4: Create Indexes for Performance
-- Indexes improve query performance, especially for filtering and joins.
--------------------------------------------------------------------------------
create index if not exists idx_profiles_username on public.profiles(username);
create index if not exists idx_entity_categories_name on public.entity_categories(name);
create index if not exists idx_entity_subcategories_category_id on public.entity_subcategories(category_id);
create index if not exists idx_entities_user_id on public.entities(user_id);
create index if not exists idx_entities_category_id on public.entities(category_id);
create index if not exists idx_entities_subcategory_id on public.entities(subcategory_id);
create index if not exists idx_entities_subtype on public.entities(subtype);
create index if not exists idx_entity_members_entity_id on public.entity_members(entity_id);
create index if not exists idx_entity_members_member_id on public.entity_members(member_id);
create index if not exists idx_tags_category_id on public.tags(category_id);
create index if not exists idx_entity_tags_entity_id on public.entity_tags(entity_id);
create index if not exists idx_entity_tags_tag_code on public.entity_tags using gin (tag_code gin_trgm_ops); -- For efficient tag filtering
create index if not exists idx_tasks_user_id on public.tasks(user_id);
create index if not exists idx_tasks_due_date on public.tasks(due_date);
create index if not exists idx_task_entities_task_id on public.task_entities(task_id);
create index if not exists idx_task_entities_entity_id on public.task_entities(entity_id);


--------------------------------------------------------------------------------
-- SECTION 5: Enable Row Level Security (RLS)
-- RLS ensures that users can only access data they are authorized to see.
--------------------------------------------------------------------------------
alter table public.profiles enable row level security;
alter table public.entity_categories enable row level security;
alter table public.entity_subcategories enable row level security;
alter table public.entities enable row level security;
alter table public.entity_members enable row level security;
alter table public.tags enable row level security;
alter table public.entity_tags enable row level security;
alter table public.tasks enable row level security;
alter table public.task_entities enable row level security;


--------------------------------------------------------------------------------
-- SECTION 6: Define RLS Policies
-- These policies control access based on user roles and data ownership/membership.
-- Policies are dropped and recreated to ensure a clean state on re-runs.
--------------------------------------------------------------------------------

-- 6.1: Policies for 'profiles' table
drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own" on public.profiles
for select using (id = auth.uid());

drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own" on public.profiles
for insert with check (id = auth.uid());

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles
for update using (id = auth.uid());

drop policy if exists "profiles_delete_own" on public.profiles;
create policy "profiles_delete_own" on public.profiles
for delete using (id = auth.uid());

drop policy if exists "profiles_all_service" on public.profiles;
create policy "profiles_all_service" on public.profiles
for all to service_role using (true) with check (true);


-- 6.2: Policies for 'entity_categories' table (read-only for authenticated users)
drop policy if exists "entity_categories_select" on public.entity_categories;
create policy "entity_categories_select" on public.entity_categories
for select using (auth.role() = 'authenticated' or auth.role() = 'service_role');

drop policy if exists "entity_categories_all_service" on public.entity_categories;
create policy "entity_categories_all_service" on public.entity_categories
for all to service_role using (true) with check (true);


-- 6.3: Policies for 'entity_subcategories' table (read-only for authenticated users)
drop policy if exists "entity_subcategories_select" on public.entity_subcategories;
create policy "entity_subcategories_select" on public.entity_subcategories
for select using (auth.role() = 'authenticated' or auth.role() = 'service_role');

drop policy if exists "entity_subcategories_all_service" on public.entity_subcategories;
create policy "entity_subcategories_all_service" on public.entity_subcategories
for all to service_role using (true) with check (true);


-- 6.4: Policies for 'entities' table (owner-based access)
drop policy if exists "entities_select_own_or_member" on public.entities;
create policy "entities_select_own_or_member" on public.entities
for select using (
  user_id = auth.uid() or exists (
    select 1 from public.entity_members
    where entity_id = id and member_id = auth.uid()
  )
);

drop policy if exists "entities_insert_own" on public.entities;
create policy "entities_insert_own" on public.entities
for insert with check (user_id = auth.uid());

drop policy if exists "entities_update_own_or_member" on public.entities;
create policy "entities_update_own_or_member" on public.entities
for update using (
  user_id = auth.uid() or exists (
    select 1 from public.entity_members
    where entity_id = id and member_id = auth.uid() and role = 'editor'
  )
);

drop policy if exists "entities_delete_own" on public.entities;
create policy "entities_delete_own" on public.entities
for delete using (user_id = auth.uid());

drop policy if exists "entities_all_service" on public.entities;
create policy "entities_all_service" on public.entities
for all to service_role using (true) with check (true);


-- 6.5: Policies for 'entity_members' table (owner-based access)
drop policy if exists "entity_members_select" on public.entity_members;
create policy "entity_members_select" on public.entity_members
for select using (
  member_id = auth.uid() or exists (
    select 1 from public.entities
    where id = entity_id and user_id = auth.uid()
  )
);

drop policy if exists "entity_members_insert" on public.entity_members;
create policy "entity_members_insert" on public.entity_members
for insert with check (
  exists (
    select 1 from public.entities
    where id = entity_id and user_id = auth.uid()
  )
);

drop policy if exists "entity_members_delete" on public.entity_members;
create policy "entity_members_delete" on public.entity_members
for delete using (
  exists (
    select 1 from public.entities
    where id = entity_id and user_id = auth.uid()
  )
);

drop policy if exists "entity_members_all_service" on public.entity_members;
create policy "entity_members_all_service" on public.entity_members
for all to service_role using (true) with check (true);


-- 6.6: Policies for 'tags' table (read-only for authenticated users)
drop policy if exists "tags_select" on public.tags;
create policy "tags_select" on public.tags
for select using (auth.role() = 'authenticated' or auth.role() = 'service_role');

drop policy if exists "tags_all_service" on public.tags;
create policy "tags_all_service" on public.tags
for all to service_role using (true) with check (true);


-- 6.7: Policies for 'entity_tags' table (entity-member-based access)
drop policy if exists "entity_tags_select" on public.entity_tags;
create policy "entity_tags_select" on public.entity_tags
for select using (
  exists (
    select 1 from public.entities e
    left join public.entity_members em on e.id = em.entity_id
    where e.id = entity_id
      and (e.user_id = auth.uid() or em.member_id = auth.uid())
  )
);

drop policy if exists "entity_tags_insert" on public.entity_tags;
create policy "entity_tags_insert" on public.entity_tags
for insert with check (
  exists (
    select 1 from public.entities e
    left join public.entity_members em on e.id = em.entity_id
    where e.id = entity_id
      and (e.user_id = auth.uid() or em.member_id = auth.uid())
  )
);

drop policy if exists "entity_tags_delete" on public.entity_tags;
create policy "entity_tags_delete" on public.entity_tags
for delete using (
  exists (
    select 1 from public.entities e
    left join public.entity_members em on e.id = em.entity_id
    where e.id = entity_id
      and (e.user_id = auth.uid() or em.member_id = auth.uid())
  )
);

drop policy if exists "entity_tags_all_service" on public.entity_tags;
create policy "entity_tags_all_service" on public.entity_tags
for all to service_role using (true) with check (true);


-- 6.8: Policies for 'tasks' table (owner-based access)
drop policy if exists "tasks_select_own" on public.tasks;
create policy "tasks_select_own" on public.tasks
for select using (user_id = auth.uid());

drop policy if exists "tasks_insert_own" on public.tasks;
create policy "tasks_insert_own" on public.tasks
for insert with check (user_id = auth.uid());

drop policy if exists "tasks_update_own" on public.tasks;
create policy "tasks_update_own" on public.tasks
for update using (user_id = auth.uid());

drop policy if exists "tasks_delete_own" on public.tasks;
create policy "tasks_delete_own" on public.tasks
for delete using (user_id = auth.uid());

drop policy if exists "tasks_all_service" on public.tasks;
create policy "tasks_all_service" on public.tasks
for all to service_role using (true) with check (true);


-- 6.9: Policies for 'task_entities' table (task/entity-owner-based access)
drop policy if exists "task_entities_select" on public.task_entities;
create policy "task_entities_select" on public.task_entities
for select using (
  exists (
    select 1 from public.tasks
    where id = task_id and user_id = auth.uid()
  ) or exists (
    select 1 from public.entities e
    left join public.entity_members em on e.id = em.entity_id
    where e.id = entity_id
      and (e.user_id = auth.uid() or em.member_id = auth.uid())
  )
);

drop policy if exists "task_entities_insert" on public.task_entities;
create policy "task_entities_insert" on public.task_entities
for insert with check (
  exists (
    select 1 from public.tasks
    where id = task_id and user_id = auth.uid()
  )
);

drop policy if exists "task_entities_delete" on public.task_entities;
create policy "task_entities_delete" on public.task_entities
for delete using (
  exists (
    select 1 from public.tasks
    where id = task_id and user_id = auth.uid()
  )
);

drop policy if exists "task_entities_all_service" on public.task_entities;
create policy "task_entities_all_service" on public.task_entities
for all to service_role using (true) with check (true);


--------------------------------------------------------------------------------
-- SECTION 7: Seed Initial Category Data
-- Inserts the 9 main categories displayed in the grid.
--------------------------------------------------------------------------------
insert into public.entity_categories (id, name, display_name, icon_name, sort_order, is_premium, is_displayed_on_grid)
values
  (uuid_generate_v4(), 'PETS', 'Pets', 'pets', 1, false, true),
  (uuid_generate_v4(), 'SOCIAL_INTERESTS', 'Social Interests', 'people', 2, false, true),
  (uuid_generate_v4(), 'EDUCATION', 'Education', 'school', 3, false, true),
  (uuid_generate_v4(), 'CAREER', 'Career', 'work', 4, false, true),
  (uuid_generate_v4(), 'TRAVEL', 'Travel', 'flight', 5, false, true),
  (uuid_generate_v4(), 'HEALTH_BEAUTY', 'Health & Beauty', 'health_and_safety', 6, false, true),
  (uuid_generate_v4(), 'HOME', 'Home', 'home', 7, false, true),
  (uuid_generate_v4(), 'GARDEN', 'Garden', 'eco', 8, false, true),
  (uuid_generate_v4(), 'FOOD', 'Food', 'restaurant', 9, false, true),
  (uuid_generate_v4(), 'LAUNDRY', 'Laundry', 'local_laundry_service', 10, false, true),
  (uuid_generate_v4(), 'FINANCE', 'Finance', 'account_balance_wallet', 11, false, true),
  (uuid_generate_v4(), 'TRANSPORT', 'Transport', 'directions_car', 12, false, true),
  (uuid_generate_v4(), 'CHARITY_RELIGION', 'Charity & Religion', 'volunteer_activism', 13, false, true)
on conflict (name) do update
  set display_name = excluded.display_name,
      icon_name = excluded.icon_name,
      sort_order = excluded.sort_order,
      is_premium = excluded.is_premium,
      is_displayed_on_grid = excluded.is_displayed_on_grid,
      updated_at = now();


--------------------------------------------------------------------------------
-- SECTION 8: Seed Initial Tag Data
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

on conflict (code) do update
  set label = excluded.label,
      category_id = excluded.category_id,
      icon_name = excluded.icon_name,
      updated_at = now();


--------------------------------------------------------------------------------
-- SECTION 9: Verification Queries
-- These queries help verify that the setup was successful.
-- Uncomment them and run individually after executing the script above.
--------------------------------------------------------------------------------
-- Check if extensions are enabled
-- select extname from pg_extension where extname in ('pg_trgm','uuid-ossp');

-- Check if entity_categories were seeded
-- select name, display_name from public.entity_categories order by sort_order;

-- Check if tags were seeded
-- select count(*) from public.tags;

-- Check RLS policies
-- select tablename, policyname from pg_policies where schemaname = 'public';

-- Test tag selection (as authenticated user)
-- select code, label from public.tags limit 5;
