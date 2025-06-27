# ✅ Complete Category-System Implementation Tracker  
_Version 1.0 • 2025-06-27_

This document is the **single source of truth** for finishing the migration of Vuet’s legacy React/Django category stack to the new **Flutter + Supabase** code-base.  
When every checkbox below is ✅ the category system is **100 % feature-complete**.

---

## 1 · At-a-Glance Progress Matrix

| # | Category (Grid) | Sub-category Screens                                       | Entity Models (Freezed + Supabase) | “I WANT TO” Tags seeded | Task Filter & Create | Member RLS ✓ | Realtime Streams | Tests (Widget + E2E) |
|---|-----------------|------------------------------------------------------------|------------------------------------|------------------------|----------------------|--------------|------------------|----------------------|
| 1 | **Pets**        | Pets, Vet, Groomer, Sitter, Walker, MicrochipCo, Ins.*    | Pet, Vet, Groomer…                 | PETS__*                | ✅                  | ✅           | ✅              | ✅                  |
| 2 | **Social**      | Social Plans, Events, Hobbies, Holidays, Anniversaries    | SocialPlan, Event, Hobby…          | SOCIAL__*              | ⬜                  | ⬜            | ⬜               | ⬜                  |
| 3 | **Edu & Career**| Students, Schools, Terms, Academic Plan, Employees, Goals | Student, School, Employee…         | EDUCATION__*, CAREER__*| ⬜                  | ⬜            | ⬜               | ⬜                  |
| 4 | **Travel**      | Trips, Travel Plans, Traveller Info                        | Trip, TravelPlan, Flight…          | TRAVEL__*              | ⬜                  | ⬜            | ⬜               | ⬜                  |
| 5 | **Health & Beauty** | Patients, Appointments, Goals                          | Patient, Appointment, HealthGoal   | HEALTH_BEAUTY__*       | ⬜                  | ⬜            | ⬜               | ⬜                  |
| 6 | **Home & Garden** | Homes, Gardens, Food Plans, Laundry Plans                | Home, Garden, FoodPlan, Laundry…   | HOME__/GARDEN__/…      | ⬜                  | ⬜            | ⬜               | ⬜                  |
| 7 | **Finance**     | Finances, Finance Info                                     | Finance                            | FINANCE__*             | ⬜                  | ⬜            | ⬜               | ⬜                  |
| 8 | **Transport**   | Cars, Boats, Public Transport, Transport Info              | Car, Boat, PublicTransport         | TRANSPORT__*           | ⬜                  | ⬜            | ⬜               | ⬜                  |
| 9 | **Charity & Religion** | Ref Groups, References                              | ReferenceGroup, Reference          | CHARITY_RELIGION__*    | ⬜                  | ⬜            | ⬜               | ⬜                  |

Legend:  
✅ = done ⬜ = pending Ins.* = Insurance Company/Policy

---

## 2 · Detailed Implementation Checklist

### 2.1 Pets (⭐ Baseline – completed)

- [x] **Screens**: category, all sub-lists & forms  
- [x] **Models**: Pet, Vet, Walker… (`lib/models/pet_entities.dart`)  
- [x] **Tags** inserted (`PETS__FEEDING` …)  
- [x] **I WANT TO Menu** integrated (💡 button)  
- [x] **Task flows**: create & filter by tag  
- [x] **Member enforcement**: entity_members trigger in `CreatePetForm`  
- [x] **Realtime**: `StreamProvider.family` for pet list  
- [x] **Tests**: widget + integration happy path

### 2.2 Social Interests (Priority P1)

- [ ] Sub-category grid + FAB
- [ ] Freezed models: `SocialPlan`, `Event`, `Hobby`, `Holiday`, `Anniversary`
- [ ] Tag seed: `SOCIAL_INTERESTS__BIRTHDAY`, `ANNIVERSARY`, `HOLIDAY`, `INFORMATION`
- [ ] Implement menu mapping in `entityTagOptionsProvider`
- [ ] Task filter screen (`TagFilterTaskScreen`) – social scope
- [ ] Realtime list streams
- [ ] Tests: CRUD + tag filter

### 2.3 Education & Career (P1)

