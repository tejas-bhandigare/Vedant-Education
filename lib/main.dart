import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedant_education_app/screen/admin_dashboard.dart';
import 'package:vedant_education_app/screen/admin_page.dart';

import 'package:vedant_education_app/screen/home.dart';
import 'package:vedant_education_app/provider/cart_provider.dart';
import 'package:vedant_education_app/screen/order_verification_screen.dart';
import 'supabase/supabase_client.dart';
import 'auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Supabase initialization (KEEP THIS)
  await SupabaseClientManager.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // 🔥 WRAP APP WITH PROVIDER (VERY IMPORTANT)
    return ChangeNotifierProvider(
      create: (_) => CartProvider()..loadCart(), // persistent cart
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        // ✅ Use whichever screen you want
        //  home: AuthGate(),
        //  home: HomeScreen(),
// home:AdminPage(),
        // home:AdminDashboard(),
        home: OrderVerificationScreen(),















        // home: ProductDetailsPage(title: '', productId: '', price: 0),
      ),
    );
  }
}
