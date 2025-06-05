import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/services/setup_service.dart';

final setupServiceProvider = Provider<SetupService>((ref) {
  return SetupService();
});

final categorySetupCompletionProvider = FutureProvider.family<bool, String>((ref, categoryId) async {
  final setupService = ref.read(setupServiceProvider);
  return await setupService.isCategorySetupCompleted(categoryId);
});
