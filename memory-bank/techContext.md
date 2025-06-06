# Technical Context - Vuet Flutter Migration
*Last Updated: January 7, 2025*

## Technology Stack Overview

### Frontend Stack
- **Framework**: Flutter 3.16+ (Dart 3.2+)
- **State Management**: Riverpod 2.4+
- **Navigation**: GoRouter 13.0+
- **HTTP Client**: Dio 5.3+
- **Code Generation**: Freezed, JSON Annotation, Build Runner
- **UI Components**: Material 3 with custom Modern Palette theme
- **Platform Support**: iOS, Android, Web (Progressive Web App)

### Backend Stack
- **Database**: Supabase PostgreSQL with Row Level Security (RLS)
- **Authentication**: Supabase Auth (email, OAuth providers)
- **Storage**: Supabase Storage for files and images
- **Realtime**: Supabase Realtime for live updates
- **Edge Functions**: Supabase Edge Functions (Deno/TypeScript)
- **API**: RESTful API with automatic OpenAPI generation

### Development Tools
- **IDE**: VS Code with Flutter/Dart extensions
- **Version Control**: Git with GitHub
- **CI/CD**: GitHub Actions for automated testing and deployment
- **Testing**: Flutter Test, Integration Tests, Widget Tests
- **Code Quality**: Dart Analyzer, Flutter Lints
- **Documentation**: Dart Doc, README files

## Architecture Overview

### Clean Architecture Layers
```
┌─────────────────────────────────────┐
│              UI Layer               │
│  (Screens, Widgets, State)          │
├─────────────────────────────────────┤
│           Domain Layer              │
│  (Entities, Use Cases, Interfaces)  │
├─────────────────────────────────────┤
│            Data Layer               │
│  (Repositories, Data Sources, APIs) │
└─────────────────────────────────────┘
```

### Project Structure
```
lib/
├── main.dart                    # App entry point
├── config/                      # Configuration files
│   ├── theme_config.dart       # Modern Palette theme
│   ├── supabase_config.dart    # Supabase client setup
│   └── app_categories.dart     # Category definitions
├── models/                      # Data models (Freezed)
│   ├── entity_model.dart       # Base entity model
│   ├── category_model.dart     # Category model
│   └── task_model.dart         # Task model
├── repositories/                # Data access layer
│   ├── entity_repository.dart  # Entity CRUD operations
│   ├── task_repository.dart    # Task management
│   └── family_repository.dart  # Family sharing
├── providers/                   # Riverpod providers
│   ├── entity_providers.dart   # Entity state management
│   ├── auth_providers.dart     # Authentication state
│   └── family_providers.dart   # Family sharing state
├── ui/                         # User interface
│   ├── shared/                 # Reusable components
│   │   ├── vuet_header.dart   # Modern header component
│   │   ├── vuet_text_field.dart # Modern text field
│   │   └── vuet_date_picker.dart # Modern date picker
│   ├── screens/                # Main screens
│   │   ├── categories/         # Category management
│   │   ├── entities/           # Entity CRUD screens
│   │   └── tasks/              # Task management
│   └── widgets/                # Screen-specific widgets
├── services/                   # Business logic services
│   ├── auto_task_service.dart  # Automatic task generation
│   ├── notification_service.dart # Push notifications
│   └── sync_service.dart       # Data synchronization
└── utils/                      # Utility functions
    ├── validators.dart         # Form validation
    ├── date_utils.dart         # Date formatting
    └── constants.dart          # App constants
```

## Database Schema

### Core Tables
```sql
-- Categories (14 total)
categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  group_id INTEGER,
  description TEXT,
  icon VARCHAR(50),
  color VARCHAR(7),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Base entities table
entities (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category_id INTEGER REFERENCES categories(id),
  entity_type VARCHAR(50) NOT NULL,
  user_id UUID REFERENCES auth.users(id),
  family_id INTEGER REFERENCES families(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Type-specific entity tables
cars (
  entity_id INTEGER PRIMARY KEY REFERENCES entities(id),
  make VARCHAR(100),
  model VARCHAR(100),
  registration VARCHAR(20),
  mot_due_date DATE,
  insurance_due_date DATE,
  service_due_date DATE,
  tax_due_date DATE,
  warranty_due_date DATE
);

birthdays (
  entity_id INTEGER PRIMARY KEY REFERENCES entities(id),
  date_of_birth DATE NOT NULL,
  known_year BOOLEAN DEFAULT true,
  relationship VARCHAR(50)
);

pets (
  entity_id INTEGER PRIMARY KEY REFERENCES entities(id),
  species VARCHAR(50),
  breed VARCHAR(100),
  date_of_birth DATE,
  vaccination_due_date DATE,
  microchip_number VARCHAR(50)
);

-- Tasks system
tasks (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  due_date DATE,
  due_time TIME,
  completed BOOLEAN DEFAULT false,
  entity_id INTEGER REFERENCES entities(id),
  user_id UUID REFERENCES auth.users(id),
  family_id INTEGER REFERENCES families(id),
  recurrence_pattern JSONB,
  auto_generated BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Family sharing
families (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMP DEFAULT NOW()
);

family_members (
  id SERIAL PRIMARY KEY,
  family_id INTEGER REFERENCES families(id),
  user_id UUID REFERENCES auth.users(id),
  permission_level VARCHAR(20) DEFAULT 'view',
  joined_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(family_id, user_id)
);
```

