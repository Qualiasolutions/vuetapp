  Active Context

## CRITICAL PROJECT STATUS: FLUTTER REPLICA OF REACT APP

**PRIMARY OBJECTIVE**: Create a literal replica of the React Native app (`react-old-vuet`) using Flutter + Supabase instead of React Native + Django. The goal is feature parity, not innovation.

## 🚨 CRITICAL MISSING FEATURES (BLOCKING REPLICA STATUS)

### 1. **ENTITY MANAGEMENT SYSTEM** ⚠️ **HIGHEST PRIORITY**
- **Status**: ❌ **NOT IMPLEMENTED** 
- **React Reference**: `/react-old-vuet/old-backend/core/models/entities/` (15+ entity types)
- **Documentation Reference**: Must align with the detailed models and structures in `memory-bank/Categories-Entities-Tasks-Connection/` documentation, particularly `vuet-complete-model` and `Categories-Entities-Tasks-Connection.md`.
- **Missing**: Complete entity management across all categories:
  - **Pets**: Vets, walkers, groomers, pet insurance, pet details
  - **Transport**: Cars, boats, public transport, insurance, MOT
  - **Career**: Professional goals, employees, days off
  - **Education**: Schools, terms, extracurriculars, academic planning
  - **Finance**: Financial tracking and planning
  - **Food**: Meal planning and food management
  - **Garden**: Garden planning and maintenance tracking
  - **Health**: Health goals, appointments, patient management
  - **Home**: Home appliances and maintenance
  - **Laundry**: Laundry planning and scheduling
  - **Lists**: Advanced list entity management
  - **Social**: Events, holidays, anniversaries, guest lists
  - **Travel**: Trip planning and travel bookings
- **Impact**: **80% of app functionality is missing without entity system**

### 2. **ADVANCED TASK SCHEDULING** ⚠️ **HIGHEST PRIORITY**
- **Status**: ❌ **BASIC TASKS ONLY**
- **React Reference**: `/react-old-vuet/old-backend/core/models/tasks/base.py`
- **Missing Features**:
  - **FlexibleTask vs FixedTask**: Two distinct task types with different scheduling
  - **Complex Recurrence**: DAILY, WEEKDAILY, WEEKLY, MONTHLY, YEARLY, MONTH_WEEKLY, YEAR_MONTH_WEEKLY, MONTHLY_LAST_WEEK
  - **Task Actions**: Pre-task actions with separate completion tracking
  - **Task Reminders**: Configurable reminder system
  - **Urgency Levels**: LOW, MEDIUM, HIGH urgency handling
  - **Duration-based Scheduling**: Flexible task duration and scheduling
  - **Recurrence Overwrites**: Ability to modify individual instances of recurring tasks
- **Current State**: Only basic task CRUD, no advanced scheduling
- **Impact**: **Core task functionality is primitive compared to React app**

### 3. **FAMILY/SOCIAL COLLABORATION** ⚠️ **HIGHEST PRIORITY**
- **Status**: ❌ **MINIMAL IMPLEMENTATION**
- **React Reference**: Family request system, shared entities, permissions
- **Missing Features**:
  - **Family Invitations**: Complete invitation and acceptance flow
  - **Shared Entity Access**: Family members sharing entities across categories
  - **Permission Management**: Role-based access to family resources
  - **Family Task Coordination**: Shared tasks and responsibilities
  - **Member Management**: Adding/removing family members
- **Current State**: Basic family screen exists but no functionality
- **Impact**: **Multi-user functionality completely missing**

## 🔄 SECONDARY MISSING FEATURES (POST-CORE)

### 4. **CALENDAR INTEGRATION**
- **Status**: ❌ **NO CALENDAR FUNCTIONALITY**
- **React Reference**: `/react-old-vuet/old-frontend/screens/CalendarMain/`
- **Missing**: iCal integration, external calendar sync, unified calendar view

### 5. **COMPREHENSIVE ROUTINES**
- **Status**: ❌ **BASIC SCREEN ONLY**
- **React Reference**: Complex routine management with task generation
- **Missing**: Routine scheduling, task generation, recurrence patterns

