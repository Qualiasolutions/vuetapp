# Tech Context

## Technologies Used

### Frontend Stack
- **Flutter**: Cross-platform UI framework (latest stable)
- **Dart**: Programming language with null safety
- **Material Design 3**: Modern UI components and theming
- **Riverpod**: State management and dependency injection
- **Freezed**: Immutable data classes with code generation
- **JSON Annotation**: Automatic serialization/deserialization

### Backend Stack
- **Supabase**: Backend-as-a-Service platform
  - PostgreSQL database with Row Level Security
  - Authentication and user management
  - Edge Functions for serverless computing
  - Real-time subscriptions
  - Storage for file management
- **MCP (Model Context Protocol)**: Supabase integration via MCP servers

### Development Tools
- **Build Runner**: Code generation for Freezed and JSON
- **Flutter Analyzer**: Static code analysis
- **VS Code**: Primary development environment
- **Git**: Version control with conventional commits

### Comparison with React Original
| Technology | React Version | Flutter Version |
|------------|---------------|-----------------|
| Frontend | React Native + Expo | Flutter |
| Language | TypeScript/JavaScript | Dart |
| State Management | Redux + RTK Query | Riverpod |
| Backend | Django REST API | Supabase |
| Database | PostgreSQL | Supabase PostgreSQL |
| Authentication | Custom JWT | Supabase Auth |
| Real-time | Polling/WebSocket | Supabase real-time |
| Deployment | Expo + Custom server | Flutter Web/Mobile + Supabase |

## Development Setup

### Environment Requirements
- **Flutter SDK**: Latest stable channel
- **Dart SDK**: Included with Flutter
- **VS Code**: With Flutter and Dart extensions
- **Chrome**: For web development and testing
- **Android Studio**: For Android development (optional)
- **Xcode**: For iOS development (macOS only)

### Project Configuration
- **Environment Files**: `.env.development`, `.env.production`
- **Supabase Configuration**: `lib/config/supabase_config.dart`
- **Build Configuration**: `pubspec.yaml` with all dependencies
- **Analysis Options**: `analysis_options.yaml` for code quality

### MCP Server Setup
- **Supabase MCP**: `@supabase/mcp-server-supabase` for database operations
- **Filesystem MCP**: `@modelcontextprotocol/server-filesystem` for file operations
- **Context7 MCP**: `@upstash/context7-mcp` for documentation access

## Technical Constraints

### Flutter Constraints
- **Platform Compatibility**: Web, iOS, Android, Desktop
- **Performance**: 60fps UI with efficient state management
- **Memory Management**: Proper disposal of resources and streams
- **Code Quality**: Zero Flutter analysis warnings target

### Supabase Constraints
- **Row Level Security**: All data access must respect RLS policies
- **Real-time Limits**: Connection and message rate limits
- **Edge Function Limits**: Execution time and memory constraints
- **Storage Limits**: File size and bandwidth considerations

### Integration Constraints
- **Cross-Feature Consistency**: All features must integrate seamlessly
- **Family Collaboration**: Multi-user access with proper permissions
- **Real-time Updates**: Live synchronization across all clients
- **AI Integration**: LANA AI must work with all data types

## Dependencies

### Core Dependencies (pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3
  
  # Data Models
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  
  # Backend Integration
  supabase_flutter: ^2.0.0
  
  # UI Components
  material_color_utilities: ^0.8.0
  
  # Utilities
  uuid: ^4.2.1
  intl: ^0.19.0

dev_dependencies:
  # Code Generation
  build_runner: ^2.4.7
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  riverpod_generator: ^2.3.9
  
  # Testing
  flutter_test:
    sdk: flutter
  mockito: ^5.4.2
  
  # Code Quality
  flutter_lints: ^3.0.1
```

### React Version Dependencies Comparison
The React version used 50+ npm packages including:
- React Native + Expo ecosystem
- Redux + RTK Query for state
- React Navigation for routing
- Multiple UI component libraries
- Custom authentication system
- Django backend dependencies

The Flutter version consolidates this into fewer, more integrated dependencies with better type safety and performance.

## Tool Usage Patterns

### Development Workflow
1. **Code Generation**: `dart run build_runner build --delete-conflicting-outputs`
2. **Analysis**: `flutter analyze` for code quality checks
3. **Testing**: `flutter test` for unit and widget tests
4. **Web Development**: `flutter run -d chrome --web-port 8080`
5. **Hot Reload**: Instant UI updates during development

### MCP Integration Patterns
- **Database Operations**: Use Supabase MCP for all CRUD operations
- **File Management**: Use Filesystem MCP for local file operations
- **Documentation**: Use Context7 MCP for accessing library documentation
- **Error Handling**: Comprehensive error handling for all MCP operations

### Build and Deployment
- **Development**: `flutter run` with hot reload
- **Web Build**: `flutter build web --release`
- **Mobile Build**: `flutter build apk/ios --release`
- **Analysis**: Continuous code quality monitoring

## Performance Considerations

### Flutter Optimizations
- **Widget Rebuilds**: Efficient provider usage to minimize rebuilds
- **Memory Management**: Proper disposal of controllers and streams
- **Image Optimization**: Cached network images and asset optimization
- **Bundle Size**: Tree shaking and code splitting for web

### Supabase Optimizations
- **Query Optimization**: Efficient database queries with proper indexing
- **Real-time Efficiency**: Selective subscriptions to minimize bandwidth
- **Caching Strategy**: Provider-level caching with proper invalidation
- **Connection Pooling**: Efficient database connection management

## Migration Strategy from React

### Data Migration
- **Schema Mapping**: Django models → Supabase tables
- **Data Preservation**: All existing data structures maintained
- **Feature Parity**: Every React feature implemented in Flutter
- **Enhancement Opportunities**: Additional features where beneficial

### Code Migration Patterns
- **Component Translation**: React components → Flutter widgets
- **State Migration**: Redux → Riverpod providers
- **API Migration**: Django REST → Supabase operations
- **Navigation Migration**: React Navigation → Flutter routing

The React codebase serves as the definitive functional specification for all missing features and implementation details.
