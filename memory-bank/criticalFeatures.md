# Critical Missing Features - Implementation Specification

## 🚨 TOP 3 CRITICAL FEATURES FOR FLUTTER REPLICA

These three features are absolutely essential and represent 90% of the functionality gap between the Flutter app and the React app. **NOTHING ELSE SHOULD BE IMPLEMENTED** until these are complete.

---

## 1. **ENTITY MANAGEMENT SYSTEM** ⚠️ **HIGHEST PRIORITY**

### Overview
**80% of the app's value comes from entity management**. The React app is fundamentally an entity management system with task integration. Without entities, the app is essentially useless.

### React Reference Implementation
- **Models**: `/react-old-vuet/old-backend/core/models/entities/`
- **Screens**: `/react-old-vuet/old-frontend/screens/EntityPages/`
- **Redux State**: `/react-old-vuet/old-frontend/reduxStore/slices/entities/`

### Required Entity Types (15+ categories)

#### **Pets Category** (`pets.py`)
- **Pet**: Basic pet information (name, breed, age, etc.)
- **Vet**: Veterinary clinics and doctors
- **PetWalker**: Dog walking services
- **PetGroomer**: Pet grooming services
- **PetInsurance**: Pet insurance policies
- **PetMedication**: Pet medication tracking

#### **Transport Category** (`transport.py`)
- **Car**: Vehicle information, registration, insurance
- **Boat**: Boat details and documentation
- **PublicTransport**: Public transport information
- **TransportInsurance**: Vehicle insurance policies
- **MOT**: MOT test tracking

#### **Career Category** (`career.py`)
- **ProfessionalGoal**: Career goals and tracking
- **Employee**: Employee information and management
- **DayOff**: Time off requests and tracking

#### **Education Category** (`education.py`)
- **School**: Educational institutions
- **Term**: Academic terms and semesters
- **Extracurricular**: After-school activities
- **AcademicPlan**: Academic planning and goals

#### **Social Category** (`social.py`)
- **Event**: Social events and gatherings
- **Holiday**: Holiday planning and tracking
- **Anniversary**: Anniversary and special date tracking
- **GuestList**: Event guest management

#### **Health Category** (`health.py`)
- **HealthGoal**: Health and fitness goals
- **Appointment**: Medical appointments
- **Patient**: Patient information and tracking

#### **Home Category** (`home.py`)
- **Appliance**: Home appliance tracking
- **Maintenance**: Home maintenance tasks
- **HomeInsurance**: Home insurance policies

#### **Lists Category** (`lists.py`)
- **ListEntity**: Advanced list management
- **ShoppingList**: Shopping-specific lists
- **PlanningList**: Planning and preparation lists

#### **And More**: Finance, Food, Garden, Laundry, Travel entities...

### Implementation Requirements

#### **Supabase Database Schema**
```sql
-- Base entities table
CREATE TABLE entities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    entity_type VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    owner_id UUID REFERENCES profiles(id),
    family_id UUID REFERENCES families(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    -- Polymorphic fields as JSONB
    entity_data JSONB NOT NULL DEFAULT '{}'
);

-- Category-specific tables for complex entities
CREATE TABLE pet_entities (
    id UUID PRIMARY KEY REFERENCES entities(id),
    breed VARCHAR(100),
    age INTEGER,
    weight DECIMAL,
    vet_id UUID REFERENCES entities(id)
);

-- Similar tables for each entity type...
```

#### **Flutter Models** (with Freezed)
```dart
@freezed
class Entity with _$Entity {
  const factory Entity({
    required String id,
    required String entityType,
    required String name,
    String? description,
    String? ownerId,
    String? familyId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required Map<String, dynamic> entityData,
  }) = _Entity;

  factory Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);
}

// Specific entity types
@freezed
class Pet extends Entity with _$Pet {
  const factory Pet({
    // Base Entity fields
    required String id,
    required String name,
    // Pet-specific fields
    String? breed,
    int? age,
    double? weight,
    String? vetId,
  }) = _Pet;
}
```

#### **Repository Implementation**
```dart
abstract class EntityRepository {
  Future<List<Entity>> getEntitiesByCategory(String category);
  Future<List<Entity>> getUserEntities(String userId);
  Future<List<Entity>> getFamilyEntities(String familyId);
  Future<Entity> createEntity(Entity entity);
  Future<Entity> updateEntity(Entity entity);
  Future<void> deleteEntity(String entityId);
}

class SupabaseEntityRepository implements EntityRepository {
  // Implementation using Supabase client
}
```

