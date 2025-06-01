import 'package:flutter/foundation.dart';
import 'package:vuet_app/config/supabase_config.dart';

/// Service for handling user profile details, preferences, and subscription status
class UserDetailsService extends ChangeNotifier {
  final _supabase = SupabaseConfig.client;
  
  // Cached user details
  Map<String, dynamic>? _userDetails;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  Map<String, dynamic>? get userDetails => _userDetails;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Premium status - for now, we'll simulate this based on username or email
  // In a real app, this would use a paid_tier field in the profiles table
  bool get isPremium {
    // No user details yet
    if (_userDetails == null) return false;
    
    // Check if user has premium tier in their profile
    if (_userDetails!.containsKey('paid_tier') && 
        _userDetails!['paid_tier'] != null &&
        _userDetails!['paid_tier'] != 'free') {
      return true;
    }
    
    // For development: Check if the email contains 'premium'
    final user = _supabase.auth.currentUser;
    if (user != null) {
      final email = user.email?.toLowerCase() ?? '';
      return email.contains('premium') || email.contains('paid');
    }
    
    return false;
  }
  
  // Fetch current user details from the profiles table
  Future<Map<String, dynamic>?> fetchUserDetails() async {
    if (_supabase.auth.currentUser == null) {
      _error = 'No authenticated user';
      notifyListeners();
      return null;
    }
    
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final userId = _supabase.auth.currentUser!.id;
      
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      
      _userDetails = response;
      _isLoading = false;
      notifyListeners();
      return _userDetails;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
  
  // Update a specific field in the user's profile
  Future<bool> updateUserField(String field, dynamic value) async {
    if (_supabase.auth.currentUser == null) {
      _error = 'No authenticated user';
      notifyListeners();
      return false;
    }
    
    try {
      final userId = _supabase.auth.currentUser!.id;
      
      await _supabase
          .from('profiles')
          .update({field: value})
          .eq('id', userId);
      
      // Update the cached user details
      if (_userDetails != null) {
        _userDetails![field] = value;
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Check if user has premium features enabled
  Future<bool> checkPremiumStatus() async {
    if (_userDetails == null) {
      await fetchUserDetails();
    }
    return isPremium;
  }
  
  // Clear cache when user logs out
  void clearCache() {
    _userDetails = null;
    _error = null;
    notifyListeners();
  }
}
