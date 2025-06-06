# System Patterns - Vuet Flutter Migration
*Last Updated: January 7, 2025*

## Architectural Patterns

### Polymorphic Entity System
**Pattern**: Base entity with type-specific extensions
**Implementation**: Supabase tables with inheritance-like structure

```sql
-- Base entity table
entities (id, name, description, category_id, entity_type, created_at, updated_at)

-- Type-specific tables
cars (entity_id, make, model, registration, mot_due_date, insurance_due_date)
birthdays (entity_id, date_of_birth, known_year)
pets (entity_id, species, vaccination_due_date)
```

**Flutter Pattern**:
```dart
@freezed
abstract class Entity with _$Entity {
  const factory Entity.car({required Car carData, ...baseFields}) = CarEntity;
  const factory Entity.birthday({required Birthday birthdayData, ...baseFields}) = BirthdayEntity;
  const factory Entity.pet({required Pet petData, ...baseFields}) = PetEntity;
}
```

### Category-Driven Architecture
**Pattern**: Schema-driven category system with dynamic UI generation
**Backend**: Categories table drives available entity types and UI configuration
**Frontend**: Dynamic widget generation based on category configuration

```dart
class CategoryConfig {
  final String name;
  final IconData icon;
  final Color primaryColor;
  final List<String> entityTypes;
  final Map<String, dynamic> preferences;
  final List<AutoTaskRule> autoRules;
}
```

### Automatic Task Generation
**Pattern**: Event-driven task creation based on entity lifecycle
**Triggers**: Entity creation, update, date field changes
**Rules Engine**: Configurable rules per entity type

```dart
abstract class AutoTaskRule {
  bool shouldTrigger(Entity entity, EntityChangeType changeType);
  List<Task> generateTasks(Entity entity);
}

class BirthdayTaskRule extends AutoTaskRule {
  @override
  bool shouldTrigger(Entity entity, EntityChangeType changeType) =>
      entity is BirthdayEntity && changeType == EntityChangeType.created;
      
  @override
  List<Task> generateTasks(Entity entity) => [
    Task.recurring(
      title: '🎂 ${entity.name}',
      schedule: RecurrencePattern.yearly(entity.dateOfBirth),
    )
  ];
}
```

## State Management Patterns

### Riverpod Provider Architecture
**Pattern**: Feature-based provider organization with clear dependencies

```dart
// Repository layer
final entityRepositoryProvider = Provider<EntityRepository>((ref) => 
    EntityRepository(ref.watch(supabaseClientProvider)));

// State layer
final entitiesProvider = AsyncNotifierProvider<EntitiesNotifier, List<Entity>>(
    () => EntitiesNotifier());

// UI layer
final entityFormProvider = StateNotifierProvider<EntityFormNotifier, EntityFormState>(
    (ref) => EntityFormNotifier(ref.watch(entityRepositoryProvider)));
```

### Family Sharing State Pattern
**Pattern**: Hierarchical state management for family permissions

```dart
class FamilyState {
  final Family family;
  final Map<String, FamilyMember> members;
  final Map<String, PermissionLevel> permissions;
  final List<Entity> sharedEntities;
}

enum PermissionLevel { view, edit, admin }
```

## UI/UX Patterns

### Modern Palette Component System
**Pattern**: Consistent color usage across all components

```dart
class VuetColors {
  static const darkJungleGreen = Color(0xFF202827);  // Headers, primary text
  static const mediumTurquoise = Color(0xFF55C6D6);  // Accents, links
  static const orange = Color(0xFFE49F2F);           // Primary actions
  static const steel = Color(0xFF798D8E);            // Secondary text
  static const white = Color(0xFFFFFFFF);            // Backgrounds
}

class VuetTheme {
  static ThemeData get theme => ThemeData(
    colorScheme: ColorScheme.light(
      primary: VuetColors.orange,
      secondary: VuetColors.mediumTurquoise,
      surface: VuetColors.white,
      onSurface: VuetColors.darkJungleGreen,
    ),
  );
}
```

### Reusable Widget Library Pattern
**Pattern**: Consistent UI components with Modern Palette integration

```dart
// Base header component
class VuetHeader extends StatelessWidget implements PreferredSizeWidget {
  const VuetHeader(this.title, {super.key});
  final String title;
  
  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: VuetColors.darkJungleGreen,
    title: Text(title, style: TextStyle(color: VuetColors.white)),
  );
}

// Form field component
class VuetTextField extends StatelessWidget {
  const VuetTextField({
    required this.controller,
    required this.label,
    this.validator,
    super.key,
  });
  
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: VuetColors.steel),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: VuetColors.mediumTurquoise, width: 2),
      ),
    ),
    validator: validator,
  );
}
```

