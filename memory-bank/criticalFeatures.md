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

## 2. **ADVANCED TASK SCHEDULING** ⚠️ **HIGHEST PRIORITY**

### Overview
Current Flutter app only has basic task CRUD. React app has sophisticated scheduling with two distinct task types, complex recurrence, actions, and reminders.

### React Reference Implementation  
- **Models**: `/react-old-vuet/old-backend/core/models/tasks/base.py`
- **Screens**: `/react-old-vuet/old-frontend/screens/Forms/TaskForms/`
- **Redux State**: `/react-old-vuet/old-frontend/reduxStore/slices/tasks/`

### Required Task Types

#### **FlexibleTask** - Duration-based scheduling
```dart
@freezed
class FlexibleTask with _$FlexibleTask {
  const factory FlexibleTask({
    required String id,
    required String title,
    DateTime? earliestActionDate,
    DateTime? dueDate,
    required int duration, // in minutes
    TaskUrgency? urgency, // LOW, MEDIUM, HIGH
    List<String>? entityIds,
    // ... other fields
  }) = _FlexibleTask;
}
```

#### **FixedTask** - Time-specific scheduling  
```dart
@freezed
class FixedTask with _$FixedTask {
  const factory FixedTask({
    required String id,
    required String title,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? startTimezone,
    String? endTimezone,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? date,
    int? duration,
    List<String>? entityIds,
    // ... other fields
  }) = _FixedTask;
}
```

### Complex Recurrence System
```dart
enum RecurrenceType {
  DAILY,
  WEEKDAILY,
  WEEKLY,
  MONTHLY,
  YEARLY,
  MONTH_WEEKLY,
  YEAR_MONTH_WEEKLY,
  MONTHLY_LAST_WEEK,
}

@freezed
class Recurrence with _$Recurrence {
  const factory Recurrence({
    required String id,
    required String taskId,
    required RecurrenceType recurrence,
    required int intervalLength,
    DateTime? earliestOccurrence,
    DateTime? latestOccurrence,
  }) = _Recurrence;
}
```

### Task Actions & Reminders
```dart
@freezed
class TaskAction with _$TaskAction {
  const factory TaskAction({
    required String id,
    required String taskId,
    required Duration actionTimedelta,
    String? description,
  }) = _TaskAction;
}

@freezed
class TaskReminder with _$TaskReminder {
  const factory TaskReminder({
    required String id,
    required String taskId,
    required Duration timedelta,
    bool isEnabled = true,
  }) = _TaskReminder;
}
```

### Implementation Requirements

#### **Supabase Database Schema**
```sql
-- Enhanced tasks table
CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    task_type VARCHAR(20) NOT NULL CHECK (task_type IN ('FLEXIBLE', 'FIXED')),
    owner_id UUID REFERENCES profiles(id),
    family_id UUID REFERENCES families(id),
    
    -- FlexibleTask fields
    earliest_action_date DATE,
    due_date DATE,
    duration INTEGER,
    urgency VARCHAR(20) CHECK (urgency IN ('LOW', 'MEDIUM', 'HIGH')),
    
    -- FixedTask fields
    start_datetime TIMESTAMP WITH TIME ZONE,
    end_datetime TIMESTAMP WITH TIME ZONE,
    start_timezone VARCHAR(50),
    end_timezone VARCHAR(50),
    start_date DATE,
    end_date DATE,
    date DATE,
    
    -- Common fields
    location VARCHAR(255),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Task-Entity relationships
CREATE TABLE task_entities (
    task_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
    entity_id UUID REFERENCES entities(id) ON DELETE CASCADE,
    PRIMARY KEY (task_id, entity_id)
);

-- Recurrence table
CREATE TABLE recurrences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
    recurrence_type VARCHAR(30) NOT NULL,
    interval_length INTEGER NOT NULL DEFAULT 1,
    earliest_occurrence TIMESTAMP WITH TIME ZONE,
    latest_occurrence TIMESTAMP WITH TIME ZONE
);

-- Task actions
CREATE TABLE task_actions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
    action_timedelta INTERVAL NOT NULL,
    description TEXT
);

-- Task reminders
CREATE TABLE task_reminders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
    timedelta INTERVAL NOT NULL,
    is_enabled BOOLEAN DEFAULT true
);
```

#### **Scheduling Logic**
- **FlexibleTask Scheduling**: Algorithm to fit tasks into available time slots
- **Recurrence Generation**: Generate task instances based on recurrence rules
- **Conflict Detection**: Detect scheduling conflicts between fixed tasks
- **Smart Suggestions**: Suggest optimal scheduling for flexible tasks

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

### Phase 2: Advanced Tasks (Weeks 4-6)  
1. **Week 4**: Implement FlexibleTask and FixedTask with basic scheduling
2. **Week 5**: Implement recurrence system and task actions/reminders
3. **Week 6**: Advanced scheduling algorithms and conflict detection

### Phase 3: Family Features (Weeks 7-8)
1. **Week 7**: Implement family management and invitation system
2. **Week 8**: Implement shared resource access and permissions

### Success Criteria
- **Entity System**: All 15+ entity types working with full CRUD
- **Task System**: FlexibleTask, FixedTask, recurrence, actions, reminders
- **Family System**: Invitation flow, member management, shared resources

**CRITICAL**: Do not implement any other features until these three are complete. They represent 90% of the functionality gap. 