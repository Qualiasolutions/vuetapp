import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vuet_app/models/user_model.dart';
import 'package:vuet_app/providers/user_providers.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// Screen to edit account details such as name, profile picture, DOB, etc.
class AccountDetailsScreen extends ConsumerStatefulWidget {
  /// Constructor
  const AccountDetailsScreen({super.key});

  @override
  ConsumerState<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends ConsumerState<AccountDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  
  DateTime? _dateOfBirth;
  String? _selectedColor;
  File? _selectedImage;
  bool _isLoading = false;
  String? _errorMessage;
  
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserDetails() async {
    final currentUser = ref.read(currentUserModelProvider).value; // Use currentUserModelProvider
    if (currentUser != null) {
      setState(() {
        _firstNameController.text = currentUser.firstName ?? '';
        _lastNameController.text = currentUser.lastName ?? '';
        _dateOfBirth = currentUser.dateOfBirth;
        _selectedColor = currentUser.memberColor;
      });
    }
  }

  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final initialDate = _dateOfBirth ?? DateTime(2000);
    final firstDate = DateTime(1900);
    final lastDate = DateTime.now();
    
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    
    if (selectedDate != null) {
      setState(() {
        _dateOfBirth = selectedDate;
      });
    }
  }

  Future<void> _selectColor() async {
    Color pickerColor = _selectedColor != null 
        ? Color(int.parse('0xFF${_selectedColor!.substring(1)}')) 
        : Colors.blue;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select your color'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (color) {
                  pickerColor = color;
                },
                enableAlpha: false,
                labelTypes: const [],  // Empty list instead of showLabel: true
              ),
            ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                // Convert Color to hex string using non-deprecated methods
                _selectedColor = '#${(pickerColor.r * 255.0).round().toRadixString(16).padLeft(2, '0')}${(pickerColor.g * 255.0).round().toRadixString(16).padLeft(2, '0')}${(pickerColor.b * 255.0).round().toRadixString(16).padLeft(2, '0')}';
              });
              Navigator.of(context).pop();
            },
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveChanges() async {
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

      // If there's a selected image, upload it first
      if (_selectedImage != null) {
        await userRepo.uploadProfileImage(
          userId: currentUser.id, 
          imageFile: _selectedImage!,
        );
      }

      // Update profile information
      await userRepo.updateUserProfile(
        userId: currentUser.id,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        dateOfBirth: _dateOfBirth,
        memberColor: _selectedColor,
      );

      // Refresh the user data
      // ignore: unused_result
      ref.refresh(currentUserModelProvider); // Refresh currentUserModelProvider

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.of(context).pop(); // Go back to settings menu
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update profile: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserModelAsync = ref.watch(currentUserModelProvider); // Use currentUserModelProvider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveChanges,
              tooltip: 'Save Changes',
            ),
        ],
      ),
      body: currentUserModelAsync.when( // Use currentUserModelAsync
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('You need to be signed in to edit your details.'),
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
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
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

          // Profile Image
          Center(
            child: GestureDetector(
              onTap: _selectImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!) as ImageProvider<Object>?
                        : (user.avatarUrl != null
                            ? NetworkImage(user.avatarUrl!) as ImageProvider<Object>?
                            : null),
                    child: _getProfileImageChild(user),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // First Name
          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              hintText: 'Enter your first name',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'First name is required';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Last Name
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              hintText: 'Enter your last name',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Last name is required';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Date of Birth
          ListTile(
            title: const Text('Date of Birth'),
            subtitle: Text(
              _dateOfBirth != null
                  ? DateFormat.yMMMMd().format(_dateOfBirth!)
                  : 'Not set',
            ),
            leading: const Icon(Icons.cake_outlined),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => _selectDateOfBirth(context),
          ),
          
          const SizedBox(height: 16),
          
          // Member Color
          ListTile(
            title: const Text('Member Color'),
            subtitle: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: _selectedColor != null
                        ? Color(int.parse('0xFF${_selectedColor!.substring(1)}'))
                        : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(_selectedColor ?? 'Not set'),
              ],
            ),
            leading: const Icon(Icons.color_lens_outlined),
            trailing: const Icon(Icons.edit),
            onTap: _selectColor,
          ),
          
          const SizedBox(height: 32),
          
          // Save Button
          ElevatedButton(
            onPressed: _isLoading ? null : _saveChanges,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  Widget? _getProfileImageChild(UserModel user) {
    // If we have a selected image or user avatar, don't show an icon
    if (_selectedImage != null || user.avatarUrl != null) {
      return null;
    }
    
    // If we don't have an image, show a person icon
    return const Icon(
      Icons.person,
      size: 60,
      color: Colors.grey,
    );
  }
}