- [ ] Screens: Students, Schools, Academic, Employees, DaysOff
- [ ] Models: Student, School\*, Employee, CareerGoal…
- [ ] Tags: `EDUCATION__ASSIGNMENT`, `CAREER__MEETING`, …
- [ ] Task creation preset forms (Assignment, Exam)
- [ ] Member = linked student/employee
- [ ] Tests

### 2.4 Travel (P2)

- [ ] Trip & TravelPlan screens
- [ ] Flight/Hotel sub-entities
- [ ] Tags: `TRAVEL__BOOKING`, `PACKING`, `FLIGHT`
- [ ] Calendar integration
- [ ] Tests (task reminders)

### 2.5 Health & Beauty (P2)

- [ ] Patients, Appointments, Goals
- [ ] Tags: `HEALTH_BEAUTY__APPOINTMENT`, `MEDICATION`
- [ ] Task auto-link on appointment create
- [ ] Member = patient
- [ ] Tests

### 2.6 Home & Garden (P3)

- [ ] Homes, Gardens, Food, Laundry
- [ ] Tags: `HOME__MAINTENANCE`, `GARDEN__PLANTING`, `FOOD__SHOPPING`, `LAUNDRY__WASHING`
- [ ] Recipe & clothing care entities
- [ ] Tests

### 2.7 Finance (P3)

- [ ] Finance screen + CRUD
- [ ] Tags: `FINANCE__PAYMENT`, `BUDGET`, `TAX`
- [ ] Task → reminder for due date
- [ ] Tests (RLS on sensitive data)

### 2.8 Transport (P3)

- [ ] Vehicle lists & forms
- [ ] Tags: `TRANSPORT__MOT_DUE`, `INSURANCE`, `SERVICE_DUE`
- [ ] Task auto-generate due reminders
- [ ] Tests

### 2.9 Charity & Religion (P4)

- [ ] ReferenceGroup & Reference screens
- [ ] Tags: `CHARITY_RELIGION__DONATION`, `EVENT`
- [ ] Upcoming donation schedule task flow
- [ ] Tests

---

## 3 · Cross-Cutting Tasks

| Task | Owner | Status |
|------|-------|--------|
| **Member RLS trigger** (`entity_members`) in Supabase | BE | ✅ Pets · ⬜ others |
| **`entity_tags` service & repository** | BE / FE | ⬜ |
| **Global `IWantToMenu` provider tests** | FE | ⬜ |
| **Deep-link routes** (`/entity/:uuid`) | FE | ✅ |
| **Realtime filters** via Supabase channels | BE / FE | ⬜ |
| **CI – widget & integration tests on PR** | DevOps | ✅ |
| **CD – auto Firebase deploy** | DevOps | ✅ |

---

## 4 · Phase Roadmap

| Sprint | Deliverables | Categories Completed |
|--------|--------------|----------------------|
| **S1** (Done) | Pets end-to-end; Tags table & CD pipeline | Pets |
| **S2** | Social Interests + Education sub-half; entity_tags service; tag filter logic | Pets · Social · Edu(½) |
| **S3** | Finish Education & Career; Travel; realtime channels | + Edu/Career · Travel |
| **S4** | Health & Beauty; Home & Garden; advanced tests | + Health · Home/Garden |
| **S5** | Finance; Transport; Charity & Religion; polish & docs | **All 9** |

---

## 5 · Testing Strategy

1. **Unit tests**  
   - Freezed model (JSON) round-trip  
   - Tag provider mappings  
   - Repository CRUD with Supabase mocking

2. **Widget tests**  
   - Category grid navigation  
   - I WANT TO menu renders correct options  
   - Task filter list shows expected tasks

3. **Integration tests (Flutter Driver / Playwright)**  
   - Create > Tag > Filter happy paths per category  
   - Member RLS violation attempts (expect failure)  
   - Realtime task list update (second browser tab)

4. **CI coverage threshold:** ≥ 80 %

---

## 6 · Definition of “100 % Correct”

A category is **Done** when:  
- All CRUD screens & forms exist and are responsive  
- “I WANT TO” menu presents tag options matching legacy spec  
- Selecting a tag opens `TagFilterTaskScreen` showing correct filtered tasks  
- Tags are persisted in `entity_tags` and retrieved in realtime  
- **At least one** automated test covers the flow  
- Member RLS prevents unauthorized access  
- Live deployment passes smoke test

---

_Last updated : 2025-06-27_  
_To update progress, edit this file and tick boxes._  
