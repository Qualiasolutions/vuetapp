import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/utils/auth_helper.dart';

/// Screen for new user registration
class RegisterScreen extends ConsumerStatefulWidget {
  /// Callback for when the login button is pressed
  final VoidCallback onLoginPressed;

  /// Constructor
  const RegisterScreen({
    super.key,
    required this.onLoginPressed,
  });

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      
      // Use the new enhanced registration method with default values
      final result = await authService.signUpWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: 'User', // Default first name
        lastName: 'Account', // Default last name  
        accountType: 'personal', // Default to personal account
      );
      
      if (result.success) {
        // Handle success - show confirmation dialog
        if (mounted) {
          _showRegistrationSuccessDialog();
        }
      } else {
        // Handle specific error cases with user-friendly messages
        setState(() {
          _errorMessage = _getErrorMessage(result.error, result.message);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
        _isLoading = false;
      });
    }
  }

  String _getErrorMessage(String? errorCode, String? errorMessage) {
    // Return the specific error message from the AuthService if available
    if (errorMessage != null && errorMessage.isNotEmpty) {
      return errorMessage;
    }
    
    // Fallback to generic messages based on error codes
    switch (errorCode) {
      case 'email_already_exists':
        return 'An account with this email already exists. Please try logging in instead.';
      case 'weak_password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid_email':
        return 'Please enter a valid email address.';
      case 'invalid_data':
        return 'Invalid account information provided. Please check your details.';
      case 'database_error':
        return 'Database error. Please try again in a few moments.';
      case 'timeout_error':
        return 'Connection timeout. Please check your internet connection and try again.';
      case 'max_retries_exceeded':
        return 'Multiple connection attempts failed. Please try again in a few moments.';
      case 'auth_failed':
        return 'Failed to create account. Please try again.';
      default:
        return 'Registration failed. Please try again.';
    }
  }

  void _showRegistrationSuccessDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Successful'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your account has been created successfully.'),
                SizedBox(height: 8),
                Text(
                  'You can now log in with your credentials.',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Go to Login'),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onLoginPressed();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo or app name
                    const Icon(
                      Icons.person_add_outlined,
                      size: 80,
                      color: Colors.indigo,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Join Vuet App',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Error message
                    if (_errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
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
                    if (_errorMessage != null) const SizedBox(height: 16),
                    
                    // Email field
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!AuthHelper.isValidEmail(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Create a password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return AuthHelper.validatePassword(value ?? '');
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Confirm password field
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        hintText: 'Confirm your password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _handleRegister(),
                    ),
                    const SizedBox(height: 32),
                    
                    // Register button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegister,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Create Account'),
                    ),
                    const SizedBox(height: 16),
                    
                    // Login button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: _isLoading ? null : widget.onLoginPressed,
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
