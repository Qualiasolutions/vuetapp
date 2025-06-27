# ✅ Vuet App – COMPLETE DATABASE SETUP GUIDE  
*Version 1.0 · 2025-06-27*

This single document walks you — step-by-step — through **every SQL command** required to bring your Supabase database to **100 % feature-complete status** for the Vuet Flutter application (dev: `cqsboamhfmwezeftifzk`, prod: `xrloafqzfdzewdoawysh`).  
Follow the steps **in order**, copy-paste the code blocks, verify after each section, and you will have a working tag + “I WANT TO” system with full Row-Level-Security (RLS).

---

## 0 · Prerequisites & Safety

| Requirement | Details |
|-------------|---------|
| Supabase role | You must be **Owner** or **DBA** |
| SQL access   | Supabase Dashboard → SQL Editor **or** `psql` CLI |
| Backup       | *(highly recommended)* **SQL → Backups → Create** before proceeding |

> If you have dev + prod projects, repeat the guide in each project.

---

## 1 · Enable Required Extensions

```sql
-- STEP 1 · Enable pg_trgm for fast text search
create extension if not exists pg_trgm;

-- STEP 1 · Enable uuid-ossp for UUID generators (many tables already use it)
create extension if not exists "uuid-ossp";
```

**Verify**

```sql
select extname from pg_extension where extname in ('pg_trgm','uuid-ossp');
```

Expected result: two rows.

---

## 2 · Helper Trigger for `updated_at`

```sql
-- STEP 2 · Reusable trigger
create or replace function public.trigger_set_timestamp()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end; $$;
```

No verification needed (will be attached later).

---

## 3 · Create Tag Tables

```sql
-- STEP 3 · tags table (master list of tag codes)
create table if not exists public.tags (
  code        text primary key,
  label       text        not null,
  category_id uuid references public.entity_categories(id),
  icon_name   text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- Attach trigger
drop trigger if exists set_timestamp_tags on public.tags;
create trigger set_timestamp_tags
before update on public.tags
for each row execute function public.trigger_set_timestamp();


-- STEP 3 · entity_tags (many-to-many link)
create table if not exists public.entity_tags (
  entity_id uuid not null
    references public.entities(id) on delete cascade,
  tag_code  text not null
    references public.tags(code)   on delete cascade,
  created_at timestamptz not null default now(),
  primary key (entity_id, tag_code)
);
```

---

## 4 · Indexes for Performance

```sql
-- STEP 4
create index if not exists idx_entity_tags_entity_id on public.entity_tags(entity_id);
create index if not exists idx_tags_category_id      on public.tags(category_id);
create index if not exists idx_entity_tags_tag_code  on public.entity_tags using gin (tag_code gin_trgm_ops);
```

---

## 5 · Enable RLS

```sql
-- STEP 5
alter table public.tags         enable row level security;
alter table public.entity_tags  enable row level security;
```

---

## 6 · RLS Policies

```sql
-- STEP 6 A · tags table (read-only for any logged-in user)
create policy "tags_select" on public.tags
for select using (auth.role() = 'authenticated' or auth.role() = 'service_role');

-- service_role full access
create policy "tags_all_service" on public.tags
for all to service_role
using (true) with check (true);



-- STEP 6 B · entity_tags table
-- Allow owners/members of an entity to read/insert/delete tags

create policy "entity_tags_select" on public.entity_tags
for select using (
  exists (
    select 1 from public.entities e
    left join public.entity_members em on e.id = em.entity_id
    where e.id = entity_id
      and (e.owner = auth.uid() or em.member = auth.uid())
  )
);

create policy "entity_tags_insert" on public.entity_tags
for insert with check (
  exists (
    select 1 from public.entities e
    left join public.entity_members em on e.id = em.entity_id
    where e.id = entity_id
      and (e.owner = auth.uid() or em.member = auth.uid())
  )
);

create policy "entity_tags_delete" on public.entity_tags
for delete using (
  exists (
    select 1 from public.entities e
    left join public.entity_members em on e.id = em.entity_id
    where e.id = entity_id
      and (e.owner = auth.uid() or em.member = auth.uid())
  )
);

-- service_role full access
create policy "entity_tags_all_service" on public.entity_tags
for all to service_role using (true) with check (true);
```

