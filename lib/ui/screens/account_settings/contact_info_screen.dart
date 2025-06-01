import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/user_model.dart';
import 'package:vuet_app/providers/user_providers.dart';
import 'package:email_validator/email_validator.dart';

/// Screen for editing contact information like email and phone number
class ContactInfoScreen extends ConsumerStatefulWidget {
  /// Constructor
  const ContactInfoScreen({super.key});

  @override
  ConsumerState<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends ConsumerState<ContactInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isChangingEmail = true;
  
  @override
  void initState() {
    super.initState();
    _loadUserContact();
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  
  Future<void> _loadUserContact() async {
    final currentUser = ref.read(currentUserModelProvider).value; // Use currentUserModelProvider
    if (currentUser != null) {
      setState(() {
        _emailController.text = currentUser.email ?? '';
        _phoneController.text = currentUser.phoneNumber ?? '';
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final currentUserModelAsync = ref.watch(currentUserModelProvider); // Use currentUserModelProvider
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Information'),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _attemptSave,
              tooltip: 'Save',
            ),
        ],
      ),
      body: currentUserModelAsync.when( // Use currentUserModelAsync
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('You need to be signed in to update contact information.'),
            );
          }
          
          return _buildForm(context, user);
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
  
  Widget _buildForm(BuildContext context, UserModel user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_errorMessage != null)
              Container(
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
              
            // Current Contact Info
            Card(
              margin: const EdgeInsets.only(bottom: 24),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Contact Information',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        const Icon(Icons.email_outlined, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            user.email ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    
                    if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined, size: 18, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              user.phoneNumber!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Toggle between email and phone update
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => setState(() => _isChangingEmail = true),
                    style: TextButton.styleFrom(
                      backgroundColor: _isChangingEmail ? Colors.blue.shade50 : null,
                    ),
                    child: const Text('Update Email'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () => setState(() => _isChangingEmail = false),
                    style: TextButton.styleFrom(
                      backgroundColor: !_isChangingEmail ? Colors.blue.shade50 : null,
                    ),
                    child: const Text('Update Phone'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Form for updating contact info
            if (_isChangingEmail) ...[
              const Text(
                'Update Email Address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'New Email Address',
                  hintText: 'example@email.com',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }
                  if (!EmailValidator.validate(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              const Text(
                'Note: You will receive a verification email and need to confirm the change.',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ] else ...[
              const Text(
                'Update Phone Number',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'New Phone Number',
                  hintText: '+123456789',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // Phone can be empty
                  }
                  // Simple validation - real app should have proper phone validation
                  if (value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              const Text(
                'Note: You will receive an SMS code to verify this number.',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ],
            
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _attemptSave,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isChangingEmail ? 'Update Email' : 'Update Phone Number'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _attemptSave() async {
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
      
      // In a real implementation, this would trigger verification first
      // For now we'll simulate a successful update
      await userRepo.updateUserContact(
        userId: currentUser.id,
        email: _isChangingEmail ? _emailController.text : null,
        phoneNumber: !_isChangingEmail ? _phoneController.text : null,
      );
      
      // Refresh the user data
      ref.invalidate(currentUserModelProvider); // Invalidate currentUserModelProvider
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isChangingEmail
                ? 'Email update initiated. Please check your inbox for verification.'
                : 'Phone number updated successfully.'),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update contact info: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