### Row Level Security (RLS) Policies
```sql
-- Entities: Users can only access their own or family-shared entities
CREATE POLICY "Users can view own and shared entities" ON entities
  FOR SELECT USING (
    user_id = auth.uid() OR
    family_id IN (
      SELECT family_id FROM family_members 
      WHERE user_id = auth.uid()
    )
  );

-- Tasks: Similar policy for tasks
CREATE POLICY "Users can view own and shared tasks" ON tasks
  FOR SELECT USING (
    user_id = auth.uid() OR
    family_id IN (
      SELECT family_id FROM family_members 
      WHERE user_id = auth.uid()
    )
  );
```

## State Management Architecture

### Riverpod Provider Hierarchy
```dart
// Core providers
final supabaseClientProvider = Provider<SupabaseClient>((ref) => 
    Supabase.instance.client);

final authProvider = StreamProvider<User?>((ref) => 
    ref.watch(supabaseClientProvider).auth.onAuthStateChange
        .map((data) => data.session?.user));

// Repository providers
final entityRepositoryProvider = Provider<EntityRepository>((ref) => 
    SupabaseEntityRepository(ref.watch(supabaseClientProvider)));

final taskRepositoryProvider = Provider<TaskRepository>((ref) => 
    SupabaseTaskRepository(ref.watch(supabaseClientProvider)));

// State providers
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repository = ref.watch(entityRepositoryProvider);
  return repository.getCategories();
});

final entitiesProvider = FutureProvider.family<List<Entity>, int>(
    (ref, categoryId) async {
  final repository = ref.watch(entityRepositoryProvider);
  return repository.getEntitiesByCategory(categoryId);
});

// Form providers
final entityFormProvider = StateNotifierProvider.family<
    EntityFormNotifier, EntityFormState, String>((ref, entityType) => 
    EntityFormNotifier(entityType, ref.watch(entityRepositoryProvider)));
```

### Auto-Task Generation System
```dart
class AutoTaskEngine {
  final TaskRepository _taskRepository;
  final List<AutoTaskRule> _rules;
  
  Future<void> processEntityChange(Entity entity, ChangeType changeType) async {
    for (final rule in _rules) {
      if (rule.shouldTrigger(entity, changeType)) {
        final tasks = rule.generateTasks(entity);
        for (final task in tasks) {
          await _taskRepository.createTask(task);
        }
      }
    }
  }
}

// Example rule for birthday tasks
class BirthdayTaskRule implements AutoTaskRule {
  @override
  bool shouldTrigger(Entity entity, ChangeType changeType) {
    return entity.entityType == 'birthday' && 
           changeType == ChangeType.created;
  }
  
  @override
  List<Task> generateTasks(Entity entity) {
    final birthday = entity as BirthdayEntity;
    return [
      Task(
        title: '🎂 ${birthday.name}\'s Birthday',
        dueDate: birthday.dateOfBirth,
        recurrencePattern: RecurrencePattern.yearly(),
        autoGenerated: true,
        entityId: entity.id,
      ),
    ];
  }
}
```

## Modern Palette Implementation

### Theme Configuration
```dart
class VuetTheme {
  // Modern Palette Colors
  static const Color darkJungleGreen = Color(0xFF202827);
  static const Color mediumTurquoise = Color(0xFF55C6D6);
  static const Color orange = Color(0xFFE49F2F);
  static const Color steel = Color(0xFF798D8E);
  static const Color white = Color(0xFFFFFFFF);
  
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: orange,
      onPrimary: white,
      secondary: mediumTurquoise,
      onSecondary: darkJungleGreen,
      surface: white,
      onSurface: darkJungleGreen,
      background: white,
      onBackground: darkJungleGreen,
      outline: steel,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkJungleGreen,
      foregroundColor: white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: orange,
        foregroundColor: white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: steel),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: steel),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: mediumTurquoise, width: 2),
      ),
    ),
  );
}
```

### Component Library
```dart
// Modern header component
class VuetHeader extends StatelessWidget implements PreferredSizeWidget {
  const VuetHeader({
    required this.title,
    this.actions,
    super.key,
  });
  
  final String title;
  final List<Widget>? actions;
  
  @override
  Widget build(BuildContext context) => AppBar(
    title: Text(title),
    actions: actions,
  );
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Modern text field
class VuetTextField extends StatelessWidget {
  const VuetTextField({
    required this.controller,
    required this.labelText,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    super.key,
  });
  
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    decoration: InputDecoration(labelText: labelText),
    validator: validator,
    keyboardType: keyboardType,
    obscureText: obscureText,
  );
}

// Modern date picker
class VuetDatePicker extends StatefulWidget {
  const VuetDatePicker({
    required this.controller,
    required this.labelText,
    this.validator,
    super.key,
  });
  
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  
  @override
  State<VuetDatePicker> createState() => _VuetDatePickerState();
}
```

