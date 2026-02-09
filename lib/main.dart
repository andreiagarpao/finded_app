import 'package:flutter/material.dart';
import 'screens/SignIn.dart';
import 'screens/home_screen.dart'; // Your main FindEd home
import 'screens/cvsu_application_form.dart';
import 'screens/admindash.dart';
import 'storage/local_storage.dart';
import 'services/studinquireserve.dart'; // ADD THIS IMPORT

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  
  // ADD THIS: Load saved inquiries from storage
  await StudentInquiryService().loadInquiries();
  
  runApp(const FindEdApp());
}

class FindEdApp extends StatelessWidget {
  const FindEdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FindEd',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2C4A7C),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2C4A7C),
          primary: const Color(0xFF2C4A7C),
        ),
        useMaterial3: true,
      ),
      // Define named routes for easy navigation
      home: const AuthCheck(), // Check login status first
      routes: {
        '/signin': (context) => const SignIn(),
        '/home': (context) => const HomeScreen(),
        '/application': (context) => const CvsuApplicationForm(),
        '/admin': (context) => const AdminDashboard(selectedSchool: 'CVSU'),
      },
    );
  }
}

// Widget to check authentication status
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        // Show loading while checking
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Check if user is logged in
        bool isLoggedIn = snapshot.data ?? false;
        
        if (isLoggedIn) {
          // Check if admin or regular user
          bool isAdmin = LocalStorageService.getBool('isAdmin') ?? false;
          String? selectedSchool = LocalStorageService.getString('selectedSchool');
          
          if (isAdmin && selectedSchool != null) {
            return AdminDashboard(selectedSchool: selectedSchool);
          } else {
            return const HomeScreen();
          }
        } else {
          return const SignIn();
        }
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    return LocalStorageService.getBool('isLoggedIn') ?? false;
  }
}