#### **UI Screens Required**
1. **Entity Category Screen**: Browse entities by category
2. **Entity List Screen**: List all entities in a category
3. **Entity Detail Screen**: View/edit specific entity
4. **Entity Creation Screen**: Create new entity with type-specific form
5. **Entity Search Screen**: Search across all entities

### Entity-Task Integration
- **Task Creation**: Select entities when creating tasks
- **Entity Tasks**: View all tasks related to an entity
- **Entity Scheduling**: Schedule entity-specific tasks
- **Entity Reminders**: Set up entity maintenance reminders

---

## 2. **ADVANCED TASK SCHEDULING** ✅ **BACKEND COMPLETE** → ⚠️ **UI INTEGRATION NEEDED**

### Overview
✅ **Phase 2 Backend Infrastructure Complete**: Advanced task scheduling backend fully implemented with sophisticated dual scheduling system, complex recurrence, actions, and reminders.
⚠️ **UI Integration Required**: Need to implement user interface components to leverage the completed backend infrastructure.

### React Reference Implementation  
- **Models**: `/react-old-vuet/old-backend/core/models/tasks/base.py`
- **Screens**: `/react-old-vuet/old-frontend/screens/Forms/TaskForms/`
- **Redux State**: `/react-old-vuet/old-frontend/reduxStore/slices/tasks/`

### ✅ **IMPLEMENTED TASK TYPES** (Backend Complete)

#### **FlexibleTask** - Duration-based scheduling ✅ **COMPLETE**
```dart
@freezed
class FlexibleTask with _$FlexibleTask {
  factory FlexibleTask({
    required String id,
    required String title,
    required String userId,
    required int duration, // minutes
    required TaskUrgency urgency,
    required DateTime earliestActionDate,
    DateTime? dueDate,
    DateTime? scheduledStartTime,
    DateTime? scheduledEndTime,
    @Default(false) bool isScheduled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _FlexibleTask;
}
```

#### **FixedTask** - Time-specific scheduling ✅ **COMPLETE**
```dart
@freezed
class FixedTask with _$FixedTask {
  factory FixedTask({
    required String id,
    required String title,
    required String userId,
    required DateTime startDateTime,
    required DateTime endDateTime,
    String? startTimezone,
    int? duration, // Calculated automatically
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _FixedTask;
}
```

### ✅ **IMPLEMENTED RECURRENCE SYSTEM** (Backend Complete)
```dart
enum RecurrenceType {
  daily,
  weekdaily,
  weekly,
  monthly,
  yearly,
  monthWeekly,
  yearMonthWeekly,
  monthlyLastWeek,
}

@freezed
class Recurrence with _$Recurrence {
  factory Recurrence({
    required String id,
    required String taskId,
    required RecurrenceType recurrenceType,
    @Default(1) int intervalLength,
    Map<String, dynamic>? recurrenceData,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Recurrence;
}
```

### ✅ **IMPLEMENTED TASK ACTIONS & REMINDERS** (Backend Complete)
```dart
@freezed
class TaskAction with _$TaskAction {
  factory TaskAction({
    required String id,
    required String taskId,
    required String actionDescription,
    @Default(false) bool isRequired,
    int? estimatedMinutes,
    @Default(false) bool isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TaskAction;
}

@freezed
class TaskReminder with _$TaskReminder {
  factory TaskReminder({
    required String id,
    required String taskId,
    required ReminderType reminderType,
    required int reminderMinutesBefore,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TaskReminder;
}
```

### ✅ **IMPLEMENTED DATABASE SCHEMA** (Backend Complete)
```sql
-- Enhanced tasks table (APPLIED)
ALTER TABLE tasks ADD COLUMN scheduling_type varchar(20) CHECK (scheduling_type IN ('FLEXIBLE', 'FIXED'));
ALTER TABLE tasks ADD COLUMN earliest_action_date date;
ALTER TABLE tasks ADD COLUMN duration_minutes integer;
ALTER TABLE tasks ADD COLUMN task_urgency varchar(20);
ALTER TABLE tasks ADD COLUMN scheduled_start_time timestamptz;
ALTER TABLE tasks ADD COLUMN scheduled_end_time timestamptz;
ALTER TABLE tasks ADD COLUMN is_scheduled boolean DEFAULT false;
ALTER TABLE tasks ADD COLUMN start_timezone varchar(100);
ALTER TABLE tasks ADD COLUMN end_timezone varchar(100);

-- New tables created (APPLIED)
CREATE TABLE recurrences (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id uuid REFERENCES tasks(id) ON DELETE CASCADE,
  recurrence_type varchar(50) NOT NULL,
  interval_length integer DEFAULT 1,
  recurrence_data jsonb,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE task_actions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id uuid REFERENCES tasks(id) ON DELETE CASCADE,
  action_description text NOT NULL,
  is_required boolean DEFAULT false,
  estimated_minutes integer,
  is_completed boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE task_reminders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id uuid REFERENCES tasks(id) ON DELETE CASCADE,
  reminder_type varchar(20) NOT NULL,
  reminder_minutes_before integer NOT NULL,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE task_entities (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id uuid REFERENCES tasks(id) ON DELETE CASCADE,
  entity_id uuid REFERENCES entities(id) ON DELETE CASCADE,
  relationship_type varchar(50),
  is_primary boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);
```

