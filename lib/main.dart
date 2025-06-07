import 'package:flutter/foundation.dart'
    show kReleaseMode; // For environment check
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:provider/provider.dart'
    as legacy_provider; // Keep legacy provider for now
import 'package:vuet_app/config/supabase_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vuet_app/providers/auth_providers.dart'; // Import auth providers
import 'package:vuet_app/services/notification_service.dart'; // Still needed for type, but instance from Riverpod
import 'package:vuet_app/services/task_category_service.dart';
import 'package:vuet_app/services/performance_service.dart'; // Performance monitoring
import 'package:vuet_app/src/features/tasks/presentation/providers/task_list_provider.dart'; // Added
import 'package:vuet_app/ui/theme/app_theme.dart';
import 'package:vuet_app/ui/screens/tasks/task_list_screen.dart';
import 'package:vuet_app/ui/screens/tasks/create_task_screen.dart';
import 'package:vuet_app/ui/screens/tasks/task_detail_screen.dart';
import 'package:vuet_app/ui/screens/auth/auth_wrapper.dart';
import 'package:vuet_app/ui/screens/auth/update_password_screen.dart';
import 'package:vuet_app/ui/screens/notifications/notifications_screen.dart';
import 'package:vuet_app/ui/screens/home/modernized_home_screen.dart'; // Updated for modernized version
import 'package:vuet_app/ui/screens/categories/categories_screen.dart'; // Updated to use categories screen with toggle
import 'package:vuet_app/widgets/notification_badge.dart';
import 'package:vuet_app/utils/deep_link_handler.dart';
import 'package:vuet_app/ui/screens/lists/redesigned_lists_screen.dart'; // Updated with new redesigned version
import 'package:vuet_app/ui/screens/lana_chat_screen.dart'; // Updated to new LANA chat screen
import 'package:vuet_app/ui/screens/account/my_account_screen.dart'; // My Account screen
import 'package:vuet_app/ui/screens/routines/routines_screen.dart'; // Added RoutinesScreen
import 'package:vuet_app/ui/navigation/timeblock_navigator.dart'; // Added TimeblockNavigator
import 'package:vuet_app/ui/screens/family/family_screen.dart'; // Added FamilyScreen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables and initialize services
  try {
    // For web builds, we rely on env.js for environment detection
    // For mobile builds, we check for a --dart-define flag or default to development
    String envFileName;
    bool isProduction;

    // Check for production flag via --dart-define or default to development
    const productionFlag =
        String.fromEnvironment('FLUTTER_ENV', defaultValue: 'development');

    if (productionFlag == 'production' || kReleaseMode) {
      envFileName = '.env.production';
      isProduction = true;
      debugPrint('🚀 Running in PRODUCTION mode');
    } else {
      envFileName = '.env.development';
      isProduction = false;
      debugPrint('🔧 Running in DEVELOPMENT mode');
    }

    debugPrint('Loading environment from: $envFileName');
    await dotenv.load(fileName: envFileName);

    // Initialize Supabase for auth and data storage
    await SupabaseConfig.initialize(isProduction: isProduction);

    // Initialize performance monitoring service (using Supabase)
    await PerformanceService.initialize();

    // Log app startup
    await PerformanceService.logAppOpen();
    await PerformanceService.logMemoryUsage('app_startup');

    debugPrint('✅ All services initialized successfully');

    // Wrap with ProviderScope for Riverpod
    runApp(const ProviderScope(child: VuetApp()));
  } catch (error, stackTrace) {
    debugPrint('❌ Error during initialization: $error');
    debugPrint('Stack trace: $stackTrace');
    // Run the app with minimal configuration for development
    runApp(const VuetAppFallback());
  }
}

class VuetApp extends ConsumerStatefulWidget {
  const VuetApp({super.key});

  @override
  ConsumerState<VuetApp> createState() => _VuetAppState();
}

class _VuetAppState extends ConsumerState<VuetApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  bool _isDarkMode = false; // Added for Dark Mode toggle

  @override
  void initState() {
    super.initState();
    // Initialize deep link handler after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = ref.read(authServiceProvider);
      // Ensure context is still valid if this callback is delayed
      if (_navigatorKey.currentContext != null &&
          _navigatorKey.currentContext!.mounted) {
        DeepLinkHandler.initialize(_navigatorKey.currentContext, authService);
      } else {
        // Fallback or log if context is not available, though this is less likely for addPostFrameCallback
        // Potentially initialize without context if DeepLinkHandler can support it for non-navigational links
        // Or, store authService and context and try again if context becomes available.
        // For now, we assume it will usually be available.
        DeepLinkHandler.initialize(null, authService); // Or handle error
        debugPrint(
            "DeepLinkHandler initialized without BuildContext after frame.");
      }
    });
  }

  @override
  void dispose() {
    DeepLinkHandler.dispose();
    super.dispose();
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
    // Here you would typically update a theme provider
    // e.g., ref.read(themeProvider.notifier).setTheme(isDark ? AppTheme.darkTheme : AppTheme.lightTheme);
  }

  @override
  Widget build(BuildContext context) {
    // TaskService, NotificationService, and TaskCommentService are now Riverpod providers.
    // TaskCategoryService and TaskListProvider are still legacy.
    // We only need MultiProvider for the remaining legacy providers.
    return legacy_provider.MultiProvider(
      providers: [
        legacy_provider.ChangeNotifierProvider<TaskCategoryService>(
            create: (_) => TaskCategoryService()),
        legacy_provider.ChangeNotifierProvider<TaskListProvider>(
            create: (_) => TaskListProvider()),
        // TaskService and TaskCommentService are removed as they are now Riverpod providers.
        // NotificationService was already a Riverpod provider.
      ],
      child: MaterialApp(
        // MaterialApp is the direct child now
        title: 'Vuet App',
        debugShowCheckedModeBanner: false,
        theme: _isDarkMode
            ? AppTheme.darkTheme
            : AppTheme.lightTheme, // Updated theme based on state
        navigatorKey: _navigatorKey, // _navigatorKey is part of _VuetAppState
        home: const AuthWrapper(
          child: HomePage(title: 'Vuet App'),
        ),
        routes: {
          '/home': (context) => const AuthWrapper(
                child: HomePage(title: 'Vuet App'),
              ),
          '/update-password': (context) => const UpdatePasswordScreen(),
          '/notifications': (context) => const NotificationsScreen(),
          '/family': (context) => const AuthWrapper(
                child: FamilyScreen(),
              ),
        },
      ),
    );
  }
}

