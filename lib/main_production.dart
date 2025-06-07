import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:provider/provider.dart' as legacy_provider; // Keep legacy provider for now
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
// import 'package:vuet_app/ui/screens/home/modernized_home_screen.dart'; // No longer needed here
import 'package:vuet_app/ui/screens/calendar/calendar_screen.dart'; // Added CalendarScreen
import 'package:vuet_app/ui/screens/categories/categories_grid.dart'; // Added CategoriesGrid
import 'package:vuet_app/widgets/notification_badge.dart';
import 'package:vuet_app/widgets/tab_notification_badge.dart';
import 'package:vuet_app/utils/deep_link_handler.dart';
import 'package:vuet_app/ui/screens/lists/redesigned_lists_screen.dart'; // Added RedesignedListsScreen
import 'package:vuet_app/ui/screens/lana_ai_assistant_screen.dart'; // Added LanaAiAssistantScreen
import 'package:vuet_app/ui/screens/account/my_account_screen.dart'; // Added MyAccountScreen
// Added SettingsScreen
import 'package:vuet_app/ui/navigation/pets_navigator.dart'; // Import PetsNavigator
import 'package:vuet_app/ui/screens/timeblocks/timeblocks_screen.dart';
import 'package:vuet_app/ui/screens/timeblocks/create_edit_timeblock_screen.dart';
import 'package:vuet_app/ui/screens/timeblocks/timeblock_detail_screen.dart';
import 'package:vuet_app/ui/screens/family/family_screen.dart'; // Though not in routes, good for consistency if needed later
import 'package:vuet_app/ui/navigation/social_interests_navigator.dart'; // Import SocialInterestsNavigator

// Navigator key
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// GoRouter configuration
final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthWrapper(
        child: HomePage(title: 'Vuet App'),
      ),
    ),
    GoRoute(
      path: '/update-password',
      builder: (context, state) => const UpdatePasswordScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/my-account', // For drawer navigation
      builder: (context, state) => const MyAccountScreen(),
    ),
    // Add routes from PetsNavigator
    ...PetsNavigator.routes(),
    // Define routes for Timeblocks feature (assuming it might be added to production)
    GoRoute(
      path: '/timeblocks',
      builder: (context, state) => const TimeblocksScreen(),
    ),
    GoRoute(
      path: '/timeblocks/create',
      builder: (context, state) => const CreateEditTimeblockScreen(),
    ),
    GoRoute(
      path: '/timeblocks/edit/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return CreateEditTimeblockScreen(timeblockId: id);
      },
    ),
    GoRoute(
      path: '/timeblocks/detail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return TimeblockDetailScreen(timeblockId: id);
      },
    ),
     GoRoute( // Adding family route for completeness, though not in original MaterialApp routes for prod
      path: '/family',
      builder: (context, state) => const AuthWrapper(
        child: FamilyScreen(),
      ),
    ),
    // Add routes from SocialInterestsNavigator
    ...SocialInterestsNavigator.routes(),
  ],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables and initialize Supabase
  try {
    // Load the .env.production file
    await dotenv.load(fileName: '.env.production');
    
    // Initialize Supabase
    await SupabaseConfig.initialize(isProduction: true);
    
    // Wrap with ProviderScope for Riverpod
    runApp(const ProviderScope(child: VuetApp())); 
  } catch (error) {
    log('Error during production initialization: $error', error: error);
    // Fallback app for production - should be very minimal or a specific error screen
    runApp(const VuetAppProductionFallback());
  }
}

class VuetApp extends ConsumerStatefulWidget {
  const VuetApp({super.key});

@override
ConsumerState<VuetApp> createState() => _VuetAppState();
}

class _VuetAppState extends ConsumerState<VuetApp> {
  // final _navigatorKey = GlobalKey<NavigatorState>(); // Replaced by _rootNavigatorKey
  bool _isDarkMode = false; // Added for Dark Mode toggle

