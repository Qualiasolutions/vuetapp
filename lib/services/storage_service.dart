import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/services/auth_service.dart'; // To get current user ID and provider

class StorageService {
  final SupabaseClient _supabaseClient;
  final AuthService _authService;

  StorageService(this._supabaseClient, this._authService);

  // Uploads an avatar image for the current user
  // Returns the public URL of the uploaded image
  Future<String> uploadAvatar(File imageFile) async {
    if (!_authService.isSignedIn) {
      throw Exception('User not authenticated to upload avatar.');
    }
    final userId = _authService.currentUser!.id;
    final fileExtension = imageFile.path.split('.').last.toLowerCase();
    final fileName = '$userId/avatar.$fileExtension'; // e.g., user_id/avatar.png
    final String bucketName = 'avatars';

    try {
      // Upload the file
      await _supabaseClient.storage.from(bucketName).upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true), // Upsert to overwrite if exists
          );

      // Get the public URL
      final String publicUrl = _supabaseClient.storage.from(bucketName).getPublicUrl(fileName);
      
      // Supabase public URLs might include a timestamp for cache busting if not handled by CDN.
      // For simplicity, we use the direct public URL.
      // If the URL includes a timestamp like ?t=..., you might want to strip it
      // or ensure your profile stores the base URL.
      // For now, assuming the URL is stable or the timestamp is fine.
      
      debugPrint('Avatar uploaded: $publicUrl');
      return publicUrl;

    } on StorageException catch (e) {
      debugPrint('StorageService Error - Upload Avatar: ${e.message}');
      // You might want to map specific StorageException errors to user-friendly messages
      if (e.message.contains('mime type')) {
        throw Exception('Invalid file type. Please upload an image.');
      }
      rethrow; // Rethrow to be handled by the UI
    } catch (e) {
      debugPrint('StorageService Unexpected Error - Upload Avatar: $e');
      rethrow;
    }
  }

  // TODO: Implement methods for uploading entity images to 'entity-images' bucket
  // Future<String> uploadEntityImage(File imageFile, String entityId) async { ... }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  // Assuming AuthService exposes the SupabaseClient instance or we get it from SupabaseConfig directly
  // For consistency with other services, let's get it via AuthService if possible.
  // AuthService already has _supabaseClient = SupabaseConfig.client;
  // and a getter `SupabaseClient get supabase => _supabaseClient;`
  final authService = ref.watch(authServiceProvider);
  return StorageService(authService.supabase, authService);
});
