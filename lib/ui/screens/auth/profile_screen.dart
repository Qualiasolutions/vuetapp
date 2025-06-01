import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; // No longer needed here
// import 'package:vuet_app/config/supabase_config.dart'; // No longer needed here
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/services/storage_service.dart'; // For global storageServiceProvider
import 'package:vuet_app/utils/auth_helper.dart';

// Removed local providers
// final supabaseClientProvider = Provider<SupabaseClient>((ref) {
//   return SupabaseConfig.client;
// });
// 
// final storageServiceProvider = Provider<StorageService>((ref) {
//   final client = ref.watch(supabaseClientProvider);
//   return StorageService(client);
// });

/// Screen for viewing and editing user profile information
class ProfileScreen extends ConsumerStatefulWidget {
  /// Constructor
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isEditing = false;
  String? _errorMessage;
  Map<String, dynamic>? _profileData;
  File? _pickedImageFile; // To hold the picked image before upload

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider); // Changed
      final profileData = await authService.getUserProfile(); // Changed
      if (mounted) {
        setState(() {
          _profileData = profileData;
          if (profileData != null) {
            _displayNameController.text = profileData['display_name'] ?? '';
            _bioController.text = profileData['bio'] ?? '';
          } else {
            // Handle case where profile data is null (e.g., new user, error)
            _displayNameController.text = '';
            _bioController.text = '';
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load profile: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider); // Changed
      // Get the current user ID
      final userId = authService.currentUser?.id; // Changed
      if (userId == null) {
        throw Exception('User is not authenticated');
      }

      // Prepare data for update
      Map<String, dynamic> updateData = {
        'display_name': _displayNameController.text,
        'bio': _bioController.text,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // If a new image was picked, upload it and update avatar_url
      if (_pickedImageFile != null) {
        final storageService = ref.read(storageServiceProvider); // Uses global provider
        final imageUrl = await storageService.uploadAvatar(_pickedImageFile!);
        updateData['avatar_url'] = imageUrl;
        _pickedImageFile = null; // Clear picked image after successful upload attempt
      }
      
      // Update the profile in Supabase
      await authService.supabase.from('profiles').update(updateData).eq('id', userId); // Changed

      // Reload the profile to get the latest data
      // _loadUserProfile itself handles mounted checks for its setStates
      await _loadUserProfile(); 
      
      if (mounted) {
        // Exit editing mode
        setState(() {
          _isEditing = false;
          _isSaving = false;
        });

        // Check if still mounted before using BuildContext
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = AuthHelper.getErrorMessage(e);
          _isSaving = false;
          // If image upload failed but other fields might have been prepared,
          // you might want to clear _pickedImageFile or handle it.
        });
      }
    }
  }
  
  Future<void> _pickAndUploadAvatar() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      setState(() {
        _pickedImageFile = File(image.path);
        // Optionally, immediately try to save/upload, or wait for explicit save action
        // For now, we'll just set the picked file and let _saveProfile handle the upload.
        // To show a preview before saving:
        // _profileData?['avatar_url'] = null; // Clear network image to show local file if desired
      });
      // If in editing mode, can directly call save to upload image and update profile
      if (_isEditing) {
        // Trigger save to upload the new avatar and other changes
        _saveProfile();
      } else {
        // If not in editing mode, perhaps enable it and then save?
        // Or provide a separate "Upload Avatar" button that also triggers save.
        // For simplicity, let's assume user enters edit mode first or this button also saves.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Avatar selected. Save profile to apply changes.')),
          );
        }
      }
    }
  }

  Future<void> _signOut() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final authService = ref.read(authServiceProvider); // Changed
      await authService.signOut(); // Changed
      // The AuthWrapper will handle navigation after sign out
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = AuthHelper.getErrorMessage(e);
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _confirmSignOut() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _isSaving ? null : _saveProfile,
              tooltip: 'Save',
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
              tooltip: 'Edit',
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _confirmSignOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Error message
                if (_errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade800),
                    ),
                  ),

                // Profile header
                Center(
                  child: Column(
                    children: [
                      // Profile avatar with edit button
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: _pickedImageFile != null
                                ? FileImage(_pickedImageFile!) as ImageProvider
                                : (_profileData?['avatar_url'] != null
                                    ? NetworkImage(_profileData!['avatar_url'])
                                    : null),
                            child: _pickedImageFile == null && _profileData?['avatar_url'] == null
                                ? const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                          if (_isEditing) // Show edit button only in editing mode
                            Material(
                              color: Colors.white,
                              shape: const CircleBorder(),
                              elevation: 2,
                              child: InkWell(
                                onTap: _pickAndUploadAvatar,
                                customBorder: const CircleBorder(),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(Icons.edit, size: 20, color: Colors.blue),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Username/Email
                      Text(
                        ref.read(authServiceProvider).currentUser?.email ?? 'User',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      // User ID for reference
                      Text(
                        'ID: ${ref.read(authServiceProvider).currentUser?.id.substring(0, 8) ?? 'Unknown'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Profile form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Profile Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Display name field
                      TextFormField(
                        controller: _displayNameController,
                        decoration: const InputDecoration(
                          labelText: 'Display Name',
                          hintText: 'Enter your display name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        enabled: _isEditing,
                        validator: (value) {
                          if (_isEditing && (value == null || value.isEmpty)) {
                            return 'Please enter your display name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Bio field
                      TextFormField(
                        controller: _bioController,
                        decoration: const InputDecoration(
                          labelText: 'Bio',
                          hintText: 'Tell us about yourself',
                          prefixIcon: Icon(Icons.info_outline),
                        ),
                        enabled: _isEditing,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Account settings
                const Text(
                  'Account Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Change password option
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Implement password change flow
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password change functionality coming soon'),
                      ),
                    );
                  },
                ),
                
                // Delete account option
                ListTile(
                  leading: Icon(Icons.delete_outline, color: Colors.red.shade400),
                  title: Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red.shade400),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Implement account deletion flow
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account deletion functionality coming soon'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