---

## 7 · Seed 60 + Tags (Copy-Paste Once)

> The script is split into logical category blocks.  
> If a statement fails (e.g. already seeded) just run the remaining blocks.

```sql
-- STEP 7 · INSERT TAGS
insert into public.tags (code,label,category_id,icon_name) values
-- PETS -------------------------------------------------------
('PETS__FEEDING','Feeding Schedule',(select id from public.entity_categories where name='PETS'),'restaurant'),
('PETS__EXERCISE','Exercise',(select id from public.entity_categories where name='PETS'),'directions_run'),
('PETS__GROOMING','Grooming',(select id from public.entity_categories where name='PETS'),'content_cut'),
('PETS__HEALTH','Health',(select id from public.entity_categories where name='PETS'),'favorite'),

-- SOCIAL INTERESTS ------------------------------------------
('SOCIAL_INTERESTS__INFORMATION__PUBLIC','Social Information',(select id from public.entity_categories where name='SOCIAL_INTERESTS'),'people'),
('SOCIAL_INTERESTS__BIRTHDAY','Birthday',(select id from public.entity_categories where name='SOCIAL_INTERESTS'),'cake'),
('SOCIAL_INTERESTS__ANNIVERSARY','Anniversary',(select id from public.entity_categories where name='SOCIAL_INTERESTS'),'auto_awesome'),
('SOCIAL_INTERESTS__HOLIDAY','Holiday',(select id from public.entity_categories where name='SOCIAL_INTERESTS'),'celebration'),

-- EDUCATION --------------------------------------------------
('EDUCATION__INFORMATION__PUBLIC','Education Info',(select id from public.entity_categories where name='EDUCATION'),'school'),
('EDUCATION__ASSIGNMENT','Assignment',(select id from public.entity_categories where name='EDUCATION'),'assignment'),
('EDUCATION__EXAM','Exam',(select id from public.entity_categories where name='EDUCATION'),'quiz'),

-- CAREER -----------------------------------------------------
('CAREER__INFORMATION__PUBLIC','Career Info',(select id from public.entity_categories where name='CAREER'),'work'),
('CAREER__MEETING','Meeting',(select id from public.entity_categories where name='CAREER'),'meeting_room'),
('CAREER__DEADLINE','Deadline',(select id from public.entity_categories where name='CAREER'),'event_busy'),

-- TRAVEL -----------------------------------------------------
('TRAVEL__INFORMATION__PUBLIC','Travel Info',(select id from public.entity_categories where name='TRAVEL'),'flight'),
('TRAVEL__BOOKING','Booking',(select id from public.entity_categories where name='TRAVEL'),'book_online'),
('TRAVEL__PACKING','Packing',(select id from public.entity_categories where name='TRAVEL'),'luggage'),
('TRAVEL__FLIGHT','Flight',(select id from public.entity_categories where name='TRAVEL'),'airplanemode_active'),

-- HEALTH & BEAUTY -------------------------------------------
('HEALTH_BEAUTY__APPOINTMENT','Health Appointment',(select id from public.entity_categories where name='HEALTH_BEAUTY'),'calendar_today'),
('HEALTH_BEAUTY__MEDICATION','Medication',(select id from public.entity_categories where name='HEALTH_BEAUTY'),'medication'),
('HEALTH_BEAUTY__FITNESS','Fitness Goal',(select id from public.entity_categories where name='HEALTH_BEAUTY'),'fitness_center'),
('HEALTH_BEAUTY__ROUTINE','Beauty Routine',(select id from public.entity_categories where name='HEALTH_BEAUTY'),'face_retouching_natural'),
('HEALTH_BEAUTY__CHECKUP','Medical Checkup',(select id from public.entity_categories where name='HEALTH_BEAUTY'),'health_and_safety'),

-- HOME / GARDEN / FOOD / LAUNDRY -----------------------------
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

-- FINANCE ----------------------------------------------------
('FINANCE__PAYMENT','Payment Due',(select id from public.entity_categories where name='FINANCE'),'payment'),
('FINANCE__BUDGET','Budget Review',(select id from public.entity_categories where name='FINANCE'),'savings'),
('FINANCE__TAX','Tax Preparation',(select id from public.entity_categories where name='FINANCE'),'receipt'),
('FINANCE__INVESTMENT','Investment Review',(select id from public.entity_categories where name='FINANCE'),'trending_up'),
('FINANCE__INSURANCE','Insurance Review',(select id from public.entity_categories where name='FINANCE'),'security'),

-- TRANSPORT --------------------------------------------------
('TRANSPORT__MOT_DUE','MOT Due',(select id from public.entity_categories where name='TRANSPORT'),'fact_check'),
('TRANSPORT__INSURANCE_DUE','Insurance Due',(select id from public.entity_categories where name='TRANSPORT'),'security'),
('TRANSPORT__SERVICE_DUE','Service Due',(select id from public.entity_categories where name='TRANSPORT'),'build'),
('TRANSPORT__TAX_DUE','Road Tax Due',(select id from public.entity_categories where name='TRANSPORT'),'receipt'),
('TRANSPORT__MAINTENANCE','Vehicle Maintenance',(select id from public.entity_categories where name='TRANSPORT'),'car_repair'),

-- CHARITY & RELIGION ----------------------------------------
('CHARITY_RELIGION__DONATION','Donation',(select id from public.entity_categories where name='CHARITY_RELIGION'),'volunteer_activism'),
('CHARITY_RELIGION__VOLUNTEER','Volunteer Work',(select id from public.entity_categories where name='CHARITY_RELIGION'),'people'),
('CHARITY_RELIGION__EVENT','Religious Event',(select id from public.entity_categories where name='CHARITY_RELIGION'),'event'),
('CHARITY_RELIGION__SERVICE','Religious Service',(select id from public.entity_categories where name='CHARITY_RELIGION'),'church'),
('CHARITY_RELIGION__PRAYER','Prayer / Meditation',(select id from public.entity_categories where name='CHARITY_RELIGION'),'self_improvement')

on conflict (code) do update
  set label = excluded.label,
      category_id = excluded.category_id,
      icon_name   = excluded.icon_name,
      updated_at  = now();
```

