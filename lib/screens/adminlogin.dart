import 'package:flutter/material.dart';
import 'admindash.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;
  bool _isPasswordVisible = false;

  // Text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Selected school
  String _selectedSchool = 'CVSU';

  // Available schools
  final List<String> _schools = ['CVSU', 'DLSHSI'];

  // Mock admin credentials for each school
  final Map<String, Map<String, String>> _schoolAdminCredentials = {
    'CVSU': {
      'email': 'admin@cvsu.edu.ph',
      'password': 'cvsu123',
    },
    'DLSHSI': {
      'email': 'admin@dlshsi.edu.ph',
      'password': 'dlshsi123',
    },
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeOut),
    );

    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleAdminLogin() {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog("Please enter both email and password");
      return;
    }

    // Get credentials for selected school
    String correctEmail = _schoolAdminCredentials[_selectedSchool]!['email']!;
    String correctPassword = _schoolAdminCredentials[_selectedSchool]!['password']!;

    if (email == correctEmail && password == correctPassword) {
      // Successful admin login - Navigate to dashboard with school info
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminDashboard(selectedSchool: _selectedSchool),
        ),
      );
    } else {
      // Failed login
      _showErrorDialog(
        "Invalid admin credentials for $_selectedSchool!\n\n"
        "Use:\nEmail: $correctEmail\nPassword: $correctPassword"
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Failed"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF2C4A7C),
      body: Stack(
        children: [
          // Image background
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Back button
          SafeArea(
            child: Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
          
          // Centered content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: _fadeAnimation != null && _slideAnimation != null
                  ? FadeTransition(
                      opacity: _fadeAnimation!,
                      child: SlideTransition(
                        position: _slideAnimation!,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Header text
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Column(
                                children: [
                                  Text(
                                    "FindEd Cavite",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Administrator Access",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            
                            // White container
                            _buildContentContainer(context),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Admin badge/icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFC107).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              size: 40,
              color: Color(0xFF2C4A7C),
            ),
          ),
          
          const SizedBox(height: 20),

          // School Selector Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFECEFF1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSchool,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF2C4A7C)),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C4A7C),
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedSchool = newValue;
                      // Clear fields when school changes
                      _emailController.clear();
                      _passwordController.clear();
                    });
                  }
                },
                items: _schools.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.school,
                          size: 20,
                          color: Color(0xFF2C4A7C),
                        ),
                        const SizedBox(width: 8),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Input Fields
          _buildField("Admin Email", Icons.email_outlined, controller: _emailController),
          const SizedBox(height: 12),
          _buildField("Password", Icons.lock_outline, isPass: true, controller: _passwordController),

          const SizedBox(height: 10),

          // Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                // Handle forgot password
              },
              child: const Text(
                "Forgot Password?",
                style: TextStyle(
                  color: Color(0xFF2C4A7C),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Sign In Button
          ElevatedButton(
            onPressed: _handleAdminLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C4A7C),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              "Sign In as $_selectedSchool Admin",
              style: const TextStyle(
                color: Color(0xFFFFC107),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Back to User Login
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text(
              "Back to User Login",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String hint, IconData icon, {bool isPass = false, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      obscureText: isPass ? !_isPasswordVisible : false,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFB0BEC5),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF2C4A7C), size: 22),
        suffixIcon: isPass
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible 
                    ? Icons.visibility_outlined 
                    : Icons.visibility_off_outlined,
                  color: const Color(0xFF2C4A7C),
                  size: 22,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFECEFF1),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFFC107), width: 2),
          
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}