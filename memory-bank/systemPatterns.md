# System Patterns

## System Architecture

### Flutter Frontend + Supabase Backend
- **Frontend**: Flutter with modern Material Design 3
- **Backend**: Supabase (PostgreSQL + Auth + Edge Functions + Storage)
- **State Management**: Riverpod providers for reactive state management
- **Navigation**: Flutter Navigator 2.0 with nested routing
- **Real-time**: Supabase real-time subscriptions for live updates

### Architecture Comparison: Flutter vs React Original
| Component | React Version | Flutter Version |
|-----------|---------------|-----------------|
| Frontend | React Native + Expo | Flutter |
| State | Redux + RTK Query | Riverpod |
| Backend | Django REST API | Supabase |
| Database | PostgreSQL | Supabase PostgreSQL |
| Auth | Custom JWT | Supabase Auth |
| Real-time | WebSocket polling | Supabase real-time |
| Navigation | React Navigation | Flutter Navigator 2.0 |

## Key Technical Decisions

### Modern Flutter Architecture
- **Riverpod**: Compile-safe dependency injection and state management
- **Freezed**: Immutable data classes with code generation
- **JSON Annotation**: Automatic serialization/deserialization
- **Build Runner**: Code generation for models and providers
- **MCP Integration**: Supabase operations via Model Context Protocol

### Database Design Patterns
- **Row Level Security (RLS)**: User and family-based data isolation
- **Foreign Key Constraints**: Data integrity across all relationships
- **Database Triggers**: Automated timestamps and data consistency
- **Composite Indexes**: Optimized queries for complex relationships
- **Soft Deletes**: Data preservation with deletion flags

### Cross-Feature Integration Patterns
- **Entity Linking**: Direct ID references between models
- **Bidirectional Sync**: State updates propagate across related features
- **Event-Driven Updates**: Provider invalidation triggers UI refreshes
- **Optimistic Updates**: Immediate UI feedback with rollback capability

## Design Patterns in Use

### Repository Pattern
```
Interface Definition → Implementation → Provider Exposure
EntityRepository → SupabaseEntityRepository → entityRepositoryProvider
CategoryRepository → SupabaseCategoryRepository → categoryRepositoryProvider 
```
The `EntityRepository` handles `BaseEntityModel` CRUD operations.
The `CategoryRepository` handles `EntityCategoryModel` CRUD operations. Both use Supabase as the backend.

Provider generation for these repositories is currently facing issues with `build_runner`.

### Provider Architecture
- **FutureProvider**: Async data fetching with caching
- **StateNotifierProvider**: Complex state management with mutations
- **Provider**: Simple value providers and computed values
- **StreamProvider**: Real-time data streams from Supabase

### Model Architecture
```dart
@freezed
class EntityModel with _$EntityModel {
  const factory EntityModel({
    required String id,
    required String name,
    required EntitySubtype subtype,
    // Integration fields
    String? linkedTaskId,
    String? linkedRoutineId,
    // Metadata
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _EntityModel;
  
  factory EntityModel.fromJson(Map<String, dynamic> json) =>
      _$EntityModelFromJson(json);
}
```

## Component Relationships

### Core Feature Integration
```
Categories ←→ Entities ←→ Tasks
    ↓           ↓         ↓
  Lists ←→ Routines ←→ Timeblocks
    ↓           ↓         ↓
      LANA AI Integration
```

### Family Collaboration Layer
```
User → Family → Shared Entities/Tasks/Lists
  ↓      ↓         ↓
Permissions → Invitations → Real-time Sync
```

### Data Flow Patterns

#### Entity Management Flow
1. **Category Selection**: User selects from 15+ categories
2. **Entity Creation**: Create entity with specific subtype
3. **Integration**: Link to tasks, routines, or timeblocks
4. **Family Sharing**: Share with family members if applicable
5. **AI Enhancement**: LANA AI provides contextual suggestions