### 6. **TIMEBLOCKS SYSTEM**
- **Status**: ❌ **NAVIGATION ONLY**
- **React Reference**: Visual timeblock management with drag-and-drop
- **Missing**: Complete timeblock scheduling and management

## CURRENT FLUTTER APP STATUS (HONEST ASSESSMENT)

### ✅ **WHAT ACTUALLY WORKS**
1. **Authentication**: Supabase auth system working
2. **Basic Navigation**: Bottom tabs and drawer navigation
3. **Basic Tasks**: Simple task CRUD operations
4. **Basic Lists**: Simple list management
5. **LANA AI**: Chat interface with AI assistant
6. **UI Framework**: Material Design 3 theming and basic screens
7. **Categories**: Basic category viewing (global categories)

### ❌ **WHAT'S MISSING (CRITICAL GAPS)**
1. **Entity Management**: 0% implemented (biggest gap)
2. **Advanced Task Features**: 90% missing
3. **Family Features**: 95% missing 
4. **Calendar**: 100% missing
5. **Routines**: 90% missing
6. **Timeblocks**: 90% missing
7. **External Integrations**: 100% missing

**HONEST PROGRESS ASSESSMENT**: ~25-30% of React app functionality is implemented (database schema issues partially addressed, unblocking some entity operations)

## 🚨 CRITICAL BLOCKING ISSUES - IMMEDIATE PRIORITY

### Database Schema Mismatches (BLOCKING ALL ENTITY FUNCTIONALITY)
**Status**: ⚠️ **PARTIALLY ADDRESSED** - Core column name mismatches in Dart models and repositories have been addressed. Entity operations should now be less blocked by these specific schema issues. Further testing is required.

**Previously Identified Critical Errors & Actions Taken**:
1. **`entities.category_id` does not exist** (Error 42703)
   - **Action Taken**: Code refactored to use the existing `app_category_id` (integer) column in the `entities` table. Dart models (`BaseEntityModel`), repositories (`EntityRepository`, `SupabaseEntityRepository`), services (`EntityService`), providers, and relevant UI screens have been updated to use `appCategoryId` (int?) instead of `categoryId` (String?).
   - **Impact**: This specific error should be resolved. Entity listing by category should now use the correct column.

2. **`entity_categories.createdAt` column missing** (PGRS1204)
   - **Action Taken**: Database schema review confirmed `created_at` (snake\_case) exists. `EntityCategoryModel` updated with `@JsonKey(name: 'created_at')` to correctly map this field. Similar annotations added for `updated_at`, `owner_id`, and `is_professional`.
   - **Impact**: Deserialization of `EntityCategoryModel` should now work correctly for these timestamp and ID fields.

3. **`entities.owner_id` vs `user_id` mismatch**
   - **Action Taken**: `BaseEntityModel` updated to use `userId` with `@JsonKey(name: 'user_id')`, aligning with the `entities.user_id` database column.
   - **Impact**: Correct mapping for user ownership of entities.

**IMMEDIATE ACTIONS REQUIRED (POST-REFACTOR)**:
1. **Test Entity CRUD**: Thoroughly test create, read (especially listing by category), update, and delete operations for entities to confirm the fixes have unblocked functionality.
2. **Verify Category Selection in Forms**: The `DynamicEntityForm`'s category dropdown logic was simplified to resolve type errors. It needs review to ensure it correctly maps the selected `EntityCategoryModel.id` (String UUID) to an `int appCategoryId` for saving with `BaseEntityModel`. Currently, it passes `null` for `appCategoryId` when saving.
3. **Address Remaining UI Discrepancies**: Continue implementing UI patterns from the React app reference as outlined below.
4. **Run `dart run build_runner build --delete-conflicting-outputs`**: This was done after model changes.

### React App User Journey Analysis (7-Image Reference)

**Complete Target Flow**: Categories Grid → Category Intro → Subcategories → Entity List → Create Form → Success → Detail View

