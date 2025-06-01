import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/models/user_model.dart';
import 'package:vuet_app/services/notification_service.dart';
import 'package:vuet_app/services/task_service.dart';
import 'package:vuet_app/services/user_service.dart';
import 'package:vuet_app/ui/theme/app_theme.dart';

/// Screen for sharing a task with other users
class ShareTaskScreen extends StatefulWidget {
  /// The task to share
  final TaskModel task;

  /// Constructor
  const ShareTaskScreen({
    super.key,
    required this.task,
  });

  @override
  State<ShareTaskScreen> createState() => _ShareTaskScreenState();
}

class _ShareTaskScreenState extends State<ShareTaskScreen> {
  late TaskService _taskService;
  final UserService _userService = UserService();
  
  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];
  List<String> _selectedUserIds = [];
  List<String> _sharedWithUserIds = []; // Users currently shared with
  bool _isLoading = true;
  bool _isSaving = false;
  String _error = '';
  Timer? _searchDebounceTimer;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    _initServices();
    _loadSharedUsers();
    _loadUsers();
  }

  void _initServices() {
    // Get the TaskService from the Provider system
    // This assumes TaskService is properly initialized in the provider tree
    _taskService = Provider.of<TaskService>(context, listen: false);
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchDebounceTimer?.cancel();
    super.dispose();
  }
  
  void _loadSharedUsers() {
    // Initialize with empty array since we don't have access to shared users directly
    // Shared users will be loaded from the task_shares table by the TaskService when
    // needed for operations like shareTaskWithUser and removeTaskShare
    setState(() {
      _selectedUserIds = [];
      _sharedWithUserIds = [];
    });
  }
  
  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    
    try {
      final users = await _userService.getUsers();
      
      setState(() {
        // Filter out the current user
        _users = users.where((user) => user.id != widget.task.createdById).toList();
        _filteredUsers = List<UserModel>.from(_users);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading users: $e';
        _isLoading = false;
      });
    }
  }
  
  void _filterUsers(String query) {
    if (_searchDebounceTimer?.isActive ?? false) {
      _searchDebounceTimer!.cancel();
    }
    
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        if (query.isEmpty) {
          _filteredUsers = List<UserModel>.from(_users);
        } else {
          final lowercaseQuery = query.toLowerCase();
          _filteredUsers = _users.where((user) {
            final name = '${user.firstName ?? ''} ${user.lastName ?? ''}'.toLowerCase();
            final email = user.email?.toLowerCase() ?? '';
            
            return name.contains(lowercaseQuery) || email.contains(lowercaseQuery);
          }).toList();
        }
      });
    });
  }
  
  void _toggleUserSelection(String userId) {
    setState(() {
      if (_selectedUserIds.contains(userId)) {
        _selectedUserIds.remove(userId);
      } else {
        _selectedUserIds.add(userId);
      }
    });
  }
  
  /// Format the status for display
  String _formatStatus(String status) {
    switch (status) {
      case 'in_progress':
        return 'In Progress';
      default:
        return status.substring(0, 1).toUpperCase() + status.substring(1);
    }
  }
  
  Future<void> _saveShares() async {
    setState(() {
      _isSaving = true;
      _error = '';
    });
    
    try {
      // Get notification service
      final notificationService = context.read<NotificationService>();
      
      // Determine which users are being added (for notifications)
      final List<String> usersToAdd = [];
      for (final userId in _selectedUserIds) {
        if (!_sharedWithUserIds.contains(userId)) {
          usersToAdd.add(userId);
        }
      }
      
      // First, remove any users that are no longer selected
      final List<String> usersToRemove = [];
      
      for (final userId in _sharedWithUserIds) {
        if (!_selectedUserIds.contains(userId)) {
          usersToRemove.add(userId);
        }
      }
      
      // Remove users
      for (final userId in usersToRemove) {
        await _taskService.removeTaskShare(widget.task.id, userId);
      }
      
      // Add new users
      for (final userId in usersToAdd) {
        await _taskService.shareTaskWithUser(widget.task.id, userId);
        
        // Create a notification for the user
        await notificationService.createTaskSharedNotification(
          userId: userId,
          taskId: widget.task.id,
          taskTitle: widget.task.title,
        );
      }
      
      // Return success - check if still mounted before using context
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _error = 'Error saving shares: $e';
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Task'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveShares,
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Task details card
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: AppTheme.getPriorityColor(widget.task.priority).withAlpha(77), // 0.3 * 255 = ~77
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.task.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.getStatusColor(widget.task.status).withAlpha(51), // 0.2 * 255 = ~51
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _formatStatus(widget.task.status),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.getStatusColor(widget.task.status),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.task.description != null && widget.task.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.task.description!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  // Shared status
                  Row(
                    children: [
                      const Icon(
                        Icons.people,
                        size: 16,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Shared with ${_selectedUserIds.length} ${_selectedUserIds.length == 1 ? 'person' : 'people'}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search users',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterUsers('');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onChanged: _filterUsers,
            ),
          ),
          
          // Error message
          if (_error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _error,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          
          // Section header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Select users to share with',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          
          // User list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredUsers.isEmpty
                    ? const Center(
                        child: Text(
                          'No users found',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = _filteredUsers[index];
                          final isSelected = _selectedUserIds.contains(user.id);
                          
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: isSelected 
                                    ? AppTheme.primary.withAlpha(77) // 0.3 * 255 = ~77
                                    : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            elevation: isSelected ? 2 : 1,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                              leading: CircleAvatar(
                                backgroundColor: isSelected ? AppTheme.primary : Colors.grey.shade200,
                                child: Text(
                                  user.initials, // Use the initials getter from UserModelX
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                              title: Text(
                                user.displayName, // Use the displayName getter from UserModelX
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              subtitle: Text(user.email ?? ''), // Handle null email
                              trailing: Checkbox(
                                value: isSelected,
                                activeColor: AppTheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: (value) => _toggleUserSelection(user.id),
                              ),
                              onTap: () => _toggleUserSelection(user.id),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
