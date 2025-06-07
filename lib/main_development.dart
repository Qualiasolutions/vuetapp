import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:provider/provider.dart'
    as legacy_provider; // Keep legacy provider for now
import 'package:vuet_app/config/supabase_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vuet_app/utils/logger.dart';
import 'package:vuet_app/providers/auth_providers.dart'; // Import auth providers
import 'package:vuet_app/services/notification_service.dart'; // Still needed for type, but instance from Riverpod
import 'package:vuet_app/services/task_category_service.dart';
import 'package:vuet_app/src/features/tasks/presentation/providers/task_list_provider.dart'; // Added
import 'package:vuet_app/ui/theme/app_theme.dart';
import 'package:vuet_app/ui/screens/tasks/task_list_screen.dart';
import 'package:vuet_app/ui/screens/tasks/create_task_screen.dart';
import 'package:vuet_app/ui/screens/tasks/task_detail_screen.dart';
import 'package:vuet_app/ui/screens/auth/auth_wrapper.dart';
import 'package:vuet_app/ui/screens/auth/update_password_screen.dart';
import 'package:vuet_app/ui/screens/notifications/notifications_screen.dart';
// Added ModernizedHomeScreen // Removed unused import: modernized_home_screen.dart
import 'package:vuet_app/ui/screens/categories/categories_grid.dart'; // Import CategoriesGrid
import 'package:vuet_app/ui/screens/calendar/calendar_screen.dart'; // Added CalendarScreen
import 'package:vuet_app/widgets/notification_badge.dart';
import 'package:vuet_app/widgets/tab_notification_badge.dart';
import 'package:vuet_app/utils/deep_link_handler.dart';
import 'package:vuet_app/ui/screens/lists/redesigned_lists_screen.dart'; // Added RedesignedListsScreen
import 'package:vuet_app/ui/screens/lana_ai_assistant_screen.dart'; // Added LanaAiAssistantScreen
import 'package:vuet_app/ui/screens/account/my_account_screen.dart'; // Added MyAccountScreen
// Added SettingsScreen
import 'package:go_router/go_router.dart';
import 'package:vuet_app/ui/navigation/pets_navigator.dart';
import 'package:vuet_app/ui/navigation/account_settings_navigator.dart'; // Assuming this should be used
// Added for /family route // Removed unused import: family_screen.dart

// Global navigator key for GoRouter
final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