  @override
  void initState() {
    super.initState();
    // Initialize deep link handler after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = ref.read(authServiceProvider);
      // Ensure context is still valid if this callback is delayed
      if (_rootNavigatorKey.currentContext != null && _rootNavigatorKey.currentContext!.mounted) {
         DeepLinkHandler.initialize(_rootNavigatorKey.currentContext, authService);
      } else {
        DeepLinkHandler.initialize(null, authService); // Or handle error
        debugPrint("DeepLinkHandler initialized without BuildContext after frame (using _rootNavigatorKey path).");
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
    // e.g., ref.read(themeProvider.notifier).setTheme(isDark ? AppTheme.darkTheme : AppTheme.lightTheme);
  }

  @override
  Widget build(BuildContext context) {
    return legacy_provider.MultiProvider(
      providers: [
        legacy_provider.ChangeNotifierProvider<TaskCategoryService>(create: (_) => TaskCategoryService()),
        legacy_provider.ChangeNotifierProvider<TaskListProvider>(create: (_) => TaskListProvider()),
      ],
      child: MaterialApp.router(
        routerDelegate: _router.routerDelegate,
        routeInformationParser: _router.routeInformationParser,
        routeInformationProvider: _router.routeInformationProvider,
        title: 'Vuet App', // Production Title
        debugShowCheckedModeBanner: false, // Hide debug banner in production
        theme: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
        // navigatorKey, home, and routes are handled by GoRouter
      ),
    );
  }
}

// Fallback app when Supabase initialization fails in Production
class VuetAppProductionFallback extends StatelessWidget {
  const VuetAppProductionFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vuet App - Error',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Application Error'),
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'An error occurred while starting the application. Please try again later.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
     _widgetOptions = <Widget>[
      const CalendarScreen(), // First tab (Calendar/Home)
      const CategoriesGrid(), // Second tab (Categories) - Changed from ModernizedHomeScreen
      const RedesignedListsScreen(), // Third tab
      const TaskListScreen(), // Fourth tab
      const LanaAiAssistantScreen(), // Fifth tab
    ];
  }
  
  void _onItemTapped(int index) {
    if (index == 2 && _originalMiddleButtonIsAddTask) {
       setState(() {
        _selectedIndex = index;
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
  
  final bool _originalMiddleButtonIsAddTask = false; 

  int _getTaskNotificationsCount(WidgetRef ref) {
    final notificationService = ref.watch(notificationServiceProvider);
    return notificationService.notifications
        .where((notification) => 
            !notification.isRead && 
            notification.isTaskRelated)
        .length;
  }

  void _navigateToCreateTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateTaskScreen()),
    ).then((value) {
      if (value == true && _selectedIndex == 1) {
        setState(() {
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
      if (value == true && _selectedIndex == 1) {
        setState(() {
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
          IconButton(
            icon: const NotificationBadge(), 
            tooltip: 'Notifications',
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          if (_selectedIndex == 3)
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
                Navigator.pop(context);
                context.push('/my-account'); // Navigate using GoRouter
              },
            ),
            // Example for adding other drawer items if needed with GoRouter
            // ListTile(
            //   leading: const Icon(Icons.family_restroom),
            //   title: const Text('Family'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     context.push('/family');
            //   },
            // ),
            Consumer(
              builder: (context, ref, child) {
                final isDarkModeGlobal = context.findAncestorStateOfType<_VuetAppState>()?._isDarkMode ?? false;
                return SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: isDarkModeGlobal,
                  onChanged: (bool value) {
                    context.findAncestorStateOfType<_VuetAppState>()?._toggleTheme(value);
                  },
                  secondary: Icon(
                    isDarkModeGlobal 
                        ? Icons.brightness_3 
                        : Icons.brightness_7
                  ),
                );
              }
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                Navigator.pop(context); 
                await ref.read(authServiceProvider).signOut();
              },
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Consumer( 
        builder: (context, innerRef, child) {
          final taskNotificationCount = _getTaskNotificationsCount(innerRef);
          
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined),
                activeIcon: Icon(Icons.calendar_today),
                label: 'Calendar',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_outlined),
                activeIcon: Icon(Icons.grid_view),
                label: 'Categories',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_outlined),
                activeIcon: Icon(Icons.list_alt),
                label: 'Lists',
              ),
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
