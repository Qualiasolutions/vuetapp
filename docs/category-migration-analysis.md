# Category → Flutter/Supabase Migration Technical Specification  
_Version 1.0 – 27 June 2025_

---

## 1  Scope & Objectives
This document maps the *entire* legacy React-Native/Django **category / subcategory / entity** model and defines how to reproduce (and improve) it in the new **Flutter / Supabase** code-base.

Goals  
* 1-for-1 functional parity for all **9 top-level grid categories** (Pets → Charity & Religion).  
* Preserve sub-category flows, entity creation, “I WANT TO” quick-action menus, and task linking.  
* Design a Supabase schema that replaces polymorphic Django models without losing flexibility.  
* Provide a repeatable Flutter architecture pattern (Riverpod + GoRouter).  
* Highlight **implemented vs missing** parts to guide backlog creation.

---

## 2  Legacy Category Matrix

| # | Grid Category | Sub-categories (from `subCategories.ts`) | Core Entity Types (Django) | Default “I WANT TO” Tags |
|---|---------------|------------------------------------------|----------------------------|--------------------------|
| 1 | **Pets** | My Pets · Feeding Schedule · Exercise · Grooming · Health | `Pet`, `PetBirthday`, `Vet`, `Walker`, `Groomer`, `Sitter`, `MicrochipCompany`, `InsuranceCompany`, `InsurancePolicy` | PETS__FEEDING · PETS__EXERCISE · PETS__GROOMING · PETS__HEALTH |
| 2 | **Social Interests** | Social Plans · Anniversaries · National Holidays · Events · Hobbies · Social Media · My Social Info | `SocialPlan`, `Anniversary`, `Event`(+Subentity), `Hobby`, `SocialMedia` | SOCIAL_INTERESTS__INFORMATION__PUBLIC |
| 3 | **Education & Career** | **Education** → Students · Schools · School Terms · Academic Plans · Extracurricular Plans<br>**Career** → Employees · Days Off · Career Goals · My Career Info | `Student`, `School`, `SchoolTerm*`, `AcademicPlan`, `ExtracurricularPlan`, `Employee`, `DaysOff`, `CareerGoal` | CAREER__INFORMATION__PUBLIC |
| 4 | **Travel** | My Trips · My Travel Plans · Traveller Info | `Trip`, `TravelPlan`, `Flight`, `TrainBusFerry`, `RentalCar`, `TaxiOrTransfer`, `DriveTime`, `HotelOrRental`, `StayWithFriend` | TRAVEL__INFORMATION__PUBLIC |
| 5 | **Health & Beauty** | Patients · Appointments · Goals | `Patient`, `Appointment`, `HealthGoal` | *(none – actions embedded in entity forms)* |
| 6 | **Home & Garden** | **Home** → My Homes · Home Info<br>**Garden** → Gardens · Garden Info<br>**Food** → Food Plans · Food Info<br>**Laundry** → Laundry Plans · Laundry Info | `Home`, `Garden`, `FoodPlan`, `LaundryPlan`, `Clothing` | HOME / GARDEN / FOOD / LAUNDRY __INFORMATION__PUBLIC |
| 7 | **Finance** | My Finances · Finance Info | `Finance` | FINANCE__INFORMATION__PUBLIC |
| 8 | **Transport** | Cars · Boats · Public Transport · Transport Info | `Car`, `Boat`, `PublicTransport` | TRANSPORT__INFORMATION__PUBLIC |
| 9 | **Charity & Religion** (replaces **References**) | Reference Groups · References | `ReferenceGroup`, `Reference` | *(future configurable)* |

---

## 3  Navigation Flow Patterns

```mermaid
flowchart TD
  A[Categories Grid] -->|tap| B{Has >1 sub-category?}
  B -- Yes --> C[SubCategory List]
  B -- No  --> D
  C --> D[Entity List]
  D -->|+| E[Entity Form]
  D -->|tap entity| F[Entity Detail]
  F --> G[Task List ← entity filter]
  F -->|Create Task| H[Task Form (entity pre-linked)]
  F -->|I WANT TO| I[Quick Action Sheet (tag filters)]
```

Routing (GoRouter recommendation):
```
/categories/:cat
/categories/:cat/:sub
/entity/:uuid
/entity/:uuid/new-task
```

---

## 4  Supabase Data-model Requirements

| Table | Purpose | Key Columns & Notes |
|-------|---------|---------------------|
| `categories` | 9 grid groups | id PK, name, icon, sort_order |
| `subcategories` | Second-level menu | id PK, category_id FK, name, icon |
| `entities` | Polymorphic base | uuid PK, subcategory_id FK, owner, name, subtype, notes, image_url, hidden, created_at |
| `entity_members` | User ↔ entity | entity_uuid, user_id, role |
| `tags` | “I WANT TO” codes | code PK, label, category_id |
| `entity_tags` | Entity ↔ tag | entity_uuid, tag_code |
| `tasks` | Unified task/appointment | id PK, title, type ENUM, schedule jsonb, notes |
| `task_entities` | Task ↔ entity | task_id, entity_uuid |
| `routines` | Recurrence engine | id, cron, tz |
| `reference_groups` | Charity & Religion grouping | id, name, created_by |
| `references` | Key-value pairs | id, group_id, type ENUM, name, value |

Indexes  
* `GIN` on `entity_tags.tag_code` for fast tag filters.  
* `btree` on `entities.subcategory_id` + `owner`.

RLS highlights  
* Entities: `owner=auth.uid() OR EXISTS entity_members(member=auth.uid())`  
* Tasks: similar via join on `task_entities`.

