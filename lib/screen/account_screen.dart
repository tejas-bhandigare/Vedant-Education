import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vedant_education_app/screen/category_screen.dart';
import '../auth/auth_gate.dart';
import '../service/order_service.dart';
import 'cart_screen.dart';
import 'contact_us.dart';
import 'home.dart';
import 'login_screen.dart';
import 'orders_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  int _selectedIndex = 2; // Account selected

  /// ================= BOTTOM NAVIGATION =================
  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CategoryPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CartPage()),
      );
    }
  }

  /// ================= PROFILE DATA =================
  /// ================= PROFILE DATA =================
  String name = "User";
  String email = "";
  String phone = "";
  String address = "";   // ✅ ADD THIS
  double rating = 0;

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController(); // ✅ ADD
  final TextEditingController feedbackCtrl = TextEditingController();

  ///fedddback

  void _openFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              /// 🔹 TITLE WITH CLOSE BUTTON
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Rate Us"),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// ⭐ STAR RATING
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              rating = index + 1.0;
                            });
                          },
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Icons.star,
                              size: 28,
                              color: index < rating
                                  ? Colors.amber
                                  : Colors.grey,
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 15),

                    /// 📝 COMMENT BOX
                    TextField(
                      controller: feedbackCtrl,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: "Write your feedback...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                /// ✅ SUBMIT BUTTON WITH VALIDATION
                ElevatedButton(
                  onPressed: () {
                    if (rating == 0 &&
                        feedbackCtrl.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                          Text("Please give rating or feedback"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                        Text("Feedback submitted successfully"),
                        backgroundColor: Colors.green,
                      ),
                    );

                    feedbackCtrl.clear();
                    rating = 0;
                  },
                  child: const Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );
  }






  /// ================= EDIT PROFILE POPUP =================
  void _openEditDialog() {

    nameCtrl.text = name;
    emailCtrl.text = email;
    phoneCtrl.text = phone;
    addressCtrl.text = address;   // ✅ ADD


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          title: const Text("Edit Profile"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Name"),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Phone"),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: addressCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Address",
                ),
              ),
            ],
          ),

          actions: [

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {

                setState(() {
                  name = nameCtrl.text;
                  email = emailCtrl.text;
                  phone = phoneCtrl.text;
                  address = addressCtrl.text;  // ✅ ADD
                });

                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }









  /// ================= LOGOUT FUNCTION =================
  Future<void> logout() async {

    await Supabase.instance.client.auth.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }





  /// ================= MAIN BUILD =================
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF7F1F8),

      appBar: AppBar(
        title: const Text("Account"),
        centerTitle: true,
        backgroundColor: const Color(0xffF7F1F8),
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            /// ================= PROFILE CARD =================
            Container(

              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Row(

                children: [

                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person,
                        color: Colors.white, size: 28),
                  ),

                  const SizedBox(width: 12),

                  Expanded(

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Text(
                          "Hi $name",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          email.isEmpty
                              ? "Tap Edit to add details"
                              : email,
                          style: const TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          address.isEmpty ? "Add your address" : address,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  TextButton(
                    onPressed: _openEditDialog,
                    child: const Text(
                      "Edit",
                      style:
                      TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ================= ACTION BUTTONS =================
            GridView.count(

              crossAxisCount: 2,
              shrinkWrap: true,
              physics:
              const NeverScrollableScrollPhysics(),

              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3,

              children: [

                _ActionItem(
                  icon: Icons.shopping_bag,
                  text: "Orders",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OrdersPage(),
                      ),
                    );
                  },
                ),

                _ActionItem(
                    icon: Icons.favorite,
                    text: "Feedback",
                onTap:_openFeedbackDialog,
                ),

                _ActionItem(
                    icon: Icons.warning,
                    text: "Defective Product", onTap: () {  },),

                _ActionItem(
                  icon: Icons.help_outline,
                  text: "Help Us",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContactUsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),


            const SizedBox(height: 20),

            /// ================= LOGOUT BUTTON =================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(

                icon: const Icon(Icons.logout),

                label: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 16),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                onPressed: () async {
                  await Supabase.instance.client.auth.signOut();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthGate()), // ✅ AuthGate, not LoginScreen
                        (route) => false,
                  );
                },

                // onPressed: () async {
                //
                //   await Supabase.instance.client.auth.signOut();
                //
                //   Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(builder: (_) => const LoginScreen()),
                //         (route) => false,
                //   );
                //
                // },
              ),
            ),

            const SizedBox(height: 40),

          ],
        ),
      ),


      /// ===== BOTTOM NAV =====
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        ],
      ),
    );
  }

}



/// ================= ACTION BUTTON =================
class _ActionItem extends StatelessWidget {

  final IconData icon;
  final String text;
  final VoidCallback onTap;   // ✅ STORE IT

  const _ActionItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(                 // ✅ MAKE CLICKABLE
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),

        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}














