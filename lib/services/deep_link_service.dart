import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final _appLinks = AppLinks();
  StreamSubscription? _linkSubscription;
  final _supabase = Supabase.instance.client;
  GlobalKey<NavigatorState>? _navigatorKey;

  /// Initialize deep link listener
  Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    _navigatorKey = navigatorKey;
    print('🔗 Initializing deep link service...');

    // Handle deep links when app is already running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          _handleDeepLink(uri);
        }
      },
      onError: (err) {
        print('❌ Deep link error: $err');
      },
    );

    // Handle initial deep link (when app is opened via link)
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      print('❌ Error getting initial link: $e');
    }
  }

  /// Handle incoming deep link
  void _handleDeepLink(Uri uri) {
    print('🔗 Received deep link: $uri');
    
 
    
    if (uri.fragment.contains('access_token') || uri.fragment.contains('type=signup')) {
      print('✅ Email confirmation link detected!');
      print('✅ Navigating to confirmation screen...');
      
      // Extract token and type from URL
      final fragment = uri.fragment;
      String? token;
      String? type;
      
      if (fragment.isNotEmpty) {
        final params = Uri.splitQueryString(fragment);
        token = params['access_token'];
        type = params['type'];
      }
      
      // Navigate to confirmation screen
      _navigateToConfirmation(token, type);
    } else if (uri.fragment.contains('error')) {
      print('❌ Error in confirmation link');
      final error = uri.queryParameters['error_description'] ?? 'Unknown error';
      print('❌ Error: $error');
    }
  }

  /// Navigate to email confirmation screen
  void _navigateToConfirmation(String? token, String? type) {
    print('📱 Token: $token');
    print('📱 Type: $type');
    
    // Use global navigator key to navigate
    if (_navigatorKey?.currentState != null) {
      _navigatorKey!.currentState!.pushNamed(
        '/email-confirmation',
        arguments: {'token': token, 'type': type},
      );
      print('✅ Navigated to email confirmation screen');
    } else {
      print('❌ Navigator key not available');
    }
  }

  /// Dispose the listener
  void dispose() {
    _linkSubscription?.cancel();
  }
}