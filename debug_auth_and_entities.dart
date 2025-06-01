import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/repositories/supabase_entity_repository.dart';

import 'package:vuet_app/config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  runApp(const ProviderScope(child: DebugApp()));
}

class DebugApp extends StatelessWidget {
  const DebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const DebugScreen(),
    );
  }
}

class DebugScreen extends ConsumerWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth & Entity Debug')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () async {
                final authService = ref.read(authServiceProvider);
                final entityRepository = ref.read(supabaseEntityRepositoryProvider);
                
                if (authService.isSignedIn) {
                  final userId = authService.currentUser!.id;
                  
                  // Test 1: Get all entities for this user
                  try {
                    /*final allEntities =*/ await entityRepository.listEntities(userId: userId);
                    // 'All entities for user $userId: ${allEntities.length}'
                    // for (final entity in allEntities) {
                    //   '  - ${entity.name} (app_category_id: ${entity.appCategoryId})'
                    // }
                  } catch (e) {
                    // 'Error fetching all entities: $e'
                    // Error intentionally not handled in debug script
                  }
                  
                  // Test 2: Get entities for category 1 (Pets)
                  try {
                    /*final petsEntities =*/ await entityRepository.listEntities(userId: userId, appCategoryId: 1);
                    // '\nPets entities (app_category_id: 1): ${petsEntities.length}'
                    // for (final entity in petsEntities) {
                    //   '  - ${entity.name}'
                    // }
                  } catch (e) {
                    // 'Error fetching pets entities: $e'
                    // Error intentionally not handled in debug script
                  }
                  
                  // Test 3: Get entities for category 12 (Transport)
                  try {
                    /*final transportEntities =*/ await entityRepository.listEntities(userId: userId, appCategoryId: 12);
                    // '\nTransport entities (app_category_id: 12): ${transportEntities.length}'
                    // for (final entity in transportEntities) {
                    //   '  - ${entity.name}'
                    // }
                  } catch (e) {
                    // 'Error fetching transport entities: $e'
                    // Error intentionally not handled in debug script
                  }
                }
              },
              child: const Text('Debug Auth & Entities'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final authService = ref.read(authServiceProvider);
                
                if (authService.isSignedIn) {
                  try {
                    /*final profile =*/ await authService.getUserProfile();
                    // '=== USER PROFILE ==='
                    // 'Profile: $profile'
                  } catch (e) {
                    // 'Error fetching profile: $e'
                    // Error intentionally not handled in debug script
                  }
                }
              },
              child: const Text('Debug User Profile'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final authService = ref.read(authServiceProvider);
                try {
                  final result = await authService.enhancedSignInWithEmailPassword(
                    email: 'pheobe@admin.com',
                    password: 'Pheobe1!',
                  );

                  if (result.success) {
                    // '=== FORCE SIGN-IN SUCCESS ==='
                    // 'Message: ${result.message}'
                  } else {
                  }
                } catch (e) {
                  // '=== FORCE SIGN-IN ERROR ==='
                  // 'Exception: $e'
                  // Error intentionally not handled in debug script
                }
              },
              child: const Text('Force Sign-In'),
            ),
          ],
        ),
      ),
    );
  }
}