### ✅ **IMPLEMENTED REPOSITORY LAYER** (Backend Complete)
```dart
class AdvancedTaskRepository {
  // FlexibleTask Operations (IMPLEMENTED)
  Future<List<FlexibleTask>> getUnscheduledFlexibleTasks(String userId);
  Future<List<FlexibleTask>> getFlexibleTasksByUrgency(String userId, TaskUrgency urgency);
  Future<FlexibleTask> scheduleFlexibleTask(String taskId, DateTime startTime, DateTime endTime);
  
  // FixedTask Operations (IMPLEMENTED)
  Future<List<FixedTask>> getFixedTasksInRange(String userId, DateTime start, DateTime end);
  Future<bool> hasConflictingFixedTasks(String userId, DateTime start, DateTime end);
  Future<List<FixedTask>> getActiveFixedTasks(String userId);
  
  // Recurrence Management (IMPLEMENTED)
  Future<Recurrence> createRecurrence(Recurrence recurrence);
  Future<List<DateTime>> calculateRecurrenceOccurrences(String recurrenceId, int count);
  
  // Task Actions & Reminders (IMPLEMENTED)
  Future<List<TaskAction>> getTaskActions(String taskId);
  Future<List<TaskReminder>> getTaskReminders(String taskId);
  
  // Task-Entity Integration (IMPLEMENTED)
  Future<void> linkTaskToEntity(String taskId, String entityId, String relationshipType);
  Future<List<TaskEntity>> getTaskEntities(String taskId);
}
```

### ⚠️ **REQUIRED UI COMPONENTS** (Implementation Needed)
```dart
// 1. Task Creation UI (NEEDED)
class TaskCreationScreen extends StatelessWidget {
  Widget buildSchedulingTypeSelector(); // Flexible vs Fixed
  Widget buildFlexibleTaskForm();       // Duration, urgency, date range
  Widget buildFixedTaskForm();          // Specific date/time, timezone
  Widget buildRecurrencePatternSelector(); // 8 recurrence types
}

// 2. Smart Scheduling Interface (NEEDED)
class SmartSchedulingScreen extends StatelessWidget {
  Widget buildUnscheduledTasksList();   // Tasks needing scheduling
  Widget buildSuggestedTimeSlotsView();  // AI-suggested optimal slots
  Widget buildConflictDetectionView();   // Conflict visualization
}

// 3. Calendar Integration (NEEDED)
class AdvancedCalendarView extends StatelessWidget {
  Widget buildFlexibleTasksLayer();     // Flexible tasks overlay
  Widget buildFixedTasksLayer();        // Fixed tasks with conflicts
  Widget buildRecurrenceIndicators();   // Recurring task markers
}

// 4. Task Management UI (NEEDED)
class TaskActionsScreen extends StatelessWidget {
  Widget buildPreTaskActionsList();     // Manage task preparations
  Widget buildReminderConfiguration();  // Set up reminders
  Widget buildEntityLinkingInterface(); // Link tasks to entities
}
```

### ✅ **IMPLEMENTED SCHEDULING LOGIC** (Backend Complete)
- **✅ FlexibleTask Scheduling**: Smart scheduling algorithm with urgency-based prioritization
- **✅ Recurrence Generation**: Generate task instances based on 8 recurrence pattern types
- **✅ Conflict Detection**: Real-time detection and prevention of scheduling conflicts
- **✅ Smart Suggestions**: Optimal time slot suggestions based on availability and urgency
- **✅ Timezone Support**: Global timezone handling for international scheduling
- **✅ Task-Entity Integration**: Link tasks to entities with relationship types

---

## 3. **FAMILY/SOCIAL COLLABORATION** ⚠️ **HIGHEST PRIORITY**

### Overview
The React app is designed as a family productivity system. Without family features, it's just a single-user app missing its core value proposition.

