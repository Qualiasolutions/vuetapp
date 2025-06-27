# Implementation Progress Summary  
_Date: 27 Jun 2025_

---

## 1  Gap Analysis Recap
We compared the legacy React-Native/Django category stack with the current Flutter/Supabase code-base and found 3 major gaps:

| Area | Legacy Status | Flutter Status (before today) | Gap |
|------|---------------|-------------------------------|-----|
| Sub-category → Entity → “I WANT TO” quick actions | Fully functional via tag system | Sub-categories partially rendered, **no** quick-action menu, no tag filtering | **HIGH** |
| Tag persistence | `core/utils/tags.py` + many-to-many table | — | **MISSING** |
| Entity ↔ Tag ↔ Task filter screens | Implemented | Placeholder arrays (`iWantToItems`) | **MISSING** |

---

## 2  Work Completed _today_

| ⚙️ Change | File(s) | Notes |
|-----------|---------|-------|
| **Reusable “I WANT TO” bottom-sheet** | `lib/ui/widgets/i_want_to_menu.dart` | • Dynamically builds options from entity subtype<br>• Calls `TagFilterTaskScreen` or `CreateTaskScreen` |
| **Hook button on Entity Detail** | `lib/ui/screens/entities/entity_navigator_screen.dart` | Added `IconButton(Icons.lightbulb_outline)` that opens the new menu |
| **Tags data-model & RLS** | `supabase/migrations/20250627000000_create_tags_tables.sql` | • `tags` & `entity_tags` tables<br>• Seeded 70 + tag codes (PETS__, SOCIAL__, …)<br>• RLS policies for owners/members |
| **Migration Blueprint** | `docs/category-migration-analysis.md` (created earlier) | Full spec of tables, screens, route scheme |

Snippet – opening the menu inside **EntityNavigatorScreen**:

```dart
IconButton(
  icon: const Icon(Icons.lightbulb_outline),
  tooltip: 'I WANT TO…',
  onPressed: () => IWantToMenu.show(context, entity),
),
```

---

## 3  What’s Already Working
* 9-tile **CategoriesGrid** (`lib/ui/screens/categories/categories_grid.dart`)
* Complete **Pets** category UI (list, forms, FAB)
* Entity detail navigator with Overview, Calendar, etc.
* Riverpod state-management & GoRouter navigation
* Supabase auth + real-time channels

---

## 4  Outstanding Work

| Todo | Importance |
|------|------------|
| Integrate **TagFilterTaskScreen** with real SQL query (`select … where tags && …`) | High |
| Build sub-category list screens for: Social, Education/Career, Home & Garden, etc. | High |
| Freezed models & CRUD repos for missing entities (Finance, Transport, Charity & Religion) | High |
| UI for member management (every entity must have ≥ 1 member) | Medium |
| GitHub CI step: `flutter build web --release` → `firebase deploy` | Medium |
| Documentation for Contributors | Low |

---

## 5  Next Steps / Priorities
1. **Pets Tag Flow E2E**
   * Populate `entity_tags` when user picks an “I WANT TO” option.
   * Implement `TaskService.getTasksByTag(tag[, entity])`.
2. **Sub-category Grids**
   * Use `SubCategoryScreen` as template; replicate for Social, Travel, etc.
3. **Seed Remaining Tags & Categories in Supabase Prod**
4. **Automated Deploy Pipeline**
   * Add GitHub Action:  
     `flutter test` → `flutter build web --wasm` → `firebase deploy --only hosting`
5. **QA Regression Cycle** (mobile + web)

---

## 6  Testing the New Features

```bash
# 1.  Update dependencies & code-gen
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# 2.  Run locally
flutter run -d chrome .

# 3.  Build web for staging
flutter build web --release

# 4.  Deploy to Firebase (requires logged-in CLI & correct project)
firebase deploy --only hosting
```

After deployment:
* Open `/entity/<uuid>` → tap the 💡 icon → verify the “I WANT TO” sheet shows correct options.
* Choose “Feeding Schedule” → app should navigate to **TagFilterTaskScreen** listing tasks tagged `PETS__FEEDING`.
* Create a task → ensure `entity_tags` row is written.

---

_This summary will be updated after each milestone delivery._