**Key UI Patterns from React App**:
1. **Categories Grid**: Clean 3x3 layout with Personal/Professional toggle at top
2. **Category Introduction**: Educational screens explaining category purpose (optional but good UX)
3. **Subcategories List**: For Pets: "My Pets", "Feeding", "Exercise", "Grooming", "Health", "Preferences"
4. **Entity List Screen**: "Quick Nav" + "I Want To" dropdowns, entity cards with image thumbnails
5. **Create Form**: Name*, Type*, Breed*, DOB*, Image upload, Family member selection*
6. **Success State**: Created entity appears in list with success message
7. **Entity Detail**: Calendar integration showing scheduled events (e.g., "Test's Birthday")

**Currently Missing from Flutter App**:
- ❌ "Quick Nav" and "I Want To" dropdowns in entity screens
- ❌ Entity cards with image thumbnails in lists
- ❌ Calendar integration in entity detail views
- ❌ Family member selection in creation forms
- ❌ Proper success states and user feedback
- ❌ Category introduction/onboarding screens

**Current Status**: Navigation works (Categories → Subcategories → Entity List), but entity operations fail due to database issues.

## IMMEDIATE ACTION ITEMS

### PHASE 1: CORE ENTITY SYSTEM (WEEKS 1-3)
1. **Implement Entity Base Classes & Types**: 
   - Create `Entity` base model with polymorphic inheritance.
   - Implement 15+ entity types (pets, transport, career, etc.).
   - Set up Supabase tables for all entity types.
   - Ensure all entity types, their fields, and relationships strictly follow the specifications in `memory-bank/Categories-Entities-Tasks-Connection/` documentation.
2. **Entity CRUD Operations**:
   - Create entity management repositories
   - Implement entity forms for each type
   - Add entity listing and detail screens
3. **Entity-Task Integration**:
   - Link entities to tasks
   - Entity-specific task templates

### PHASE 2: ADVANCED TASK SYSTEM (WEEKS 4-6)
1. **Task Type Implementation**:
   - Implement `FlexibleTask` and `FixedTask` models
   - Add urgency, duration, and advanced scheduling
2. **Recurrence System**:
   - Implement all 8 recurrence types from React app
   - Add recurrence overwrite functionality
3. **Task Actions & Reminders**:
   - Separate action system with completion tracking
   - Configurable reminder system

### PHASE 3: FAMILY COLLABORATION (WEEKS 7-8)
1. **Family System**:
   - Implement family invitation flow
   - Add member management
   - Set up shared entity permissions
2. **Collaboration Features**:
   - Shared tasks and entities
   - Permission-based access control

## REFERENCE ARCHITECTURE

### Use React App as Specification
- **Backend Models**: `/react-old-vuet/old-backend/core/models/` - exact data structure reference
- **Frontend Screens**: `/react-old-vuet/old-frontend/screens/` - exact UI flow reference  
- **Navigation**: `/react-old-vuet/old-frontend/navigation/` - exact app structure reference
- **Redux State**: `/react-old-vuet/old-frontend/reduxStore/` - exact data flow reference

### Migration Strategy
1. **Model-First**: Implement Supabase tables matching Django models exactly
2. **Repository Pattern**: Create repositories matching React API calls
3. **Screen-by-Screen**: Replicate each React screen in Flutter
4. **Feature Parity**: Match every feature before adding enhancements

## CONTEXT FOR NEXT AGENT

**CRITICAL UNDERSTANDING**: This is NOT a new app. This is a migration/replica project. The React app (`react-old-vuet`) is the complete specification. The Flutter app is currently missing 75-80% of the functionality.

**PRIORITY ORDER**:
1. Entity Management System (enables 80% of app functionality)
2. Advanced Task Scheduling (core feature parity)
3. Family Collaboration (multi-user functionality)
4. Calendar Integration (time management)
5. Everything else

**DO NOT**: Add new features until feature parity is achieved.
**DO**: Use React app as the complete specification for every feature.

The app should be running at: https://qaaaa-448c6.web.app
React reference app is in: `/react-old-vuet/`
Current Flutter implementation progress: **~25% complete**
