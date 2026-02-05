import 'package:flutter/material.dart';
import 'screens/SignIn.dart';  // Change this import

void main() {
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
      home: const SignIn(),  
    );
  }
}