#### Task Coordination Flow
1. **Creation Source**: Lists, routines, or direct creation
2. **Entity Linking**: Associate with relevant entities
3. **Scheduling**: Assign to timeblocks or routine schedules
4. **Family Assignment**: Assign to family members
5. **Completion Tracking**: Progress updates across all systems

## Critical Implementation Paths

### Phase 1: Categories & Entity Management
```
SQL Schema (entity_categories, entities) → Category Models & Entity Models (Dart/Freezed) → Repository Interfaces (CategoryRepository, EntityRepository) → Supabase Implementations (SupabaseCategoryRepository, SupabaseEntityRepository) → Riverpod Providers (categoryRepositoryProvider, entityRepositoryProvider) → Entity CRUD → Category Navigation → Entity Cards → Family Sharing
```
Current status: SQL Schema, Dart Models, Repository Interfaces, and Supabase Implementations are largely complete. Riverpod Provider generation is in progress.

### Phase 2: Missing Critical Features
```
School Terms Management → Link List Functionality → Advanced Task Completion → Reference Management
```

#### School Terms Management
```
SchoolTerm Models → SchoolTerm Repository → Riverpod Providers → SchoolTermsScreen UI → Academic Planning Features → Calendar Integration
```
Status: Required for feature parity with React app. Not yet implemented.

#### Link List Functionality
```
LinkList Models → LinkList Repository → Riverpod Providers → LinkListScreen UI → Anniversary/Holiday Handlers → Setup Guides
```
Status: Required for feature parity with React app. Not yet implemented.

#### Advanced Task Completion
```
TaskCompletion Components → Type-Specific Handlers → Task Rescheduling → Completion Workflows → UI Integration
```
Status: Basic task completion exists, but advanced features from React app are missing.

#### Reference Management
```
Reference Models → Reference Repository → Riverpod Providers → AllReferencesScreen → Reference Organization → Entity Linking
```
Status: Basic reference model exists, but comprehensive management is missing.

### Phase 3: Family Features
```
Family Models → Invitation System → Permission Management → Shared Resources → Real-time Sync
```

### Phase 4: Advanced Calendar
```
Calendar Models → External Integration → Event Management → iCal Support → Unified View
```

### Phase 5: Advanced Data Structure Features
```
Complex Recurrence Models → Task Actions & Reminders → Entity Form Specialization → Contact Management → Help System
```
Status: These advanced features from the React app need to be implemented after the critical features.

## Code Quality Patterns

### Established Standards
- **Dart Conventions**: Strict lowerCamelCase naming
- **Import Management**: Organized imports with unused cleanup
- **Error Handling**: Comprehensive try-catch with user-friendly messages
- **Retry Logic**: Exponential backoff for network operations
- **Code Generation**: Reliable Freezed/JSON generation workflow

### Testing Patterns
- **Unit Tests**: Model and provider testing
- **Widget Tests**: UI component testing
- **Integration Tests**: End-to-end feature testing
- **Performance Tests**: Load and stress testing

### Build and Deployment
- **Environment Configuration**: Development, staging, production
- **Code Analysis**: Flutter analysis with zero warnings goal
- **Automated Testing**: CI/CD pipeline integration
- **Performance Monitoring**: Real-time performance tracking

## Integration with Original React Codebase

### Feature Mapping Strategy
- **Direct Translation**: Core functionality preserved exactly
- **Enhancement**: Improved UX and cross-feature integration
- **AI Augmentation**: LANA AI adds intelligence to existing features
- **Modern Patterns**: Flutter best practices applied throughout

### Data Migration Considerations
- **Schema Compatibility**: Supabase schema matches Django models
- **Data Preservation**: All original data structures supported
- **Feature Parity**: Every React feature has Flutter equivalent
- **Enhancement Opportunities**: Additional features where beneficial

The React codebase serves as the definitive functional specification, while Flutter implementation adds modern architecture and AI capabilities.
