import 'package:flutter/material.dart';
// import 'product_management.dart';   // your current file
import 'order_management.dart';                // order management screen

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Color(0xFFF1F4FF),
              child: Icon(Icons.person, color: Colors.blue),
            ),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // /// PRODUCT MANAGEMENT
            // _buildAdminCard(
            //   context,
            //   title: "Product Management",
            //   subtitle: "Add and manage products",
            //   icon: Icons.inventory_2,
            //   color: Colors.blue,
            //   page: const ProductManagementPage(),
            // ),

            const SizedBox(height: 20),

            /// ORDER MANAGEMENT
            _buildAdminCard(
              context,
              title: "Order Management",
              subtitle: "View and manage orders",
              icon: Icons.shopping_cart,
              color: Colors.green,
              page: const OrderScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required Widget page,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 28),
            ),

            const SizedBox(width: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            ),

            const Spacer(),

            const Icon(Icons.arrow_forward_ios, size: 16)
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
//
// class AdminPage extends StatelessWidget {
//   const AdminPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Admin Panel"),
//         centerTitle: true,
//       ),
//       body: const Center(
//         child: Text(
//           "This is Admin Page",
//           style: TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }