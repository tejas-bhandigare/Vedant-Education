import 'package:flutter/material.dart';
import 'dart:async';
import '../auth/auth_gate.dart';
import 'home.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer to navigate to Home Page after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displaying the Vedant Education Logo
            Image.asset(
              'assets/image/vedant_logo.jpeg',
              width: 250,
            ),
            const SizedBox(height: 30),
            // Loading indicator matching your brand blue
            const CircularProgressIndicator(
              color: Color(0xFF324DF0),
            ),
          ],
        ),
      ),
    );
  }
}