## API Integration

### Supabase Client Configuration
```dart
class SupabaseConfig {
  static const String url = String.fromEnvironment('SUPABASE_URL');
  static const String anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }
}
```

### Repository Implementation
```dart
class SupabaseEntityRepository implements EntityRepository {
  final SupabaseClient _client;
  
  SupabaseEntityRepository(this._client);
  
  @override
  Future<List<Entity>> getEntitiesByCategory(int categoryId) async {
    final response = await _client
        .from('entities')
        .select('''
          *,
          cars(*),
          birthdays(*),
          pets(*)
        ''')
        .eq('category_id', categoryId);
    
    return response.map((json) => Entity.fromJson(json)).toList();
  }
  
  @override
  Future<Entity> createEntity(Entity entity) async {
    // Insert into base entities table
    final entityResponse = await _client
        .from('entities')
        .insert(entity.toBaseJson())
        .select()
        .single();
    
    // Insert into type-specific table
    await _insertTypeSpecificData(entityResponse['id'], entity);
    
    return await getEntity(entityResponse['id']);
  }
}
```

## Testing Strategy

### Unit Tests
```dart
// Repository tests
void main() {
  group('EntityRepository', () {
    late MockSupabaseClient mockClient;
    late SupabaseEntityRepository repository;
    
    setUp(() {
      mockClient = MockSupabaseClient();
      repository = SupabaseEntityRepository(mockClient);
    });
    
    test('should fetch entities by category', () async {
      // Arrange
      when(() => mockClient.from('entities'))
          .thenReturn(mockQueryBuilder);
      when(() => mockQueryBuilder.select(any()))
          .thenReturn(mockQueryBuilder);
      when(() => mockQueryBuilder.eq('category_id', 1))
          .thenAnswer((_) async => mockEntityData);
      
      // Act
      final result = await repository.getEntitiesByCategory(1);
      
      // Assert
      expect(result, isA<List<Entity>>());
      expect(result.length, equals(2));
    });
  });
}
```

### Widget Tests
```dart
void main() {
  testWidgets('EntityForm should validate required fields', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: EntityForm(entityType: 'car'),
        ),
      ),
    );
    
    // Try to submit without filling required fields
    await tester.tap(find.text('Save'));
    await tester.pump();
    
    // Should show validation errors
    expect(find.text('This field is required'), findsWidgets);
  });
}
```

### Integration Tests
```dart
void main() {
  group('Entity Management Flow', () {
    testWidgets('should create and display new entity', (tester) async {
      await tester.pumpWidget(MyApp());
      
      // Navigate to category
      await tester.tap(find.text('Transport'));
      await tester.pumpAndSettle();
      
      // Add new car
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      
      // Fill form
      await tester.enterText(find.byKey(Key('make_field')), 'Toyota');
      await tester.enterText(find.byKey(Key('model_field')), 'Camry');
      
      // Submit
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      
      // Verify entity appears in list
      expect(find.text('Toyota Camry'), findsOneWidget);
    });
  });
}
```

## Performance Considerations

### Optimization Strategies
1. **Lazy Loading**: Load entities on demand using pagination
2. **Caching**: Implement multi-layer caching with Riverpod
3. **Image Optimization**: Use cached network images with placeholders
4. **Database Indexing**: Proper indexes on frequently queried columns
5. **Bundle Size**: Tree-shake unused dependencies

### Monitoring
- **Performance Metrics**: Track app startup time, screen load times
- **Error Tracking**: Implement crash reporting and error logging
- **User Analytics**: Track user engagement and feature usage
- **Database Performance**: Monitor query performance and optimization

## Security Implementation

### Authentication Flow
```dart
class AuthService {
  final SupabaseClient _client;
  
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  Stream<AuthState> get authStateChanges => 
      _client.auth.onAuthStateChange;
}
```

### Data Validation
```dart
class EntityValidator {
  static String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }
  
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) return null;
    
    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Please enter a valid date (YYYY-MM-DD)';
    }
  }
}
```

## Deployment Pipeline

### Build Configuration
```yaml
# pubspec.yaml
name: vuet_flutter
description: Vuet life management application
version: 1.0.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'
  flutter: ">=3.16.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.9
  go_router: ^13.0.0
  supabase_flutter: ^2.0.0
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.7
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  flutter_lints: ^3.0.0
```

### CI/CD Pipeline
```yaml
# .github/workflows/flutter.yml
name: Flutter CI/CD

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      
  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build apk --release
      - run: flutter build web --release
```

---

*This technical context provides the foundation for all implementation decisions and architectural choices in the Vuet Flutter migration.*
