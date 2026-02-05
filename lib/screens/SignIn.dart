import 'package:flutter/material.dart';
import 'SignUp.dart';
import 'home_screen.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          children: [
            const Text("FindEd Cavite",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E))),
            const SizedBox(height: 10),
            const Text("Sign in to continue",
                style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 50),

            _buildField("Email", Icons.email_outlined),
            _buildField("Password", Icons.lock_outline, isPass: true),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("Sign In",
                  style: TextStyle(color: Color(0xFFFFD700), fontSize: 18)),
            ),
            const SizedBox(height: 15),
            OutlinedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                side: const BorderSide(color: Color(0xFF1A237E)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("Continue as Guest",
                  style: TextStyle(color: Color(0xFF1A237E))),
            ),

            const SizedBox(height: 30),
            GestureDetector(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const SignUp())),
              child: const Text("Don't have an account? Create one",
                  style: TextStyle(
                      color: Colors.grey, decoration: TextDecoration.underline)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String hint, IconData icon, {bool isPass = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        obscureText: isPass,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF1A237E)),
          filled: true,
          fillColor: const Color(0xFFE3F2FD).withOpacity(0.5),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFFFD700), width: 2),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}