import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _supabase = Supabase.instance.client;

  // Sign in with email and password
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        print('✅ Login successful: ${response.user!.email}');
        
        // You can extract metadata to determine which school admin this is
        // For now, we'll check the email domain or use user metadata
        String? school = _determineSchoolFromEmail(response.user!.email ?? '');
        
        return {
          'success': true,
          'user': response.user,
          'school': school,
        };
      } else {
        return {
          'success': false,
          'error': 'Login failed',
        };
      }
    } on AuthException catch (e) {
      print('❌ Auth error: ${e.message}');
      return {
        'success': false,
        'error': e.message,
      };
    } catch (e) {
      print('❌ Login error: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred',
      };
    }
  }

  // Sign up (create new account)
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    String? school,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'school': school, 
        },
      );

      if (response.user != null) {
        print('✅ Sign up successful: ${response.user!.email}');
        return {
          'success': true,
          'user': response.user,
          'message': 'Please check your email to verify your account',
        };
      } else {
        return {
          'success': false,
          'error': 'Sign up failed',
        };
      }
    } on AuthException catch (e) {
      print('❌ Auth error: ${e.message}');
      return {
        'success': false,
        'error': e.message,
      };
    } catch (e) {
      print('❌ Sign up error: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred',
      };
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      print('✅ Signed out successfully');
    } catch (e) {
      print('❌ Sign out error: $e');
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _supabase.auth.currentUser != null;
  }

  // Determine school from email (helper function)
  String? _determineSchoolFromEmail(String email) {
    // You can customize this logic based on your needs
    // Option 1: Check email domain
    if (email.contains('@cvsu.edu') || email.toLowerCase().contains('cvsu')) {
      return 'CVSU';
    } else if (email.contains('@dlshsi.edu') || email.toLowerCase().contains('dlshsi')) {
      return 'DLSHSI';
    }
    
    // Option 2: Get from user metadata (if you set it during signup)
    final user = _supabase.auth.currentUser;
    if (user?.userMetadata?['school'] != null) {
      return user!.userMetadata!['school'] as String;
    }
    
    // Default: could prompt user to select or return null
    return null;
  }

  // Reset password
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return {
        'success': true,
        'message': 'Password reset email sent',
      };
    } on AuthException catch (e) {
      return {
        'success': false,
        'error': e.message,
      };
    }
  }
}