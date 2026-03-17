import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vedant_education_app/screen/admin.dart';
import '../service/auth_service.dart';
import 'signup_screen.dart';

const String _kAdminEmail = "admin@vedant.com";
const String _kAdminPassword = "Admin@123";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and password required")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // ── ADMIN LOGIN ──────────────────────────────────────
      if (email == _kAdminEmail && password == _kAdminPassword) {
        // ✅ Clear any existing Supabase session before going to admin
        await Supabase.instance.client.auth.signOut();

        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AdminPage()),
              (route) => false,
        );
        return;
      }

      // ── CUSTOMER LOGIN ───────────────────────────────────
      // ✅ Clear any stale session before logging in fresh
      await Supabase.instance.client.auth.signOut();
      await AuthService().login(email, password);
      // AuthGate will redirect automatically after login

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Welcome Back",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Login to your account",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF070707)),
              ),

              const SizedBox(height: 40),

              // ── EMAIL FIELD ──────────────────────────────
              buildField("Email", Icons.email, controller: _emailController),

              const SizedBox(height: 16),

              // ── PASSWORD FIELD WITH TOGGLE ───────────────
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── LOGIN BUTTON ─────────────────────────────
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xF4448AFF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account ? "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(
      String hint,
      IconData icon, {
        bool isPassword = false,
        required TextEditingController controller,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}














// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:vedant_education_app/screen/admin.dart';
// import '../service/auth_service.dart';
// import 'signup_screen.dart';
//
// const String _kAdminEmail = "admin@vedant.com";
// const String _kAdminPassword = "Admin@123";
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//
//   bool _isLoading = false;
//   bool _obscurePassword = true;
//
//   Future<void> _login() async {
//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();
//
//     if (email.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Email and password required")),
//       );
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//
//     // ── CUSTOMER LOGIN ───────────────────────────────────
// // ✅ Force clear any stale session before logging in
//     await Supabase.instance.client.auth.signOut();
//
//     await AuthService().login(email, password);
//
//     try {
//       try {
//         // ── ADMIN LOGIN ──────────────────────────────────────
//         if (email == _kAdminEmail && password == _kAdminPassword) {
//           // ✅ Clear any Supabase session before going to admin
//           await Supabase.instance.client.auth.signOut();
//
//           if (!mounted) return;
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (_) => const AdminPage()),
//                 (route) => false,
//           );
//           return;
//         }
//
//         // ── CUSTOMER LOGIN ───────────────────────────────────
//         // ✅ Clear any stale session first
//         await Supabase.instance.client.auth.signOut();
//         await AuthService().login(email, password);
//       } catch (e) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(e.toString())),
//         );
//       } finally {
//         if (mounted) setState(() => _isLoading = false);
//       }
//     }
//     //     // ── ADMIN LOGIN ──────────────────────────────────────
//     //
//     //     if (email == _kAdminEmail && password == _kAdminPassword) {
//     //       // ✅ Sign out any existing Supabase session first
//     //       await AuthService().logout();
//     //
//     //       if (!mounted) return;
//     //       Navigator.pushAndRemoveUntil(
//     //         context,
//     //         MaterialPageRoute(builder: (_) => const AdminPage()),
//     //             (route) => false,
//     //       );
//     //       return;
//     //     }
//     //
//     //     // if (email == _kAdminEmail && password == _kAdminPassword) {
//     //     //   if (!mounted) return;
//     //     //   Navigator.pushAndRemoveUntil(
//     //     //     context,
//     //     //     MaterialPageRoute(builder: (_) => const AdminPage()),
//     //     //         (route) => false,
//     //     //   );
//     //     //   return;
//     //     // }
//     //
//     //     // ── CUSTOMER LOGIN ───────────────────────────────────
//     //     await AuthService().login(email, password);
//     //     // AuthGate will redirect automatically after login
//     //
//     //   } catch (e) {
//     //     if (!mounted) return;
//     //     ScaffoldMessenger.of(context).showSnackBar(
//     //       SnackBar(content: Text(e.toString())),
//     //     );
//     //   } finally {
//     //     if (mounted) setState(() => _isLoading = false);
//     //   }
//     // }
//
//     @override
//     void dispose() {
//       _emailController.dispose();
//       _passwordController.dispose();
//       super.dispose();
//     }
//
//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         backgroundColor: const Color(0xFFF9FAFB),
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const Text(
//                   "Welcome Back",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF111827),
//                   ),
//                 ),
//
//                 const SizedBox(height: 8),
//
//                 const Text(
//                   "Login to your account",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Color(0xFF070707)),
//                 ),
//
//                 const SizedBox(height: 40),
//
//                 // ── EMAIL FIELD ──────────────────────────────
//                 buildField("Email", Icons.email, controller: _emailController),
//
//                 const SizedBox(height: 16),
//
//                 // ── PASSWORD FIELD WITH TOGGLE ───────────────
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: _obscurePassword,
//                   decoration: InputDecoration(
//                     hintText: "Password",
//                     prefixIcon: const Icon(Icons.lock),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscurePassword
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                       ),
//                       onPressed: () =>
//                           setState(() => _obscurePassword = !_obscurePassword),
//                     ),
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 24),
//
//                 // ── LOGIN BUTTON ─────────────────────────────
//                 ElevatedButton(
//                   onPressed: _isLoading ? null : _login,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xF4448AFF),
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: _isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text(
//                     "Login",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text("Don't have an account ? "),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const SignUpScreen(),
//                           ),
//                         );
//                       },
//                       child: const Text("Sign Up"),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//
//     Widget buildField(String hint,
//         IconData icon, {
//           bool isPassword = false,
//           required TextEditingController controller,
//         }) {
//       return TextFormField(
//         controller: controller,
//         obscureText: isPassword,
//         decoration: InputDecoration(
//           hintText: hint,
//           prefixIcon: Icon(icon),
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       );
//     }
//   }
//
// }