### Navigation Pattern
**Pattern**: Type-safe routing with GoRouter

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/categories',
      builder: (_, __) => const CategoryGrid(),
      routes: [
        GoRoute(
          path: ':categoryId',
          builder: (_, state) => CategoryDetailPage(
            categoryId: int.parse(state.pathParameters['categoryId']!),
          ),
          routes: [
            GoRoute(
              path: 'entities/:entityId',
              builder: (_, state) => EntityDetailPage(
                entityId: int.parse(state.pathParameters['entityId']!),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
```

## Data Patterns

### Repository Pattern
**Pattern**: Clean separation between data access and business logic

```dart
abstract class EntityRepository {
  Future<List<Entity>> getEntitiesByCategory(int categoryId);
  Future<Entity> getEntity(int entityId);
  Future<Entity> createEntity(Entity entity);
  Future<Entity> updateEntity(Entity entity);
  Future<void> deleteEntity(int entityId);
}

class SupabaseEntityRepository implements EntityRepository {
  final SupabaseClient _client;
  
  @override
  Future<List<Entity>> getEntitiesByCategory(int categoryId) async {
    final response = await _client
        .from('entities')
        .select('*, cars(*), birthdays(*), pets(*)')
        .eq('category_id', categoryId);
    
    return response.map((json) => Entity.fromJson(json)).toList();
  }
}
```

### Caching Pattern
**Pattern**: Multi-layer caching for performance

```dart
class CachedEntityRepository implements EntityRepository {
  final EntityRepository _repository;
  final Map<int, Entity> _cache = {};
  
  @override
  Future<Entity> getEntity(int entityId) async {
    if (_cache.containsKey(entityId)) {
      return _cache[entityId]!;
    }
    
    final entity = await _repository.getEntity(entityId);
    _cache[entityId] = entity;
    return entity;
  }
}
```

## Error Handling Patterns

### Result Pattern
**Pattern**: Explicit error handling without exceptions

```dart
@freezed
class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(String error) = Failure<T>;
}

class EntityService {
  Future<Result<Entity>> createEntity(Entity entity) async {
    try {
      final created = await _repository.createEntity(entity);
      return Result.success(created);
    } catch (e) {
      return Result.failure('Failed to create entity: $e');
    }
  }
}
```

### Error Boundary Pattern
**Pattern**: Graceful error handling in UI

```dart
class ErrorBoundary extends StatelessWidget {
  const ErrorBoundary({
    required this.child,
    this.onError,
    super.key,
  });
  
  final Widget child;
  final void Function(Object error)? onError;
  
  @override
  Widget build(BuildContext context) {
    return child; // Simplified - actual implementation would catch errors
  }
}
```

## Testing Patterns

### Repository Testing Pattern
**Pattern**: Mock repositories for unit testing

```dart
class MockEntityRepository extends Mock implements EntityRepository {}

void main() {
  group('EntityService', () {
    late MockEntityRepository mockRepository;
    late EntityService service;
    
    setUp(() {
      mockRepository = MockEntityRepository();
      service = EntityService(mockRepository);
    });
    
    test('should create entity successfully', () async {
      // Arrange
      final entity = Entity.car(carData: Car(...));
      when(() => mockRepository.createEntity(entity))
          .thenAnswer((_) async => entity.copyWith(id: 1));
      
      // Act
      final result = await service.createEntity(entity);
      
      // Assert
      expect(result, isA<Success<Entity>>());
    });
  });
}
```

### Widget Testing Pattern
**Pattern**: Component testing with providers

```dart
Widget createTestWidget(Widget child) {
  return ProviderScope(
    overrides: [
      entityRepositoryProvider.overrideWithValue(MockEntityRepository()),
    ],
    child: MaterialApp(home: child),
  );
}

void main() {
  testWidgets('EntityForm should validate required fields', (tester) async {
    await tester.pumpWidget(createTestWidget(const EntityForm()));
    
    await tester.tap(find.text('Save'));
    await tester.pump();
    
    expect(find.text('Required'), findsOneWidget);
  });
}
```

## Performance Patterns

### Lazy Loading Pattern
**Pattern**: Load data on demand to improve performance

```dart
class LazyEntityList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final entity = ref.watch(entityProvider(index));
        return entity.when(
          data: (entity) => EntityTile(entity),
          loading: () => const EntityTileSkeleton(),
          error: (error, _) => EntityTileError(error),
        );
      },
    );
  }
}
```

### Pagination Pattern
**Pattern**: Efficient data loading for large datasets

```dart
class PaginatedEntityNotifier extends AsyncNotifier<List<Entity>> {
  int _page = 0;
  static const _pageSize = 20;
  
  @override
  Future<List<Entity>> build() async {
    return _loadPage(0);
  }
  
  Future<void> loadMore() async {
    final current = state.value ?? [];
    final nextPage = await _loadPage(_page + 1);
    state = AsyncValue.data([...current, ...nextPage]);
    _page++;
  }
  
  Future<List<Entity>> _loadPage(int page) async {
    return ref.read(entityRepositoryProvider)
        .getEntities(offset: page * _pageSize, limit: _pageSize);
  }
}
```

## Security Patterns

### Row Level Security (RLS) Pattern
**Pattern**: Database-level security for multi-tenant data

```sql
-- Enable RLS on entities table
ALTER TABLE entities ENABLE ROW LEVEL SECURITY;

-- Policy: Users can only see entities they own or are shared with
CREATE POLICY "Users can view own and shared entities" ON entities
  FOR SELECT USING (
    user_id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM family_members fm
      JOIN families f ON fm.family_id = f.id
      WHERE f.id = entities.family_id AND fm.user_id = auth.uid()
    )
  );
```

### Permission Checking Pattern
**Pattern**: Client-side permission validation

```dart
class PermissionService {
  bool canEdit(Entity entity, User user) {
    if (entity.userId == user.id) return true;
    
    final familyMember = user.familyMemberships
        .where((m) => m.familyId == entity.familyId)
        .firstOrNull;
    
    return familyMember?.permission.index >= PermissionLevel.edit.index;
  }
}
```

---

*These patterns ensure consistency, maintainability, and scalability across the Vuet Flutter application.*