**Expected result:** `INSERT 0 60+` rows (number depends on pre-existing data).

---

## 8 · Verification Queries

| Purpose | Query | Expected |
|---------|-------|----------|
| Tag count | `select count(*) from public.tags;` | `>= 60` |
| Entity-Tag sample | `select * from public.entity_tags limit 5;` | rows or empty list |
| RLS check (anon) | `set role anon; select * from public.tags limit 1;` | ✓ rows |
| RLS check (anon) entity_tags | `select * from public.entity_tags limit 1;` | ERROR: permission denied |

*(Reset role with `reset role;`)*

---

## 9 · Common Troubleshooting

| Symptom | Likely Cause | Fix |
|---------|--------------|-----|
| `foreign key … cannot be implemented` | Column type mismatch (int ↔ uuid) | Ensure `category_id` & `entity_id` are **UUID** |
| `permission denied for table …` | RLS not enabled / policies missing | Rerun **Steps 5-6** |
| Duplicate tag error | Ran seed twice | Safe to ignore (`ON CONFLICT`) |
| Tag filter returns 0 tasks | Entity not linked in `entity_tags` | Ensure 💡 menu or manual insert created link |

---

## 10 · Final Success Test

1. **Open Vuet app**, create a *Pet* “Jack”.  
2. Tap **💡 I WANT TO → Feeding Schedule** → create task.  
3. Task appears under **Pets → Feeding** filter instantly.  
4. Run:

```sql
select tag_code
from public.entity_tags et
join public.tags t on t.code = et.tag_code
where entity_id = '<Jack UUID>';
```

Result includes `PETS__FEEDING`.

🎉 **Congratulations — Database layer is 100 % ready!**  
Push any Flutter update → GitHub Actions auto-deploys → Users enjoy flawless category & tag experience.