---

## 5  Flutter Implementation Plan

### 5.1  State Management  
* Riverpod `FutureProvider` / `StreamProvider` per table.  
* `entityRepositoryProvider`, `taskRepositoryProvider`, `tagProvider`.

### 5.2  UI Layers  
1. **Presentation** – Widgets only (`ui/screens` + `ui/widgets`).  
2. **Domain** – Freezed models & Riverpod notifiers (`src/features`).  
3. **Data** – Supabase sources / mappers (`data/…`).

### 5.3  Screen Set
| Widget | Responsibility |
|--------|----------------|
| `CategoriesGrid` | Grid of 9 `CategoryCard` |
| `SubCategoryGrid` | Grid/List of sub-categories |
| `EntityListPage` | Lazy paginated list, FAB “Add” |
| `EntityDetailPage` | Tabs: Details • Tasks • Files |
| `TaskComposer` | Pre-loads `entity_uuid` if from context |
| `IWantToMenu` | BottomSheet of tag actions (drives filters) |

### 5.4  Navigation (GoRouter Example)
```dart
GoRoute(
  path: '/entity/:uuid',
  builder: (ctx, st) => EntityDetailPage(uuid: st.params['uuid']!),
),
```
Use typed route data classes (`freezed` sealed classes) for safety.

### 5.5  Validation Rules
* Creating an entity auto-links **current user** in `entity_members`.  
* Can’t delete entity with linked tasks unless cascading confirmed.  
* Tag quick-actions run filtered query:  
  ```sql
  select * from tasks
  where task_entities.entity_uuid = :uuid
    and tags && array[:tag]
  ```

---

## 6  Recommended Code Structure

```
lib/
 ├─ data/
 │   ├─ models/            // DTOs (json_serializable)
 │   ├─ sources/           // SupabaseDataSource
 │   └─ repositories/      // EntityRepository, TaskRepository …
 ├─ src/
 │   └─ features/
 │       ├─ categories/    // application/domain/presentation
 │       ├─ entities/
 │       ├─ tasks/
 │       ├─ tags/
 │       └─ navigation/    // typed route definitions
 ├─ ui/
 │   ├─ screens/
 │   └─ widgets/
 ├─ docs/
 └─ main.dart
```

Tooling  
* `freezed`, `riverpod_generator`, `build_runner --watch`.  
* `very_good_analysis` for linting.

---

## 7  Gap Analysis (GitHub repo vs Legacy)

| Concern | Legacy Present | Flutter Repo Status | Gap / TODO |
|---------|----------------|---------------------|------------|
| **Grid of 9 categories** | 8+References | Grid exists but uses 10 group definitions; needs *Charity & Religion* & removal of References premium gating | ✔ update `_targetDisplayGroups` & icons |
| **Sub-category lists** | All defined in `subCategories.ts` | Pets, Social, Education etc. partially implemented; many sub-category tiles still **TODO** | ✔ add missing list pages (e.g. Laundry, Garden) |
| **Entity models** | Polymorphic Django classes | Freezed models exist for Pets; most others missing | ✔ create Freezed models per matrix |
| **Supabase tables** | PostgreSQL via Django | Partially migrated (entity_categories, entities) | ✔ add `subcategories`, `entity_tags`, `reference_*` |
| **“I WANT TO” tags** | `core/utils/tags.py` | No dedicated table; hard-coded enum in old code | ✔ seed `tags` table; create `TagRepository` |
| **Entity ↔ Task linking** | Many-to-many Django | Basic relation exists (`task_entities` in code) but not wired in UI | ✔ update task composer & filters |
| **Navigation** | React Navigation nested | GoRouter implemented; needs typed routes & deep links | ✔ refactor to typed routes |
| **Charity & Religion** | Not in legacy grid (References) | Placeholder screen exists | ✔ implement screens + Supabase schema |
| **Build & Deploy** | Expo OTA + S3 | Flutter web hosted on Firebase | **Automate**: `flutter build web` ➜ `firebase deploy` via GitHub Actions |

---

## 8  Migration Roadmap

1. **Database**  
    • Apply SQL migration for new tables/enums.  
    • Seed 9 categories & all sub-categories.  

2. **Domain Models**  
    • Generate Freezed models for remaining entities.  

3. **Pets MVP** *(already 70 % built)*  
    • Wire Supabase CRUD → UI lists → detail → tasks.  
    • Add `IWantToMenu` bottom sheet.

4. **Roll-out Remaining Categories**  
    • Social, Education/Career, Travel, … iterate weekly.  

5. **Charity & Religion**  
    • New supabase seed; reference group UI.  

6. **Automated CI**  
    • GitHub Actions: `flutter test` → `flutter build web` → `firebase deploy`.  

---

## 9  Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|-----------|
| Data loss in polymorphic flattening | High | Keep `subtype` + `jsonb extra_data`; run migration scripts with backups |
| Large tag arrays → slow queries | Medium | GIN index; restrict search scope |
| Flutter navigation complexity | Medium | Central typed GoRouter; deep-link tests |
| Web build size | Low | `flutter build web --wasm` & tree-shaking |

---

## 10  Conclusion
The blueprint above translates every aspect of the legacy category system into a **Supabase-first backend** and **Flutter-Riverpod** frontend. Implementation should proceed *category-by-category* starting with **Pets** to deliver incremental value while de-risking complexity. Continuous integration with `flutter build web` and `firebase deploy` ensures fast feedback and parity validation.