### React Reference Implementation
- **Models**: Family invitation system in user models
- **Screens**: `/react-old-vuet/old-frontend/screens/FamilyRequestScreens/`
- **Redux State**: Family management throughout the app

### Required Family Features

#### **Family Management**
```dart
@freezed
class Family with _$Family {
  const factory Family({
    required String id,
    required String name,
    required String ownerId,
    required DateTime createdAt,
    List<FamilyMember>? members,
  }) = _Family;
}

@freezed
class FamilyMember with _$FamilyMember {
  const factory FamilyMember({
    required String id,
    required String familyId,
    required String userId,
    required FamilyRole role,
    required DateTime joinedAt,
    bool isActive = true,
  }) = _FamilyMember;
}

enum FamilyRole {
  OWNER,
  ADMIN,
  MEMBER,
  VIEWER,
}
```

#### **Family Invitations**
```dart
@freezed
class FamilyInvitation with _$FamilyInvitation {
  const factory FamilyInvitation({
    required String id,
    required String familyId,
    required String invitedBy,
    required String invitedEmail,
    String? invitedUserId,
    required FamilyRole proposedRole,
    required InvitationStatus status,
    required DateTime createdAt,
    DateTime? expiresAt,
    DateTime? respondedAt,
  }) = _FamilyInvitation;
}

enum InvitationStatus {
  PENDING,
  ACCEPTED,
  DECLINED,
  EXPIRED,
}
```

### Implementation Requirements

#### **Supabase Database Schema**
```sql
-- Families table
CREATE TABLE families (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    owner_id UUID REFERENCES profiles(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Family members
CREATE TABLE family_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    family_id UUID REFERENCES families(id) ON DELETE CASCADE,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    role VARCHAR(20) NOT NULL CHECK (role IN ('OWNER', 'ADMIN', 'MEMBER', 'VIEWER')),
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    is_active BOOLEAN DEFAULT true,
    UNIQUE(family_id, user_id)
);

-- Family invitations
CREATE TABLE family_invitations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    family_id UUID REFERENCES families(id) ON DELETE CASCADE,
    invited_by UUID REFERENCES profiles(id),
    invited_email VARCHAR(255) NOT NULL,
    invited_user_id UUID REFERENCES profiles(id),
    proposed_role VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'ACCEPTED', 'DECLINED', 'EXPIRED')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE,
    responded_at TIMESTAMP WITH TIME ZONE
);
```

#### **Shared Resource Access**
- **Shared Entities**: Family members can view/edit shared entities
- **Shared Tasks**: Family task coordination and assignment
- **Shared Lists**: Family shopping and planning lists
- **Permission Control**: Role-based access to family resources

#### **UI Screens Required**
1. **Family Management Screen**: Manage family members and settings
2. **Family Invitation Screen**: Send and manage invitations
3. **Invitation Response Screen**: Accept/decline family invitations
4. **Shared Resources Screen**: Browse family-shared entities and tasks
5. **Permission Settings Screen**: Configure sharing permissions

---

## IMPLEMENTATION STRATEGY

### Phase 1: Entity System (Weeks 1-3)
1. **Week 1**: Implement base Entity model and 5 core entity types (Pet, Car, Health, Home, Social)
2. **Week 2**: Implement remaining entity types and entity-specific forms
3. **Week 3**: Entity-Task integration and entity management UI

### Phase 2: Advanced Task Scheduling UI (Weeks 4-5) ✅ **BACKEND COMPLETE**
1. **Week 4**: Implement task creation UI with scheduling type selection (Flexible vs Fixed)
2. **Week 5**: Implement smart scheduling interface, calendar views, and task management UI

### Phase 3: Family Features (Weeks 7-8)
1. **Week 7**: Implement family management and invitation system
2. **Week 8**: Implement shared resource access and permissions

### Success Criteria
- **Entity System**: All 15+ entity types working with full CRUD
- **✅ Task System Backend**: FlexibleTask, FixedTask, recurrence, actions, reminders ✅ **COMPLETE**
- **⚠️ Task System UI**: Task creation forms, smart scheduling interface, calendar views ⚠️ **NEEDED**
- **Family System**: Invitation flow, member management, shared resources

**CRITICAL**: Advanced Task Scheduling backend is complete. Focus now on:
1. **Entity System** (80% app value) - Highest priority
2. **Task Scheduling UI** (15% app value) - Leverage completed backend
3. **Family System** (5% app value) - Final integration

**Phase 2 Achievement**: Advanced task scheduling backend provides enterprise-grade capabilities with sophisticated dual scheduling, smart allocation, conflict detection, and automated actions/reminders. Ready for UI integration.
