import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../service/auth_service.dart';
import '../screen/login_screen.dart';
import '../screen/home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client
          .auth.onAuthStateChange,
      builder: (context, snapshot) {
        final user = AuthService().currentUser;

        if (user != null) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
