import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/repositories/supabase_entity_repository.dart';
import 'package:vuet_app/services/entity_service.dart';

/// Provider for the EntityService
final entityServiceProvider = Provider<EntityService>((ref) {
  final entityRepository = ref.watch(supabaseEntityRepositoryProvider);
  return EntityService(repository: entityRepository);
}); 