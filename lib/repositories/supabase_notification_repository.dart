import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/notification_model.dart';
import 'dart:developer' as developer;
import 'package:vuet_app/repositories/notification_repository.dart';
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/services/realtime_subscription_manager.dart';

/// Supabase implementation of the notification repository
class SupabaseNotificationRepository implements NotificationRepository {
  /// Supabase client instance
  final SupabaseClient _client;
  final AuthService _authService;
  final RealtimeSubscriptionManager _subscriptionManager;

  /// Table name in Supabase
  static const String _tableName = 'notifications';

  /// Constructor
  SupabaseNotificationRepository({
    SupabaseClient? client,
    required AuthService authService,
    required RealtimeSubscriptionManager subscriptionManager,
  })  : _client = client ?? Supabase.instance.client,
        _authService = authService,
        _subscriptionManager = subscriptionManager;

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      if (!_authService.isSignedIn) {
        return [];
      }
      final userId = _authService.currentUser?.id;
      if (userId == null) return [];

      final response = await _client
          .from(_tableName)
          .select()
          .eq('profile_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => NotificationModel.fromJson(item))
          .toList();
    } catch (e) {
      // Log the error
      developer.log('Error getting notifications: $e');
      return [];
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      if (!_authService.isSignedIn) {
        return 0;
      }
      final userId = _authService.currentUser?.id;
      if (userId == null) return 0;

      final response = await _client
          .from(_tableName)
          .select('id')
          .eq('is_read', false)
          .eq('profile_id', userId)
          .count(CountOption.exact);

      return response.count;
    } catch (e) {
      // Log the error
      developer.log('Error getting unread count: $e');
      return 0;
    }
  }

  @override
  Future<bool> markAsRead(String notificationId) async {
    try {
      if (!_authService.isSignedIn) {
        return false;
      }

      await _client
          .from(_tableName)
          .update({'is_read': true})
          .eq('id', notificationId);
      
      return true;
    } catch (e) {
      // Log the error
      developer.log('Error marking notification as read: $e');
      return false;
    }
  }

  @override
  Future<int> markAllAsRead() async {
    try {
      if (!_authService.isSignedIn) {
        return 0;
      }
      final userId = _authService.currentUser?.id;
      if (userId == null) return 0;

      // First, get count of unread notifications
      final countResponse = await _client
          .from(_tableName)
          .select('id')
          .eq('is_read', false)
          .eq('profile_id', userId)
          .count(CountOption.exact);

      final unreadCount = countResponse.count;

      // Mark all as read
      await _client
          .from(_tableName)
          .update({'is_read': true})
          .eq('is_read', false)
          .eq('profile_id', userId);
      
      return unreadCount;
    } catch (e) {
      // Log the error
      developer.log('Error marking all notifications as read: $e');
      return 0;
    }
  }

  @override
  Future<bool> deleteNotification(String notificationId) async {
    try {
      if (!_authService.isSignedIn) {
        return false;
      }

      await _client
          .from(_tableName)
          .delete()
          .eq('id', notificationId);
      
      return true;
    } catch (e) {
      // Log the error
      developer.log('Error deleting notification: $e');
      return false;
    }
  }

  @override
  Stream<List<NotificationModel>> getNotificationsStream() {
    if (!_authService.isSignedIn) {
      return Stream.value([]);
    }

    final userId = _authService.currentUser?.id;
    if (userId == null) {
      return Stream.value([]);
    }

    // Use centralized subscription manager
    return _subscriptionManager
        .getTableStream(
          _tableName,
          filter: 'profile_id',
          filterValue: userId,
        )
        .map((data) => data
            .map((item) => NotificationModel.fromJson(item))
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)));
  }

  @override
  Future<NotificationModel> createNotification({
    required String userId,
    required String type,
    required String message,
    Map<String, dynamic>? metadata,
    String? taskId,
    String importance = NotificationModel.importanceNormal,
    String category = NotificationModel.categoryGeneral,
  }) async {
    try {
      final notification = NotificationModel(
        userId: userId,
        type: type,
        message: message,
        metadata: metadata ?? {},
        taskId: taskId,
        importance: importance,
        category: category,
      );

      final response = await _client
          .from(_tableName)
          .insert(notification.toJson())
          .select();

      // Return the created notification with server ID
      final createdData = response[0];
      return NotificationModel.fromJson(createdData);
    } catch (e) {
      // Log the error
      developer.log('Error creating notification: $e');
      rethrow;
    }
  }

  @override
  Future<NotificationModel> sendTestNotification({
    required String message,
    String type = NotificationModel.typeTaskUpdated,
    String importance = NotificationModel.importanceNormal,
  }) async {
    try {
      if (!_authService.isSignedIn) {
        throw Exception('User not signed in');
      }

      return await createNotification(
        userId: _authService.currentUser?.id ?? '',
        type: type,
        message: message,
        metadata: {'test': true, 'created_manually': true},
        importance: importance,
        category: NotificationModel.categorySystem,
      );
    } catch (e) {
      // Log the error
      developer.log('Error sending test notification: $e');
      rethrow;
    }
  }

  @override
  Future<NotificationModel?> getById(String id) async {
    try {
      if (!_authService.isSignedIn) {
        return null;
      }

      final response = await _client
          .from(_tableName)
          .select()
          .eq('id', id)
          .limit(1)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return NotificationModel.fromJson(response);
    } catch (e) {
      // Log the error
      developer.log('Error getting notification by ID: $e');
      return null;
    }
  }

  @override
  Future<bool> updateNotification(NotificationModel notification) async {
    try {
      if (!_authService.isSignedIn) {
        return false;
      }

      await _client
          .from(_tableName)
          .update(notification.toJson())
          .eq('id', notification.id);
      
      return true;
    } catch (e) {
      // Log the error
      developer.log('Error updating notification: $e');
      return false;
    }
  }

  @override
  Future<int> deleteAllNotifications() async {
    try {
      if (!_authService.isSignedIn) {
        developer.log('Operation requires authentication.');
        return 0;
      }
      final userId = _authService.currentUser?.id;
      if (userId == null) return 0;

      // First, get count of all notifications for this user
      final countResponse = await _client
          .from(_tableName)
          .select('id')
          .eq('profile_id', userId)
          .count(CountOption.exact);

      final totalCount = countResponse.count;

      // Delete all notifications for this user
      if (totalCount > 0) {
        await _client
            .from(_tableName)
            .delete()
            .eq('profile_id', userId);
      }
      
      return totalCount;
    } catch (e) {
      // Log the error
      developer.log('Error deleting all notifications: $e');
      return 0;
    }
  }
}

final supabaseNotificationRepositoryProvider = Provider<SupabaseNotificationRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  final subscriptionManager = ref.watch(realtimeSubscriptionManagerProvider);
  return SupabaseNotificationRepository(
    authService: authService,
    subscriptionManager: subscriptionManager,
  );
});
