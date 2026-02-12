import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmailConfirmationScreen extends StatefulWidget {
  final String? token;
  final String? type;

  const EmailConfirmationScreen({
    super.key,
    this.token,
    this.type,
  });

  @override
  State<EmailConfirmationScreen> createState() => _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends State<EmailConfirmationScreen> {
  bool _isLoading = false;
  bool _isConfirmed = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Auto-verify if we already have the token from deep link
    if (widget.token != null) {
      _verifyEmail();
    }
  }

  Future<void> _verifyEmail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // The token is automatically handled by Supabase when the deep link opens
      // We just need to check if the user is now authenticated
      final user = Supabase.instance.client.auth.currentUser;
      
      if (user != null && user.emailConfirmedAt != null) {
        setState(() {
          _isConfirmed = true;
          _isLoading = false;
        });
      } else {
        // Wait a moment for Supabase to process
        await Future.delayed(const Duration(seconds: 2));
        final updatedUser = Supabase.instance.client.auth.currentUser;
        
        if (updatedUser != null && updatedUser.emailConfirmedAt != null) {
          setState(() {
            _isConfirmed = true;
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Email verification is pending. Please try again.';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C4A7C),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or Icon
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isConfirmed
                        ? Icons.check_circle
                        : _errorMessage != null
                            ? Icons.error_outline
                            : Icons.email_outlined,
                    size: 80,
                    color: _isConfirmed
                        ? Colors.green
                        : _errorMessage != null
                            ? Colors.red
                            : const Color(0xFF2C4A7C),
                  ),
                ),

                const SizedBox(height: 40),

                // Main Card
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Title
                      Text(
                        _isConfirmed
                            ? 'Email Verified!'
                            : _errorMessage != null
                                ? 'Verification Failed'
                                : 'Verify Your Email',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C4A7C),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      // Message
                      Text(
                        _isConfirmed
                            ? 'Your email has been successfully verified. You can now sign in to your account.'
                            : _errorMessage != null
                                ? _errorMessage!
                                : 'Click the button below to verify your email address and activate your account.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // Loading or Action Button
                      if (_isLoading)
                        const CircularProgressIndicator(
                          color: Color(0xFF2C4A7C),
                        )
                      else if (_isConfirmed)
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to sign in page
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/signin',
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.login, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Go to Sign In',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (_errorMessage != null)
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: _verifyEmail,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2C4A7C),
                                foregroundColor: const Color(0xFFFFC107),
                                minimumSize: const Size(double.infinity, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/signin',
                                  (route) => false,
                                );
                              },
                              child: const Text('Back to Sign In'),
                            ),
                          ],
                        )
                      else
                        ElevatedButton(
                          onPressed: _verifyEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2C4A7C),
                            foregroundColor: const Color(0xFFFFC107),
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.verified_user, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Verify Email',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Help text
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/signin',
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Back to Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}