-- docs/DATABASE_QUICK_SETUP.sql
-- Vuet App - COMPLETE PRODUCTION-READY SUPABASE SCHEMA
-- Version 1.0 - 2025-06-27
--
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
-- SECTION 2: Helper Functions and Triggers
-- These functions and triggers automate common database tasks like updating timestamps
-- and handling new user profile creation.
--------------------------------------------------------------------------------

-- Function to update 'updated_at' timestamp
create or replace function public.trigger_set_timestamp()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- Function to create a public.profiles entry for new auth.users
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.profiles (id, username)
  values (new.id, new.email); -- Using email as initial username
  return new;
end;
$$;

-- Trigger to call handle_new_user on new auth.users inserts
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

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


-- 3.10: family_members table (for family collaboration)
-- Links users to family groups.
create table if not exists public.family_members (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references auth.users(id) on delete cascade,
  family_name text not null,
  role text not null default 'member', -- e.g., 'parent', 'child', 'guardian'
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_family_members on public.family_members;
create trigger set_timestamp_family_members
before update on public.family_members
for each row execute function public.trigger_set_timestamp();


-- 3.11: invitations table (for inviting users to family groups or entities)
create table if not exists public.invitations (
  id uuid primary key default uuid_generate_v4(),
  inviter_id uuid not null references auth.users(id) on delete cascade,
  invitee_email text not null,
  entity_id uuid references public.entities(id) on delete cascade, -- Optional: if inviting to an entity
  family_id uuid references public.family_members(id) on delete cascade, -- Optional: if inviting to a family
  status text not null default 'pending', -- 'pending', 'accepted', 'declined'
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_invitations on public.invitations;
create trigger set_timestamp_invitations
before update on public.invitations
for each row execute function public.trigger_set_timestamp();


-- 3.12: timeblocks table (for scheduling time)
create table if not exists public.timeblocks (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  description text,
  start_time timestamptz not null,
  end_time timestamptz not null,
  activity_type text, -- e.g., 'work', 'personal', 'leisure'
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_timeblocks on public.timeblocks;
create trigger set_timestamp_timeblocks
before update on public.timeblocks
for each row execute function public.trigger_set_timestamp();


-- 3.13: routines table (for recurring tasks/activities)
create table if not exists public.routines (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  description text,
  recurrence_pattern text not null, -- e.g., 'daily', 'weekly', 'monthly'
  start_date date not null,
  end_date date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_routines on public.routines;
create trigger set_timestamp_routines
before update on public.routines
for each row execute function public.trigger_set_timestamp();


-- 3.14: alerts table (for notifications and reminders)
create table if not exists public.alerts (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references auth.users(id) on delete cascade,
  task_id uuid references public.tasks(id) on delete cascade, -- Optional: link to a task
  message text not null,
  alert_time timestamptz not null,
  is_read boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_alerts on public.alerts;
create trigger set_timestamp_alerts
before update on public.alerts
for each row execute function public.trigger_set_timestamp();


-- 3.15: notifications table (for system notifications)
create table if not exists public.notifications (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  message text not null,
  type text not null, -- e.g., 'task', 'system', 'invitation'
  reference_id uuid, -- Optional: reference to related entity (task, invitation, etc.)
  is_read boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_notifications on public.notifications;
create trigger set_timestamp_notifications
before update on public.notifications
for each row execute function public.trigger_set_timestamp();


-- 3.16: lists table (for shopping lists, to-do lists, etc.)
create table if not exists public.lists (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  description text,
  list_type text not null, -- e.g., 'shopping', 'todo', 'checklist'
  is_archived boolean not null default false,
  item_count integer not null default 0, -- Denormalized count of items for performance
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_lists on public.lists;
create trigger set_timestamp_lists
before update on public.lists
for each row execute function public.trigger_set_timestamp();


-- 3.17: list_items table (for items in lists)
create table if not exists public.list_items (
  id uuid primary key default uuid_generate_v4(),
  list_id uuid not null references public.lists(id) on delete cascade,
  name text not null,
  description text,
  is_completed boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_list_items on public.list_items;
create trigger set_timestamp_list_items
before update on public.list_items
for each row execute function public.trigger_set_timestamp();


-- 3.18: school_terms table (for education tracking)
create table if not exists public.school_terms (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  start_date date not null,
  end_date date not null,
  school_year text,
  term_type text, -- e.g., 'semester', 'quarter', 'trimester'
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_school_terms on public.school_terms;
create trigger set_timestamp_school_terms
before update on public.school_terms
for each row execute function public.trigger_set_timestamp();


-- 3.19: task_completion_forms table (for structured task completion data)
create table if not exists public.task_completion_forms (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references auth.users(id) on delete cascade,
  task_id uuid not null references public.tasks(id) on delete cascade,
  form_data jsonb not null, -- Structured form data (questions, answers, etc.)
  is_complete boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_task_completion_forms on public.task_completion_forms;
create trigger set_timestamp_task_completion_forms
before update on public.task_completion_forms
for each row execute function public.trigger_set_timestamp();


-- 3.20: external_calendars table (for integration with external calendars)
create table if not exists public.external_calendars (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  calendar_type text not null, -- e.g., 'google', 'apple', 'outlook', 'ical'
  url text, -- For iCal URLs
  auth_data jsonb, -- For OAuth tokens and other auth data
  is_active boolean not null default true,
  last_sync timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_external_calendars on public.external_calendars;
create trigger set_timestamp_external_calendars
before update on public.external_calendars
for each row execute function public.trigger_set_timestamp();


-- 3.21: external_calendar_events table (for events from external calendars)
create table if not exists public.external_calendar_events (
  id uuid primary key default uuid_generate_v4(),
  calendar_id uuid not null references public.external_calendars(id) on delete cascade,
  external_id text not null, -- ID from external calendar system
  title text not null,
  description text,
  start_time timestamptz not null,
  end_time timestamptz,
  location text,
  is_all_day boolean not null default false,
  recurrence_rule text, -- iCal RRULE format
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (calendar_id, external_id) -- Prevent duplicates
);
-- Attach updated_at trigger
drop trigger if exists set_timestamp_external_calendar_events on public.external_calendar_events;
create trigger set_timestamp_external_calendar_events
before update on public.external_calendar_events
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
create index if not exists idx_family_members_user_id on public.family_members(user_id);
create index if not exists idx_invitations_inviter_id on public.invitations(inviter_id);
create index if not exists idx_invitations_invitee_email on public.invitations(invitee_email);
create index if not exists idx_timeblocks_user_id on public.timeblocks(user_id);
create index if not exists idx_timeblocks_start_time on public.timeblocks(start_time);
create index if not exists idx_timeblocks_end_time on public.timeblocks(end_time);
create index if not exists idx_routines_user_id on public.routines(user_id);
create index if not exists idx_alerts_user_id on public.alerts(user_id);
create index if not exists idx_alerts_alert_time on public.alerts(alert_time);
create index if not exists idx_notifications_user_id on public.notifications(user_id);
create index if not exists idx_notifications_is_read on public.notifications(is_read);
create index if not exists idx_lists_user_id on public.lists(user_id);
create index if not exists idx_list_items_list_id on public.list_items(list_id);
create index if not exists idx_list_items_is_completed on public.list_items(is_completed);
create index if not exists idx_school_terms_user_id on public.school_terms(user_id);
create index if not exists idx_task_completion_forms_task_id on public.task_completion_forms(task_id);
create index if not exists idx_external_calendars_user_id on public.external_calendars(user_id);
create index if not exists idx_external_calendar_events_calendar_id on public.external_calendar_events(calendar_id);
create index if not exists idx_external_calendar_events_start_time on public.external_calendar_events(start_time);


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
alter table public.family_members enable row level security;
alter table public.invitations enable row level security;
alter table public.timeblocks enable row level security;
alter table public.routines enable row level security;
alter table public.alerts enable row level security;
alter table public.notifications enable row level security;
alter table public.lists enable row level security;
alter table public.list_items enable row level security;
alter table public.school_terms enable row level security;
alter table public.task_completion_forms enable row level security;
alter table public.external_calendars enable row level security;
alter table public.external_calendar_events enable row level security;


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


-- 6.10: Policies for 'family_members' table (owner-based access)
drop policy if exists "family_members_select_own" on public.family_members;
create policy "family_members_select_own" on public.family_members
for select using (user_id = auth.uid());

drop policy if exists "family_members_insert_own" on public.family_members;
create policy "family_members_insert_own" on public.family_members
for insert with check (user_id = auth.uid());

drop policy if exists "family_members_update_own" on public.family_members;
create policy "family_members_update_own" on public.family_members
for update using (user_id = auth.uid());

drop policy if exists "family_members_delete_own" on public.family_members;
create policy "family_members_delete_own" on public.family_members
for delete using (user_id = auth.uid());

drop policy if exists "family_members_all_service" on public.family_members;
create policy "family_members_all_service" on public.family_members
for all to service_role using (true) with check (true);


-- 6.11: Policies for 'invitations' table (inviter/invitee-based access)
drop policy if exists "invitations_select_inviter" on public.invitations;
create policy "invitations_select_inviter" on public.invitations
for select using (inviter_id = auth.uid());

drop policy if exists "invitations_select_invitee" on public.invitations;
create policy "invitations_select_invitee" on public.invitations
for select using (
  invitee_email = (
    select email from auth.users where id = auth.uid()
  )
);

drop policy if exists "invitations_insert_inviter" on public.invitations;
create policy "invitations_insert_inviter" on public.invitations
for insert with check (inviter_id = auth.uid());

drop policy if exists "invitations_update_inviter" on public.invitations;
create policy "invitations_update_inviter" on public.invitations
for update using (inviter_id = auth.uid());

drop policy if exists "invitations_update_invitee" on public.invitations;
create policy "invitations_update_invitee" on public.invitations
for update using (
  invitee_email = (
    select email from auth.users where id = auth.uid()
  )
);

drop policy if exists "invitations_delete_inviter" on public.invitations;
create policy "invitations_delete_inviter" on public.invitations
for delete using (inviter_id = auth.uid());

drop policy if exists "invitations_all_service" on public.invitations;
create policy "invitations_all_service" on public.invitations
for all to service_role using (true) with check (true);


-- 6.12: Policies for 'timeblocks' table (owner-based access)
drop policy if exists "timeblocks_select_own" on public.timeblocks;
create policy "timeblocks_select_own" on public.timeblocks
for select using (user_id = auth.uid());

drop policy if exists "timeblocks_insert_own" on public.timeblocks;
create policy "timeblocks_insert_own" on public.timeblocks
for insert with check (user_id = auth.uid());

drop policy if exists "timeblocks_update_own" on public.timeblocks;
create policy "timeblocks_update_own" on public.timeblocks
for update using (user_id = auth.uid());

drop policy if exists "timeblocks_delete_own" on public.timeblocks;
create policy "timeblocks_delete_own" on public.timeblocks
for delete using (user_id = auth.uid());

drop policy if exists "timeblocks_all_service" on public.timeblocks;
create policy "timeblocks_all_service" on public.timeblocks
for all to service_role using (true) with check (true);


-- 6.13: Policies for 'routines' table (owner-based access)
drop policy if exists "routines_select_own" on public.routines;
create policy "routines_select_own" on public.routines
for select using (user_id = auth.uid());

drop policy if exists "routines_insert_own" on public.routines;
create policy "routines_insert_own" on public.routines
for insert with check (user_id = auth.uid());

drop policy if exists "routines_update_own" on public.routines;
create policy "routines_update_own" on public.routines
for update using (user_id = auth.uid());

drop policy if exists "routines_delete_own" on public.routines;
create policy "routines_delete_own" on public.routines
for delete using (user_id = auth.uid());

drop policy if exists "routines_all_service" on public.routines;
create policy "routines_all_service" on public.routines
for all to service_role using (true) with check (true);


-- 6.14: Policies for 'alerts' table (owner-based access)
drop policy if exists "alerts_select_own" on public.alerts;
create policy "alerts_select_own" on public.alerts
for select using (user_id = auth.uid());

drop policy if exists "alerts_insert_own" on public.alerts;
create policy "alerts_insert_own" on public.alerts
for insert with check (user_id = auth.uid());

drop policy if exists "alerts_update_own" on public.alerts;
create policy "alerts_update_own" on public.alerts
for update using (user_id = auth.uid());

drop policy if exists "alerts_delete_own" on public.alerts;
create policy "alerts_delete_own" on public.alerts
for delete using (user_id = auth.uid());

drop policy if exists "alerts_all_service" on public.alerts;
create policy "alerts_all_service" on public.alerts
for all to service_role using (true) with check (true);


-- 6.15: Policies for 'notifications' table (owner-based access)
drop policy if exists "notifications_select_own" on public.notifications;
create policy "notifications_select_own" on public.notifications
for select using (user_id = auth.uid());

drop policy if exists "notifications_insert_own" on public.notifications;
create policy "notifications_insert_own" on public.notifications
for insert with check (user_id = auth.uid());

drop policy if exists "notifications_update_own" on public.notifications;
create policy "notifications_update_own" on public.notifications
for update using (user_id = auth.uid());

drop policy if exists "notifications_delete_own" on public.notifications;
create policy "notifications_delete_own" on public.notifications
for delete using (user_id = auth.uid());

drop policy if exists "notifications_all_service" on public.notifications;
create policy "notifications_all_service" on public.notifications
for all to service_role using (true) with check (true);


-- 6.16: Policies for 'lists' table (owner-based access)
drop policy if exists "lists_select_own" on public.lists;
create policy "lists_select_own" on public.lists
for select using (user_id = auth.uid());

drop policy if exists "lists_insert_own" on public.lists;
create policy "lists_insert_own" on public.lists
for insert with check (user_id = auth.uid());

drop policy if exists "lists_update_own" on public.lists;
create policy "lists_update_own" on public.lists
for update using (user_id = auth.uid());

drop policy if exists "lists_delete_own" on public.lists;
create policy "lists_delete_own" on public.lists
for delete using (user_id = auth.uid());

drop policy if exists "lists_all_service" on public.lists;
create policy "lists_all_service" on public.lists
for all to service_role using (true) with check (true);


-- 6.17: Policies for 'list_items' table (list-owner-based access)
drop policy if exists "list_items_select" on public.list_items;
create policy "list_items_select" on public.list_items
for select using (
  exists (
    select 1 from public.lists
    where id = list_id and user_id = auth.uid()
  )
);

drop policy if exists "list_items_insert" on public.list_items;
create policy "list_items_insert" on public.list_items
for insert with check (
  exists (
    select 1 from public.lists
    where id = list_id and user_id = auth.uid()
  )
);

drop policy if exists "list_items_update" on public.list_items;
create policy "list_items_update" on public.list_items
for update using (
  exists (
    select 1 from public.lists
    where id = list_id and user_id = auth.uid()
  )
);

drop policy if exists "list_items_delete" on public.list_items;
create policy "list_items_delete" on public.list_items
for delete using (
  exists (
    select 1 from public.lists
    where id = list_id and user_id = auth.uid()
  )
);

drop policy if exists "list_items_all_service" on public.list_items;
create policy "list_items_all_service" on public.list_items
for all to service_role using (true) with check (true);


-- 6.18: Policies for 'school_terms' table (owner-based access)
drop policy if exists "school_terms_select_own" on public.school_terms;
create policy "school_terms_select_own" on public.school_terms
for select using (user_id = auth.uid());

drop policy if exists "school_terms_insert_own" on public.school_terms;
create policy "school_terms_insert_own" on public.school_terms
for insert with check (user_id = auth.uid());

drop policy if exists "school_terms_update_own" on public.school_terms;
create policy "school_terms_update_own" on public.school_terms
for update using (user_id = auth.uid());

drop policy if exists "school_terms_delete_own" on public.school_terms;
create policy "school_terms_delete_own" on public.school_terms
for delete using (user_id = auth.uid());

drop policy if exists "school_terms_all_service" on public.school_terms;
create policy "school_terms_all_service" on public.school_terms
for all to service_role using (true) with check (true);


-- 6.19: Policies for 'task_completion_forms' table (owner-based access)
drop policy if exists "task_completion_forms_select_own" on public.task_completion_forms;
create policy "task_completion_forms_select_own" on public.task_completion_forms
for select using (user_id = auth.uid());

drop policy if exists "task_completion_forms_insert_own" on public.task_completion_forms;
create policy "task_completion_forms_insert_own" on public.task_completion_forms
for insert with check (user_id = auth.uid());

drop policy if exists "task_completion_forms_update_own" on public.task_completion_forms;
create policy "task_completion_forms_update_own" on public.task_completion_forms
for update using (user_id = auth.uid());

drop policy if exists "task_completion_forms_delete_own" on public.task_completion_forms;
create policy "task_completion_forms_delete_own" on public.task_completion_forms
for delete using (user_id = auth.uid());

drop policy if exists "task_completion_forms_all_service" on public.task_completion_forms;
create policy "task_completion_forms_all_service" on public.task_completion_forms
for all to service_role using (true) with check (true);


-- 6.20: Policies for 'external_calendars' table (owner-based access)
drop policy if exists "external_calendars_select_own" on public.external_calendars;
create policy "external_calendars_select_own" on public.external_calendars
for select using (user_id = auth.uid());

drop policy if exists "external_calendars_insert_own" on public.external_calendars;
create policy "external_calendars_insert_own" on public.external_calendars
for insert with check (user_id = auth.uid());

drop policy if exists "external_calendars_update_own" on public.external_calendars;
create policy "external_calendars_update_own" on public.external_calendars
for update using (user_id = auth.uid());

drop policy if exists "external_calendars_delete_own" on public.external_calendars;
create policy "external_calendars_delete_own" on public.external_calendars
for delete using (user_id = auth.uid());

drop policy if exists "external_calendars_all_service" on public.external_calendars;
create policy "external_calendars_all_service" on public.external_calendars
for all to service_role using (true) with check (true);


-- 6.21: Policies for 'external_calendar_events' table (calendar-owner-based access)
drop policy if exists "external_calendar_events_select" on public.external_calendar_events;
create policy "external_calendar_events_select" on public.external_calendar_events
for select using (
  exists (
    select 1 from public.external_calendars
    where id = calendar_id and user_id = auth.uid()
  )
);

drop policy if exists "external_calendar_events_insert" on public.external_calendar_events;
create policy "external_calendar_events_insert" on public.external_calendar_events
for insert with check (
  exists (
    select 1 from public.external_calendars
    where id = calendar_id and user_id = auth.uid()
  )
);

drop policy if exists "external_calendar_events_update" on public.external_calendar_events;
create policy "external_calendar_events_update" on public.external_calendar_events
for update using (
  exists (
    select 1 from public.external_calendars
    where id = calendar_id and user_id = auth.uid()
  )
);

drop policy if exists "external_calendar_events_delete" on public.external_calendar_events;
create policy "external_calendar_events_delete" on public.external_calendar_events
for delete using (
  exists (
    select 1 from public.external_calendars
    where id = calendar_id and user_id = auth.uid()
  )
);

drop policy if exists "external_calendar_events_all_service" on public.external_calendar_events;
create policy "external_calendar_events_all_service" on public.external_calendar_events
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
-- SECTION 9: Seed Initial Entity Subcategories
-- Inserts a set of subcategories for each main category.
--------------------------------------------------------------------------------
insert into public.entity_subcategories (id, category_id, name, display_name, icon_name, sort_order, entity_type_names)
values
  -- PETS Subcategories
  (uuid_generate_v4(), (select id from public.entity_categories where name='PETS'), 'MY_PETS', 'My Pets', 'pets', 1, array['Pet']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='PETS'), 'FEEDING_SCHEDULE', 'Feeding Schedule', 'restaurant', 2, array['Pet']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='PETS'), 'EXERCISE', 'Exercise', 'directions_run', 3, array['Pet']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='PETS'), 'GROOMING', 'Grooming', 'content_cut', 4, array['Pet']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='PETS'), 'HEALTH', 'Health', 'favorite', 5, array['Pet', 'Vet']),
  
  -- SOCIAL_INTERESTS Subcategories
  (uuid_generate_v4(), (select id from public.entity_categories where name='SOCIAL_INTERESTS'), 'EVENTS', 'Events', 'event', 1, array['Event', 'SocialGathering']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='SOCIAL_INTERESTS'), 'HOBBIES', 'Hobbies', 'sports_esports', 2, array['SocialActivity']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='SOCIAL_INTERESTS'), 'CONTACTS', 'Contacts', 'contacts', 3, array['Contact']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='SOCIAL_INTERESTS'), 'GROUPS', 'Groups', 'group', 4, array['Group']),
  
  -- EDUCATION Subcategories
  (uuid_generate_v4(), (select id from public.entity_categories where name='EDUCATION'), 'STUDENTS', 'Students', 'school', 1, array['Student']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='EDUCATION'), 'SCHOOLS', 'Schools', 'account_balance', 2, array['School']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='EDUCATION'), 'COURSES', 'Courses', 'menu_book', 3, array['Course']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='EDUCATION'), 'ASSIGNMENTS', 'Assignments', 'assignment', 4, array['Student']),
  
  -- CAREER Subcategories
  (uuid_generate_v4(), (select id from public.entity_categories where name='CAREER'), 'JOBS', 'Jobs', 'work', 1, array['Employee']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='CAREER'), 'GOALS', 'Career Goals', 'emoji_events', 2, array['CareerGoal']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='CAREER'), 'MEETINGS', 'Meetings', 'meeting_room', 3, array['Employee']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='CAREER'), 'DAYS_OFF', 'Days Off', 'event_busy', 4, array['Employee']),
  
  -- TRAVEL Subcategories
  (uuid_generate_v4(), (select id from public.entity_categories where name='TRAVEL'), 'TRIPS', 'Trips', 'flight', 1, array['Trip']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='TRAVEL'), 'BOOKINGS', 'Bookings', 'book_online', 2, array['Trip']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='TRAVEL'), 'PACKING', 'Packing', 'luggage', 3, array['Trip']),
  
  -- HEALTH_BEAUTY Subcategories
  (uuid_generate_v4(), (select id from public.entity_categories where name='HEALTH_BEAUTY'), 'PATIENTS', 'Patients', 'personal_injury', 1, array['Patient']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='HEALTH_BEAUTY'), 'APPOINTMENTS', 'Appointments', 'calendar_today', 2, array['Patient']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='HEALTH_BEAUTY'), 'MEDICATIONS', 'Medications', 'medication', 3, array['Patient']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='HEALTH_BEAUTY'), 'FITNESS', 'Fitness', 'fitness_center', 4, array['Patient']),
  
  -- HOME Subcategories
  (uuid_generate_v4(), (select id from public.entity_categories where name='HOME'), 'MY_HOMES', 'My Homes', 'home', 1, array['HomeProperty']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='HOME'), 'MAINTENANCE', 'Maintenance', 'build', 2, array['HomeProperty']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='HOME'), 'CLEANING', 'Cleaning', 'cleaning_services', 3, array['HomeProperty']),
  
  -- GARDEN Subcategories
  (uuid_generate_v4(), (select id from public.entity_categories where name='GARDEN'), 'MY_GARDENS', 'My Gardens', 'eco', 1, array['Garden']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='GARDEN'), 'PLANTING', 'Planting', 'spa', 2, array['Garden']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='GARDEN'), 'WATERING', 'Watering', 'water_drop', 3, array['Garden']),
  
  -- FINANCE Subcategories
  (uuid_generate_v4(), (select id from public.entity_categories where name='FINANCE'), 'ACCOUNTS', 'Accounts', 'account_balance_wallet', 1, array['Finance']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='FINANCE'), 'PAYMENTS', 'Payments', 'payment', 2, array['Finance']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='FINANCE'), 'BUDGETS', 'Budgets', 'savings', 3, array['Finance']),
  
  -- TRANSPORT Subcategories
  (uuid_generate_v4(), (select id from public.entity_categories where name='TRANSPORT'), 'VEHICLES', 'Vehicles', 'directions_car', 1, array['Vehicle']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='TRANSPORT'), 'MAINTENANCE', 'Maintenance', 'car_repair', 2, array['Vehicle']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='TRANSPORT'), 'INSURANCE', 'Insurance', 'security', 3, array['Vehicle']),
  
  -- CHARITY_RELIGION Subcategories
  (uuid_generate_v4(), (select id from public.entity_categories where name='CHARITY_RELIGION'), 'ORGANIZATIONS', 'Organizations', 'volunteer_activism', 1, array['Charity']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='CHARITY_RELIGION'), 'DONATIONS', 'Donations', 'attach_money', 2, array['Charity']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='CHARITY_RELIGION'), 'VOLUNTEER', 'Volunteer Work', 'people', 3, array['Charity']),
  (uuid_generate_v4(), (select id from public.entity_categories where name='CHARITY_RELIGION'), 'SERVICES', 'Religious Services', 'church', 4, array['Charity'])
  
on conflict (category_id, name) do update
  set display_name = excluded.display_name,
      icon_name = excluded.icon_name,
      sort_order = excluded.sort_order,
      entity_type_names = excluded.entity_type_names,
      updated_at = now();


--------------------------------------------------------------------------------
-- SECTION 10: Verification Queries
-- These queries help verify that the setup was successful.
-- Uncomment them and run individually after executing the script above.
--------------------------------------------------------------------------------
-- Check if extensions are enabled
-- select extname from pg_extension where extname in ('pg_trgm','uuid-ossp');

-- Check if entity_categories were seeded
-- select name, display_name from public.entity_categories order by sort_order;

-- Check if entity_subcategories were seeded
-- select c.name as category, s.name as subcategory, s.display_name 
-- from public.entity_subcategories s
-- join public.entity_categories c on s.category_id = c.id
-- order by c.sort_order, s.sort_order;

-- Check if tags were seeded
-- select count(*) from public.tags;

-- Check RLS policies
-- select tablename, policyname from pg_policies where schemaname = 'public';

-- Test tag selection (as authenticated user)
-- select code, label from public.tags limit 5;
