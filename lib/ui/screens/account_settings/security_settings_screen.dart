import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/user_model.dart';
import 'package:vuet_app/providers/user_providers.dart';

/// Screen for managing security settings like password and privacy
class SecuritySettingsScreen extends ConsumerStatefulWidget {
  /// Constructor
  const SecuritySettingsScreen({super.key});

  @override
  ConsumerState<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends ConsumerState<SecuritySettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  
  // Privacy settings toggles
  bool _shareCalendar = false;
  bool _shareRoutines = false;
  bool _shareProfile = false;
  bool _allowNotifications = true;
  bool _allowEmailMarketing = false;
  
  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final currentUserModelAsync = ref.watch(currentUserModelProvider); // Use currentUserModelProvider
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security & Privacy'),
      ),
      body: currentUserModelAsync.when( // Use currentUserModelAsync
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('You need to be signed in to manage security settings.'),
            );
          }
          
          return _buildContent(context, user);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            'Error loading user data: ${error.toString()}',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
  
  Widget _buildContent(BuildContext context, UserModel user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Password Change Section
          _buildPasswordSection(),
          
          const SizedBox(height: 32),
          
          // Privacy Settings
          _buildPrivacySettings(),
          
          const SizedBox(height: 32),
          
          // Two-Factor Authentication (Placeholder)
          _buildTwoFactorSection(),
          
          const SizedBox(height: 32),
          
          // Data & Privacy Section
          _buildDataPrivacySection(),
        ],
      ),
    );
  }
  
  Widget _buildPasswordSection() {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.lock_outline),
                  const SizedBox(width: 8),
                  Text(
                    'Change Password',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade800),
                  ),
                ),
              
              TextFormField(
                controller: _currentPasswordController,
                obscureText: _obscureCurrentPassword,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrentPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureCurrentPassword = !_obscureCurrentPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  // Check for at least one uppercase letter
                  if (!value.contains(RegExp(r'[A-Z]'))) {
                    return 'Password must contain at least one uppercase letter';
                  }
                  // Check for at least one number
                  if (!value.contains(RegExp(r'[0-9]'))) {
                    return 'Password must contain at least one number';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _changePassword,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Update Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPrivacySettings() {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.privacy_tip_outlined),
                const SizedBox(width: 8),
                Text(
                  'Privacy Settings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildSwitchTile(
              title: 'Share Calendar with Friends',
              subtitle: 'Allow friends to see your calendar events',
              value: _shareCalendar,
              onChanged: (value) => setState(() => _shareCalendar = value),
            ),
            
            const Divider(),
            
            _buildSwitchTile(
              title: 'Share Routines',
              subtitle: 'Make your routines visible to friends',
              value: _shareRoutines,
              onChanged: (value) => setState(() => _shareRoutines = value),
            ),
            
            const Divider(),
            
            _buildSwitchTile(
              title: 'Public Profile',
              subtitle: 'Make your profile visible to other users',
              value: _shareProfile,
              onChanged: (value) => setState(() => _shareProfile = value),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTwoFactorSection() {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.verified_user_outlined),
                const SizedBox(width: 8),
                Text(
                  'Two-Factor Authentication',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            const Text('Add an extra layer of security to your account by enabling two-factor authentication.'),
            
            const SizedBox(height: 16),
            
            OutlinedButton(
              onPressed: () => _setup2FA(),
              child: const Text('Set Up Two-Factor Authentication'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDataPrivacySection() {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.data_usage_outlined),
                const SizedBox(width: 8),
                Text(
                  'Data & Privacy',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildSwitchTile(
              title: 'Allow Notifications',
              subtitle: 'Receive alerts and reminders',
              value: _allowNotifications,
              onChanged: (value) => setState(() => _allowNotifications = value),
            ),
            
            const Divider(),
            
            _buildSwitchTile(
              title: 'Email Marketing',
              subtitle: 'Receive promotional emails and newsletters',
              value: _allowEmailMarketing,
              onChanged: (value) => setState(() => _allowEmailMarketing = value),
            ),
            
            const Divider(),
            
            ListTile(
              title: const Text('Download My Data'),
              subtitle: const Text('Get a copy of all your data'),
              trailing: const Icon(Icons.download_outlined),
              onTap: () => _downloadData(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
  
  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userRepo = ref.read(userRepositoryProvider);
      final currentUser = ref.read(currentUserModelProvider).value; // Use currentUserModelProvider
      
      if (currentUser == null) {
        throw Exception('No user logged in');
      }
      
      await userRepo.updateUserPassword(
        userId: currentUser.id,
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully')),
        );
        
        // Reset form
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update password: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  void _setup2FA() {
    // Placeholder for 2FA setup
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Two-factor authentication setup will be implemented in a future update.'),
      ),
    );
  }
  
  void _downloadData() {
    // Placeholder for data download
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data download will be implemented in a future update.'),
      ),
    );
  }
}
