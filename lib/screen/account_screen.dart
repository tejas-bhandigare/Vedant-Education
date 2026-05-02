import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vedant_education_app/screen/category_screen.dart';
import '../auth/auth_gate.dart';
import '../service/order_service.dart';
import 'DefectiveProduct.dart';
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
  int _selectedIndex = 2;

  // Profile data
  String name = "User";
  String email = "";
  String phone = "";
  String address = "";
  double rating = 0;
  bool _isLoading = true; // ✅ show loader while fetching profile

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController feedbackCtrl = TextEditingController();

  final _supabase = Supabase.instance.client;

  // ─── Load profile from Supabase on init ───────────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle(); // ✅ returns null if no row yet, won't throw

      if (data != null && mounted) {
        setState(() {
          name    = data['name']    ?? 'User';
          email   = data['email']   ?? '';
          phone   = data['phone']   ?? '';
          address = data['address'] ?? '';
        });
      }
    } catch (e) {
      debugPrint("Profile load error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─── Save profile to Supabase ──────────────────────────────────────────────
  Future<void> _saveProfile() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabase.from('profiles').upsert({
        'id':      userId,        // primary key
        'name':    nameCtrl.text.trim(),
        'email':   emailCtrl.text.trim(),
        'phone':   phoneCtrl.text.trim(),
        'address': addressCtrl.text.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        setState(() {
          name    = nameCtrl.text.trim();
          email   = emailCtrl.text.trim();
          phone   = phoneCtrl.text.trim();
          address = addressCtrl.text.trim();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint("Profile save error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to save: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ─── Bottom nav ───────────────────────────────────────────────────────────
  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else if (index == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const CategoryPage()));
    } else if (index == 3) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const CartPage()));
    }
  }

  // ─── Feedback dialog ──────────────────────────────────────────────────────

  void _openFeedbackDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Feedback",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (ctx, anim, _, child) {
        final curve = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: Tween<double>(begin: 0.88, end: 1.0).animate(curve),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
      pageBuilder: (ctx, _, __) {
        double localRating = rating;
        bool submitted = false;
        final List<String> tags = ["Quality", "Delivery", "Packaging", "Value", "Support"];
        final Set<String> selectedTags = {};

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 40,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: submitted

                      // ── Success state ──────────────────────────
                          ? SizedBox(
                        key: const ValueKey('success'),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 72, height: 72,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF22C55E).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_rounded,
                                    color: Color(0xFF22C55E), size: 40),
                              ),
                              const SizedBox(height: 20),
                              const Text("Thank you! 🎉",
                                  style: TextStyle(fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87)),
                              const SizedBox(height: 8),
                              Text("Your feedback helps us improve.",
                                  style: TextStyle(fontSize: 14,
                                      color: Colors.grey.shade500)),
                            ],
                          ),
                        ),
                      )

                      // ── Form state ─────────────────────────────
                          : SingleChildScrollView(
                        key: const ValueKey('form'),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // Header
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                                ),
                              ),
                              padding: const EdgeInsets.fromLTRB(20, 20, 12, 20),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Rate Your Experience",
                                            style: TextStyle(fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white)),
                                        SizedBox(height: 2),
                                        Text("Your opinion matters to us",
                                            style: TextStyle(fontSize: 12,
                                                color: Colors.white70)),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close_rounded,
                                        color: Colors.white70, size: 22),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  // Stars
                                  Center(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(5, (i) {
                                            return GestureDetector(
                                              onTap: () {
                                                HapticFeedback.lightImpact();
                                                setDialogState(() {
                                                  localRating = i + 1.0;
                                                  rating = localRating;
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                                child: AnimatedSwitcher(
                                                  duration: const Duration(milliseconds: 200),
                                                  transitionBuilder: (child, anim) =>
                                                      ScaleTransition(scale: anim, child: child),
                                                  child: Icon(
                                                    i < localRating
                                                        ? Icons.star_rounded
                                                        : Icons.star_border_rounded,
                                                    key: ValueKey(i < localRating),
                                                    size: 38,
                                                    color: i < localRating
                                                        ? const Color(0xFFFBBF24)
                                                        : Colors.grey.shade300,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                        const SizedBox(height: 8),
                                        AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 200),
                                          child: Text(
                                            localRating == 0 ? "Tap to rate"
                                                : localRating == 1 ? "Poor 😞"
                                                : localRating == 2 ? "Fair 😐"
                                                : localRating == 3 ? "Good 🙂"
                                                : localRating == 4 ? "Great 😄"
                                                : "Excellent! 🤩",
                                            key: ValueKey(localRating),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: localRating == 0
                                                  ? Colors.grey.shade400
                                                  : const Color(0xFF4F46E5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 22),

                                  // Tags
                                  Text("What stood out?",
                                      style: TextStyle(fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade700)),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8, runSpacing: 8,
                                    children: tags.map((tag) {
                                      final selected = selectedTags.contains(tag);
                                      return GestureDetector(
                                        onTap: () {
                                          HapticFeedback.selectionClick();
                                          setDialogState(() => selected
                                              ? selectedTags.remove(tag)
                                              : selectedTags.add(tag));
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 180),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 7),
                                          decoration: BoxDecoration(
                                            color: selected
                                                ? const Color(0xFF4F46E5).withOpacity(0.1)
                                                : Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(
                                              color: selected
                                                  ? const Color(0xFF4F46E5)
                                                  : Colors.grey.shade200,
                                              width: selected ? 1.5 : 1,
                                            ),
                                          ),
                                          child: Text(tag,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: selected
                                                    ? const Color(0xFF4F46E5)
                                                    : Colors.grey.shade600,
                                              )),
                                        ),
                                      );
                                    }).toList(),
                                  ),

                                  const SizedBox(height: 22),

                                  // Text field
                                  Text("Tell us more (optional)",
                                      style: TextStyle(fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade700)),
                                  const SizedBox(height: 10),
                                  TextField(
                                    controller: feedbackCtrl,
                                    maxLines: 3,
                                    style: const TextStyle(fontSize: 14),
                                    decoration: InputDecoration(
                                      hintText: "What can we do better?",
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade400, fontSize: 13),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      contentPadding: const EdgeInsets.all(14),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.shade200),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.shade200),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF4F46E5), width: 1.5),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // Buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 14),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              side: BorderSide(color: Colors.grey.shade200),
                                            ),
                                          ),
                                          child: Text("Cancel",
                                              style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        flex: 2,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (localRating == 0 &&
                                                feedbackCtrl.text.trim().isEmpty) {
                                              HapticFeedback.mediumImpact();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: const Text(
                                                      "Please give a rating or write feedback"),
                                                  backgroundColor: Colors.red.shade400,
                                                  behavior: SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10)),
                                                ),
                                              );
                                              return;
                                            }
                                            setDialogState(() => submitted = true);
                                            Future.delayed(
                                              const Duration(milliseconds: 1800),
                                                  () {
                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                  feedbackCtrl.clear();
                                                  rating = 0;
                                                }
                                              },
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF4F46E5),
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(vertical: 14),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12)),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.send_rounded, size: 16),
                                              SizedBox(width: 8),
                                              Text("Submit",
                                                  style: TextStyle(fontWeight: FontWeight.w600)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }








  // ─── Edit profile dialog ──────────────────────────────────────────────────
  void _openEditDialog() {
    nameCtrl.text    = name;
    emailCtrl.text   = email;
    phoneCtrl.text   = phone;
    addressCtrl.text = address;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          title: const Text("Edit Profile"),
          content: SingleChildScrollView(
            child: Column(
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
                  decoration: const InputDecoration(labelText: "Address"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _saveProfile(); // ✅ save to Supabase
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile Card ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Avatar with first letter of name
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      name.isNotEmpty
                          ? name[0].toUpperCase()
                          : "U",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, $name",
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
                        if (phone.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(phone,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13)),
                        ],
                        if (address.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(address,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13)),
                        ],
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _openEditDialog,
                    child: const Text("Edit",
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Action Grid ───────────────────────────────────────────
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3,
              children: [
                _ActionItem(
                  icon: Icons.shopping_bag,
                  text: "Orders",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const OrdersPage()),
                  ),
                ),
                _ActionItem(
                  icon: Icons.favorite,
                  text: "Feedback",
                  onTap: _openFeedbackDialog,
                ),
                _ActionItem(
                  icon: Icons.warning,
                  text: "Defective Product",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DefectiveProductScreen(),
                      ),
                    );
                  },
                ),
                // _ActionItem(
                //   icon: Icons.warning,
                //   text: "Defective Product",
                //   onTap: () {},
                // ),
                _ActionItem(
                  icon: Icons.help_outline,
                  text: "Help Us",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ContactUsPage()),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Logout Button ─────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text("Logout",
                    style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  await _supabase.auth.signOut();
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AuthGate()),
                          (route) => false,
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view), label: 'Category'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Account'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    feedbackCtrl.dispose();
    super.dispose();
  }
}

class DefectiveProduct {
}

// ─── Action Item ──────────────────────────────────────────────────────────────
class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
              child: Text(text,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}