// GoRouter configuration
final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/', 
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home_wrapper', // Changed name to avoid conflict if HomePage itself has a 'home' name
      builder: (BuildContext context, GoRouterState state) => const AuthWrapper(
        child: HomePage(title: 'Vuet App (Dev)'),
      ),
    ),
    GoRoute(
      path: '/update-password',
      name: 'update-password',
      builder: (BuildContext context, GoRouterState state) =>
          const UpdatePasswordScreen(),
    ),
    GoRoute(
      path: '/notifications',
      name: 'notifications',
      builder: (BuildContext context, GoRouterState state) =>
          const NotificationsScreen(),
    ),
    // Note: The original main.dart had a /family route. Adding it here for main_development.dart consistency if FamilyScreen is available.
    // If FamilyScreen is not used in main_development.dart's original routes, this can be removed.
    // Checking original main_development.dart: it did NOT have /family.
    // Checking original main.dart: it DID have /family.
    // For now, I will include it but comment it out if FamilyScreen is not imported by default in main_development.dart
    // FamilyScreen is NOT imported in the original main_development.dart. So, it should remain commented or removed.
    // Let's assume it's not needed for main_development.dart for now to match its original routes.
    // GoRoute(
    //   path: '/family',
    //   name: 'family',
    //   builder: (BuildContext context, GoRouterState state) => const AuthWrapper(
    //     child: FamilyScreen(), 
    //   ),
    // ),
    // Integrate routes from modular navigators
    ...AccountSettingsNavigator.routes(),
    ...PetsNavigator.routes(),
  ],
  // Optional: Add errorBuilder and redirect logic as needed
  // errorBuilder: (context, state) => ErrorScreen(error: state.error),
  // redirect: (BuildContext context, GoRouterState state) {
  //   // final loggedIn = ref.watch(authProvider).isLoggedIn; 
  //   // final loggingIn = state.matchedLocation == '/login';
  //   // if (!loggedIn && !loggingIn) return '/login';
  //   // if (loggedIn && loggingIn) return '/';
  //   return null;
  // },
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables and initialize Supabase
  try {
    // Load the .env.development file
    await dotenv.load(fileName: '.env.development');

    // Initialize Supabase
    await SupabaseConfig.initialize(isProduction: false);

    // Wrap with ProviderScope for Riverpod
    runApp(const ProviderScope(child: VuetApp()));
  } catch (error) {
    log('Error during initialization: $error', error: error);
    // Fallback app should also be wrapped if it uses Riverpod, but it's simple for now
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
  // final _navigatorKey = GlobalKey<NavigatorState>(); // Removed, GoRouter uses _rootNavigatorKey
  bool _isDarkMode = false; // Added for Dark Mode toggle

  @override
  void initState() {
    super.initState();
    // Initialize deep link handler after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = ref.read(supabaseAuthServiceProvider);
      // DeepLinkHandler should now use the _rootNavigatorKey context
      if (_rootNavigatorKey.currentContext != null &&
          _rootNavigatorKey.currentContext!.mounted) {
        DeepLinkHandler.initialize(_rootNavigatorKey.currentContext, authService);
      } else {
        DeepLinkHandler.initialize(null, authService); 
        debugPrint(
            "DeepLinkHandler initialized without BuildContext (using root key context) after frame.");
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
      child: MaterialApp.router(
        title: 'Vuet App (Dev)', // Indicate Development
        debugShowCheckedModeBanner: true, // Show debug banner in dev
        theme: _isDarkMode
            ? AppTheme.darkTheme
            : AppTheme.lightTheme, // Updated theme based on state
        routerConfig: _router, // Use GoRouter configuration
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
      title: 'Vuet App - Development Mode Fallback',
      debugShowCheckedModeBanner:
          true, // Keep this true for fallback visibility
      theme: ThemeData(
        // Use a distinct theme for fallback
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Vuet App - Dev Mode Fallback'),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            'Development Mode Fallback\nEnvironment configuration issue detected',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
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
      const CalendarScreen(), // First tab
      const CategoriesGrid(), // Second tab - Changed from ModernizedHomeScreen
      const RedesignedListsScreen(), // Third tab
      const TaskListScreen(), // Fourth tab (originally Profile, now Tasks to keep it)
      const LanaAiAssistantScreen(), // Fifth tab
    ];
  }

  void _onItemTapped(int index) {
    // If middle button (index 2, "Add Task") is pressed, special action.
    // Otherwise, navigate to the screen.
    if (index == 2 && _originalMiddleButtonIsAddTask) {
      // Need a flag or check if we want to keep original "Add Task" functionality elsewhere. For now, assume it's replaced.
      // _navigateToCreateTask(); // This was the original action for the middle button.
      // The 3rd button (index 2) is now "Lists", so it should navigate.
      setState(() {
        _selectedIndex = index;
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // A flag to keep track of the original middle button's purpose if we need to toggle
  // For now, we assume the middle button is permanently changed to "Lists".
  // If the middle button were to sometimes be "Add Task" and sometimes "Lists",
  // this logic would need to be more complex.
  final bool _originalMiddleButtonIsAddTask = false;

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
    // final unreadCount = ref.watch(unreadNotificationCountProvider); // Not needed directly for NotificationBadge here

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
              // Navigator.pushNamed(context, '/notifications'); // Old way
              context.goNamed('notifications'); // GoRouter way
            },
          ),

          // Add task button (only visible on tasks tab, which is now _selectedIndex == 3)
          if (_selectedIndex ==
              3) // Assuming Tasks tab is now the 4th item (index 3)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _navigateToCreateTask,
              tooltip: 'Create Task',
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
              child: Text(
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
                        builder: (context) => const MyAccountScreen()));
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
                await ref.read(supabaseAuthServiceProvider).signOut();
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
          final taskNotificationCount = _getTaskNotificationsCount(innerRef);

          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              // Calendar tab now comes first
              const BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined),
                activeIcon: Icon(Icons.calendar_today),
                label: 'Calendar',
              ),
              // Categories/Home tab second
              const BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_outlined),
                activeIcon: Icon(Icons.grid_view),
                label: 'Categories',
              ),
              // Lists Tab (replaces Add Task button)
              const BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_outlined),
                activeIcon: Icon(Icons.list_alt),
                label: 'Lists',
              ),
              // Tasks tab with notification badge fourth
              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.task_outlined),
                    if (taskNotificationCount > 0)
                      Positioned(
                        right: -6,
                        top: -3,
                        child: TabNotificationBadge(
                          count: taskNotificationCount,
                        ),
                      ),
                  ],
                ),
                activeIcon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.task),
                    if (taskNotificationCount > 0)
                      Positioned(
                        right: -6,
                        top: -3,
                        child: TabNotificationBadge(
                          count: taskNotificationCount,
                        ),
                      ),
                  ],
                ),
                label: 'Tasks',
              ),
              // Lana AI Assistant tab (replaces Profile tab)
              const BottomNavigationBarItem(
                icon: Icon(Icons.assistant_outlined),
                activeIcon: Icon(Icons.assistant),
                label: 'Lana AI',
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