// Fallback app when Supabase initialization fails
// Ensure only one definition of VuetAppFallback
class VuetAppFallback extends StatelessWidget {
  const VuetAppFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vuet App - Environment Issue',
      debugShowCheckedModeBanner:
          true, // Keep this true for fallback visibility
      theme: ThemeData(
        // Use a distinct theme for fallback
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Vuet App - Environment Issue'),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
        body: const SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning,
                    size: 64,
                    color: Colors.orange,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Environment Configuration Issue',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'The app could not initialize properly.\nPlease check the environment configuration.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'For production: flutter build web --release --dart-define=FLUTTER_ENV=production',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  // Changed to ConsumerStatefulWidget
  const HomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<HomePage> createState() =>
      _HomePageState(); // Changed to ConsumerState
}

class _HomePageState extends ConsumerState<HomePage> {
  // Changed to ConsumerState<HomePage>
  int _selectedIndex = 0;

  // _widgetOptions needs to be mutable if TaskListScreen is replaced
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const ModernizedHomeScreen(), // HOME (first)
      const CategoriesScreen(), // CATEGORIES (second)
      const RedesignedListsScreen(), // LISTS (third)
      const LanaChatScreen(), // LANA (fourth)
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Get task-related notifications count for the Tasks tab using Riverpod
  int _getTaskNotificationsCount(WidgetRef ref) {
    final notificationService =
        ref.watch(notificationServiceProvider); // Watch Riverpod provider
    return notificationService.notifications
        .where((notification) =>
            !notification.isRead && notification.isTaskRelated)
        .length;
  }

  void _navigateToCreateTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateTaskScreen()),
    ).then((value) {
      // Refresh if needed
      if (value == true && _selectedIndex == 1) {
        setState(() {
          // This forces a rebuild of the TaskListScreen
          _widgetOptions[1] = const TaskListScreen();
        });
      }
    });
  }

  void navigateToTaskDetail(String taskId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(taskId: taskId),
      ),
    ).then((value) {
      // Refresh if needed
      if (value == true && _selectedIndex == 1) {
        setState(() {
          // This forces a rebuild of the TaskListScreen
          _widgetOptions[1] = const TaskListScreen();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          // Notification badge (always visible)
          // NotificationBadge fetches its own count via Provider/Riverpod
          IconButton(
            icon: const NotificationBadge(),
            tooltip: 'Notifications',
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),

          // Add task button (now always visible in AppBar)
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToCreateTask,
            tooltip: 'Add Task',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('My Account'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyAccountScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.repeat), // Icon for Routines
              title: const Text('Routines'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RoutinesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time), // Icon for Timeblocks
              title: const Text('Timeblocks'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TimeblockNavigator()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.family_restroom), // Icon for Family
              title: const Text('Family'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/family');
              },
            ),
            Consumer(builder: (context, ref, child) {
              // Access the global _isDarkMode state from _VuetAppState
              final isDarkModeGlobal = context
                      .findAncestorStateOfType<_VuetAppState>()
                      ?._isDarkMode ??
                  false;
              return SwitchListTile(
                title: const Text('Dark Mode'),
                value: isDarkModeGlobal,
                onChanged: (bool value) {
                  // Call _toggleTheme on the _VuetAppState instance
                  context
                      .findAncestorStateOfType<_VuetAppState>()
                      ?._toggleTheme(value);
                },
                secondary: Icon(
                    isDarkModeGlobal ? Icons.brightness_3 : Icons.brightness_7),
              );
            }),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                Navigator.pop(context); // Close the drawer
                await ref.read(authServiceProvider).signOut();
                // Navigator.of(context).pushAndRemoveUntil(
                //   MaterialPageRoute(builder: (context) => const AuthWrapper(child: HomePage(title: 'Vuet App'))),
                //   (Route<dynamic> route) => false,
                // );
                // The AuthWrapper should handle navigation to the login screen upon logout.
              },
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      // Use Consumer for BottomNavigationBar to get task-specific count
      bottomNavigationBar: Consumer(
        builder: (context, innerRef, child) {
          // Use innerRef for this specific Consumer
          _getTaskNotificationsCount(
              innerRef); // Called for its side effects or future use

          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0, // Remove shadow
            items: const <BottomNavigationBarItem>[
              // HOME (first)
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'HOME',
              ),
              // CATEGORIES (second)
              BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined),
                activeIcon: Icon(Icons.category),
                label: 'CATEGORIES',
              ),
              // LISTS (third)
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_outlined),
                activeIcon: Icon(Icons.list_alt),
                label: 'LISTS',
              ),
              // LANA (fourth)
              BottomNavigationBarItem(
                icon: Icon(Icons.assistant_outlined),
                activeIcon: Icon(Icons.assistant),
                label: 'LANA',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          );
        },
      ),
    );
  }
}
