import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/config/supabase_config.dart';
import 'package:vuet_app/models/user_model.dart';

/// Service for user management operations
class UserService {
  /// Supabase client instance
  final SupabaseClient _client;
  
  /// Constructor
  UserService({SupabaseClient? client}) 
    : _client = client ?? SupabaseConfig.client;
  
  /// Table name for users
  static const String _tableName = 'profiles';
  
  /// Get all users
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .order('first_name', ascending: true);
      
      return response.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ Error getting users: $e');
      rethrow;
    }
  }
  
  /// Get a user by ID
  Future<UserModel?> getUserById(String id) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('id', id)
          .maybeSingle();
      
      if (response == null) {
        return null;
      }
      
      return UserModel.fromJson(response);
    } catch (e) {
      debugPrint('❌ Error getting user by ID: $e');
      rethrow;
    }
  }
  
  /// Search users by name or email
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final lowercaseQuery = query.toLowerCase();
      
      // Get all users first (not efficient for large datasets)
      final response = await _client
          .from(_tableName)
          .select()
          .order('first_name', ascending: true);
      
      // Filter users that match the query in client side
      final filteredUsers = response.where((user) {
        final firstName = user['first_name'].toString().toLowerCase();
        final lastName = user['last_name'].toString().toLowerCase();
        final email = user['email'].toString().toLowerCase();
        
        return firstName.contains(lowercaseQuery) || 
               lastName.contains(lowercaseQuery) || 
               email.contains(lowercaseQuery);
      }).toList();
      
      return filteredUsers.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ Error searching users: $e');
      rethrow;
    }
  }
}
