import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_client.dart';

class AuthService {
  final SupabaseClient _client =
      SupabaseClientManager.client;

  // SIGN UP (FULL NAME + EMAIL + PASSWORD)
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw Exception("Signup failed");
    }

    // INSERT INTO profiles TABLE
    await _client.from('profiles').insert({
      'id': user.id,
      'full_name': fullName,
      'email': email,
    });
  }

  // LOGIN
  Future<AuthResponse> login(
      String email, String password) {
    return _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // LOGOUT
  Future<void> logout() {
    return _client.auth.signOut();
  }

  User? get currentUser =>
      _client.auth.currentUser;
}
