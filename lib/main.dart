import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/deep_link_service.dart';
import 'screens/SignIn.dart';
import 'screens/home_screen.dart';
import 'screens/cvsu_application_form.dart';
import 'screens/admindash.dart';
import 'screens/email_confirmation_screen.dart';
import 'storage/local_storage.dart';
import 'services/studinquireserve.dart';

// Global navigator key for deep linking
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Initialize Supabase
 await Supabase.initialize(
    url: 'https://qfdsyfmdkncneffdwxtn.supabase.co',
    anonKey: 'sb_publishable_sacV61z5YXtE_57aWBa7kQ_yzEEWvxF',
  );
  // 🔹 Initialize Deep Link Service for email confirmation
  await DeepLinkService().initialize(navigatorKey);

  // 🔹 Your existing services
  await LocalStorageService.init();
  await StudentInquiryService().loadInquiries();

  runApp(const FindEdApp());
}

class FindEdApp extends StatelessWidget {
  const FindEdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Add global navigator key
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
      home: const AuthCheck(),
      routes: {
        '/signin': (context) => const SignIn(),
        '/home': (context) => const HomeScreen(),
        '/application': (context) => const CvsuApplicationForm(),
        '/admin': (context) => const AdminDashboard(selectedSchool: 'CVSU'),
        '/email-confirmation': (context) => const EmailConfirmationScreen(),
      },
    );
  }
}

// 🔐 Authentication checker
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        bool isLoggedIn = snapshot.data ?? false;

        if (isLoggedIn) {
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