// import 'package:flutter/material.dart';
// import 'package:vedant_education_app/screen/admin.dart';
// import '../service/auth_service.dart';
// import 'signup_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//
//   bool _isLoading = false;
//
//   Future<void> _login() async {
//     if (_emailController.text.isEmpty ||
//         _passwordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Email and password required")),
//       );
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     try {
//
//       String email = _emailController.text.trim();
//       String password = _passwordController.text.trim();
//
//       /// ADMIN LOGIN
//       if (email == "admin@vedant.com" && password == "Admin@123") {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const AdminPage()),
//         );
//         return;
//       }
//       await AuthService().login(
//         _emailController.text.trim(),
//         _passwordController.text.trim(),
//       );
//       // AuthGate will redirect automatically
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString())),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FAFB),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//
//               const Text(
//                 "Welcome Back",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF111827),
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               const Text(
//                 "Login to your account",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Color(0xFF070707)),
//               ),
//
//               const SizedBox(height: 40),
//
//               buildField(
//                 "Email",
//                 Icons.email,
//                 controller: _emailController,
//               ),
//
//               const SizedBox(height: 16),
//
//               buildField(
//                 "Password",
//                 Icons.lock,
//                 isPassword: true,
//                 controller: _passwordController,
//               ),
//
//               const SizedBox(height: 24),
//
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _login,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xF4448AFF),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text("Login",
//                   style: TextStyle(color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,),),
//               ),
//
//               const SizedBox(height: 16),
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Don’t have an account ? "),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => const SignUpScreen(),
//                         ),
//                       );
//                     },
//                     child: const Text("Sign Up"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildField(
//       String hint,
//       IconData icon, {
//         bool isPassword = false,
//         required TextEditingController controller,
//       }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: isPassword,
//       decoration: InputDecoration(
//         hintText: hint,
//         prefixIcon: Icon(icon),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }
//
//
//
//





// import 'package:flutter/material.dart';
// import 'package:vedant_education_app/screen/admin.dart';
// import '../service/auth_service.dart';
// import 'signup_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//
//   bool _isLoading = false;
//
//   Future<void> _login() async {
//     if (_emailController.text.isEmpty ||
//         _passwordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Email and password required")),
//       );
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     try {
//
//       String email = _emailController.text.trim();
//       String password = _passwordController.text.trim();
//
//       /// ADMIN LOGIN
//       if (email == "admin@vedant.com" && password == "Admin@123") {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const AdminPage()),
//         );
//         return;
//       }
//       await AuthService().login(
//         _emailController.text.trim(),
//         _passwordController.text.trim(),
//       );
//       // AuthGate will redirect automatically
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString())),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FAFB),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//
//               const Text(
//                 "Welcome Back",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF111827),
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               const Text(
//                 "Login to your account",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Color(0xFF070707)),
//               ),
//
//               const SizedBox(height: 40),
//
//               buildField(
//                 "Email",
//                 Icons.email,
//                 controller: _emailController,
//               ),
//
//               const SizedBox(height: 16),
//
//               buildField(
//                 "Password",
//                 Icons.lock,
//                 isPassword: true,
//                 controller: _passwordController,
//               ),
//
//               const SizedBox(height: 24),
//
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _login,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xF4448AFF),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text("Login",
//                   style: TextStyle(color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,),),
//               ),
//
//               const SizedBox(height: 16),
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Don’t have an account ? "),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => const SignUpScreen(),
//                         ),
//                       );
//                     },
//                     child: const Text("Sign Up"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildField(
//       String hint,
//       IconData icon, {
//         bool isPassword = false,
//         required TextEditingController controller,
//       }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: isPassword,
//       decoration: InputDecoration(
//         hintText: hint,
//         prefixIcon: Icon(icon),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }
//
//















// import 'package:flutter/material.dart';
// import 'package:vedant_education_app/screen/admin.dart';
// import '../service/auth_service.dart';
// import 'signup_screen.dart';
//
// const String _kAdminEmail = "admin@vedant.com";
// const String _kAdminPassword = "Admin@123";
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//
//   bool _isLoading = false;
//   bool _obscurePassword = true;
//
//   Future<void> _login() async {
//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();
//
//     if (email.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Email and password required")),
//       );
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     try {
//
//       // In login_screen.dart, update the admin login block:
//       if (email == _kAdminEmail && password == _kAdminPassword) {
//         if (!mounted) return;
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (_) => const AdminPage()),
//               (route) => false, // clears entire stack
//         );
//         return;
//       }
//       // if (email == _kAdminEmail && password == _kAdminPassword) {
//       //   if (!mounted) return;
//       //   Navigator.pushReplacement(
//       //     context,
//       //     MaterialPageRoute(builder: (_) => const AdminPage()),
//       //   );
//       //   return;
//       // }
//
//       await AuthService().login(email, password);
//
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString())),
//       );
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FAFB),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const Text(
//                 "Welcome Back",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF111827),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 "Login to your account",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Color(0xFF070707)),
//               ),
//               const SizedBox(height: 40),
//
//               buildField("Email", Icons.email, controller: _emailController),
//               const SizedBox(height: 16),
//
//               TextFormField(
//                 controller: _passwordController,
//                 obscureText: _obscurePassword,
//                 decoration: InputDecoration(
//                   hintText: "Password",
//                   prefixIcon: const Icon(Icons.lock),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                     ),
//                     onPressed: () {
//                       setState(() => _obscurePassword = !_obscurePassword);
//                     },
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _login,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xF4448AFF),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text(
//                   "Login",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Don't have an account ? "),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const SignUpScreen()),
//                       );
//                     },
//                     child: const Text("Sign Up"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildField(
//       String hint,
//       IconData icon, {
//         bool isPassword = false,
//         required TextEditingController controller,
//       }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: isPassword,
//       decoration: InputDecoration(
//         hintText: hint,
//         prefixIcon: Icon(icon),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }







