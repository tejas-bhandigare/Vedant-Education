import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'account_screen.dart';
import 'category_screen.dart';
import 'home.dart';

import '../provider/cart_provider.dart';
import '../service/order_service.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  int _selectedIndex = 3;

  /// ================= BOTTOM NAV =================
  void _onItemTapped(int index) {

    if (index == _selectedIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CategoryPage()),
      );
    }

    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AccountPage()),
      );
    }
  }

  /// ================= QTY BUTTON HELPER =================
  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 0.8),
        ),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }

  /// ================= CONFIRM DIALOG =================
  void showConfirmDialog(BuildContext context) {

    final cart = context.read<CartProvider>();

    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

          title: const Text("Confirm Order"),

          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Order summary
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Amount",
                            style: TextStyle(color: Colors.grey, fontSize: 13)),
                        Text(
                          "₹${cart.totalAmount.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "Delivery Details",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      hintText: "Enter your name",
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your name";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: addressController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Delivery Address",
                      hintText: "House no, Street, City, Pincode",
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your address";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),

          actions: [

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {

                if (!formKey.currentState!.validate()) return;

                Navigator.pop(context);

                await placeOrder(
                  context,
                  customerName: nameController.text.trim(),
                  customerAddress: addressController.text.trim(),
                );

              },
              child: const Text("Confirm Order"),
            ),

          ],
        );
      },
    );
  }

  /// ================= PLACE ORDER =================
  Future<void> placeOrder(
      BuildContext context, {
        required String customerName,
        required String customerAddress,
      }) async {

    final cart = context.read<CartProvider>();

    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first")),
      );
      return;
    }

    try {

      final orderService = OrderService();

      await orderService.placeOrder(
        userId: user.id,
        items: cart.items,
        totalAmount: cart.totalAmount,
        customerName: customerName,
        customerAddress: customerAddress,
      );

      await cart.clearCart();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully! 🎉")),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order failed: $e")),
      );
    }
  }

  /// ================= INLINE QTY EDITOR =================
  Widget _qtyEditable(BuildContext context, dynamic item, CartProvider cart) {
    return _QtyEditField(
      key: ValueKey('qty_${item.product.id}'),
      quantity: item.quantity,
      onChanged: (newQty) {
        if (newQty < 1) {
          cart.removeItem(item.product.id);
        } else {
          cart.setQty(item.product.id, newQty);
        }
      },
    );
  }

  /// ================= CART ITEM CARD =================
  Widget _buildCartItem(BuildContext context, dynamic item, CartProvider cart) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200, width: 0.8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              item.product.image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          /// PRODUCT INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Product name
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 2),

                // Variant / subtitle (optional — use if your model has it)
                // Text(
                //   item.product.variant ?? "",
                //   style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                // ),

                const SizedBox(height: 6),

                // Price
                Text(
                  "₹ ${item.product.price}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 10),

                /// QTY ROW
                Row(
                  children: [

                    _qtyButton(Icons.remove, () {
                      cart.decreaseQty(item.product.id);
                    }),

                    _qtyEditable(context, item, cart),

                    _qtyButton(Icons.add, () {
                      cart.increaseQty(item.product.id);
                    }),

                    const Spacer(),

                    /// DELETE BUTTON
                    GestureDetector(
                      onTap: () => cart.removeItem(item.product.id),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red.shade100),
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: Colors.red.shade400,
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          /// SUBTOTAL (right column)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "subtotal",
                style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 3),
              Text(
                "₹ ${(item.product.price * item.quantity).toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  /// ================= ORDER SUMMARY CARD =================
  Widget _buildOrderSummary(CartProvider cart) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200, width: 0.8),
      ),
      child: Column(
        children: [

          _summaryRow("Items (${cart.items.length})",
              "₹ ${cart.totalAmount.toStringAsFixed(0)}"),

          const SizedBox(height: 8),

          _summaryRow("Delivery", "Free",
              valueColor: Colors.green.shade600),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Payable",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              Text(
                "₹ ${cart.totalAmount.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  /// ================= BUILD =================
  @override
  Widget build(BuildContext context) {

    final cart = context.watch<CartProvider>();

    return Scaffold(

      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        title: Text(
          "My Cart (${cart.items.length})",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.grey.shade200),
        ),
      ),

      /// ================= BODY =================
      body: cart.items.isEmpty

          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined,
                size: 72, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              "Your cart is empty",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Add items to get started",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            ),
          ],
        ),
      )

          : ListView(
        padding: const EdgeInsets.only(top: 10, bottom: 140),
        children: [

          ...cart.items.map((item) =>
              _buildCartItem(context, item, cart)),

          const SizedBox(height: 8),

          _buildOrderSummary(cart),

        ],
      ),

      /// ================= BOTTOM BAR =================
      bottomNavigationBar: cart.items.isEmpty

          ? BottomNavigationBar(
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
      )

          : Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// CHECKOUT STRIP
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200, width: 0.8),
              ),
            ),
            child: Row(
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500),
                    ),
                    Text(
                      "₹ ${cart.totalAmount.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => showConfirmDialog(context),
                  child: const Text(
                    "Place Order",
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),

              ],
            ),
          ),

          BottomNavigationBar(
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

        ],
      ),
    );
  }
}


// ── Inline quantity editor ────────────────────────────────────────────────
// Tap the number → becomes a TextField → type new value → confirm with Enter
// or tap outside. Subtotal, order summary, and checkout total all update live
// because CartProvider notifies listeners whenever setQty is called.
class _QtyEditField extends StatefulWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const _QtyEditField({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  @override
  State<_QtyEditField> createState() => _QtyEditFieldState();
}

class _QtyEditFieldState extends State<_QtyEditField> {
  bool _editing = false;
  late TextEditingController _ctrl;
  late FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: '${widget.quantity}');
    _focus = FocusNode();
    _focus.addListener(() {
      if (!_focus.hasFocus && _editing) _commit();
    });
  }

  @override
  void didUpdateWidget(_QtyEditField old) {
    super.didUpdateWidget(old);
    if (!_editing && old.quantity != widget.quantity) {
      _ctrl.text = '${widget.quantity}';
    }
  }

  void _startEditing() {
    setState(() {
      _editing = true;
      _ctrl.text = '${widget.quantity}';
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focus.requestFocus();
      _ctrl.selection =
          TextSelection(baseOffset: 0, extentOffset: _ctrl.text.length);
    });
  }

  void _commit() {
    final parsed = int.tryParse(_ctrl.text.trim());
    setState(() => _editing = false);
    if (parsed != null && parsed != widget.quantity) {
      widget.onChanged(parsed);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      return SizedBox(
        width: 48,
        height: 34,
        child: TextField(
          controller: _ctrl,
          focusNode: _focus,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor, width: 1.5),
            ),
          ),
          onSubmitted: (_) => _commit(),
        ),
      );
    }

    // Display mode — tappable pill
    return GestureDetector(
      onTap: _startEditing,
      child: Container(
        constraints: const BoxConstraints(minWidth: 36),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 0.8),
        ),
        child: Text(
          '${widget.quantity}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}


















// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// import 'account_screen.dart';
// import 'category_screen.dart';
// import 'home.dart';
//
// import '../provider/cart_provider.dart';
// import '../service/order_service.dart';
//
//
// class CartPage extends StatefulWidget {
//   const CartPage({super.key});
//
//   @override
//   State<CartPage> createState() => _CartPageState();
// }
//
// class _CartPageState extends State<CartPage> {
//
//   int _selectedIndex = 3;
//
//   /// ================= BOTTOM NAV =================
//   void _onItemTapped(int index) {
//
//     if (index == _selectedIndex) return;
//
//     if (index == 0) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//       );
//     }
//
//     if (index == 1) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const CategoryPage()),
//       );
//     }
//
//     if (index == 2) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const AccountPage()),
//       );
//     }
//   }
//
//   /// ================= QTY BUTTON HELPER =================
//   Widget _qtyButton(IconData icon, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 30,
//         height: 30,
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: Colors.grey.shade300, width: 0.8),
//         ),
//         child: Icon(icon, size: 16, color: Colors.black87),
//       ),
//     );
//   }
//
//   /// ================= CONFIRM DIALOG =================
//   void showConfirmDialog(BuildContext context) {
//
//     final cart = context.read<CartProvider>();
//
//     final nameController = TextEditingController();
//     final addressController = TextEditingController();
//     final formKey = GlobalKey<FormState>();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//
//         return AlertDialog(
//
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//
//           title: const Text("Confirm Order"),
//
//           content: SingleChildScrollView(
//             child: Form(
//               key: formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//
//                   // Order summary
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade50,
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: Colors.grey.shade200),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text("Total Amount",
//                             style: TextStyle(color: Colors.grey, fontSize: 13)),
//                         Text(
//                           "₹${cart.totalAmount.toStringAsFixed(0)}",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 17,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 18),
//
//                   const Text(
//                     "Delivery Details",
//                     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//                   ),
//
//                   const SizedBox(height: 10),
//
//                   TextFormField(
//                     controller: nameController,
//                     decoration: InputDecoration(
//                       labelText: "Full Name",
//                       hintText: "Enter your name",
//                       prefixIcon: const Icon(Icons.person_outline),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 12),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return "Please enter your name";
//                       }
//                       return null;
//                     },
//                   ),
//
//                   const SizedBox(height: 12),
//
//                   TextFormField(
//                     controller: addressController,
//                     maxLines: 3,
//                     decoration: InputDecoration(
//                       labelText: "Delivery Address",
//                       hintText: "House no, Street, City, Pincode",
//                       prefixIcon: const Icon(Icons.location_on_outlined),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 12),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return "Please enter your address";
//                       }
//                       return null;
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           actions: [
//
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onPressed: () async {
//
//                 if (!formKey.currentState!.validate()) return;
//
//                 Navigator.pop(context);
//
//                 await placeOrder(
//                   context,
//                   customerName: nameController.text.trim(),
//                   customerAddress: addressController.text.trim(),
//                 );
//
//               },
//               child: const Text("Confirm Order"),
//             ),
//
//           ],
//         );
//       },
//     );
//   }
//
//   /// ================= PLACE ORDER =================
//   Future<void> placeOrder(
//       BuildContext context, {
//         required String customerName,
//         required String customerAddress,
//       }) async {
//
//     final cart = context.read<CartProvider>();
//
//     final user = Supabase.instance.client.auth.currentUser;
//
//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please login first")),
//       );
//       return;
//     }
//
//     try {
//
//       final orderService = OrderService();
//
//       await orderService.placeOrder(
//         userId: user.id,
//         items: cart.items,
//         totalAmount: cart.totalAmount,
//         customerName: customerName,
//         customerAddress: customerAddress,
//       );
//
//       await cart.clearCart();
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Order placed successfully! 🎉")),
//       );
//
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Order failed: $e")),
//       );
//     }
//   }
//
//   /// ================= CART ITEM CARD =================
//   Widget _buildCartItem(BuildContext context, dynamic item, CartProvider cart) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.shade200, width: 0.8),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           /// IMAGE
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Image.asset(
//               item.product.image,
//               width: 80,
//               height: 80,
//               fit: BoxFit.cover,
//             ),
//           ),
//
//           const SizedBox(width: 12),
//
//           /// PRODUCT INFO
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//                 // Product name
//                 Text(
//                   item.product.name,
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//
//                 const SizedBox(height: 2),
//
//                 // Variant / subtitle (optional — use if your model has it)
//                 // Text(
//                 //   item.product.variant ?? "",
//                 //   style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
//                 // ),
//
//                 const SizedBox(height: 6),
//
//                 // Price
//                 Text(
//                   "₹ ${item.product.price}",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 /// QTY ROW
//                 Row(
//                   children: [
//
//                     _qtyButton(Icons.remove, () {
//                       cart.decreaseQty(item.product.id);
//                     }),
//
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 14),
//                       child: Text(
//                         "${item.quantity}",
//                         style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//
//                     _qtyButton(Icons.add, () {
//                       cart.increaseQty(item.product.id);
//                     }),
//
//                     const Spacer(),
//
//                     /// DELETE BUTTON
//                     GestureDetector(
//                       onTap: () => cart.removeItem(item.product.id),
//                       child: Container(
//                         width: 30,
//                         height: 30,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.red.shade100),
//                           color: Colors.red.shade50,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Icon(
//                           Icons.delete_outline,
//                           size: 16,
//                           color: Colors.red.shade400,
//                         ),
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(width: 10),
//
//           /// SUBTOTAL (right column)
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 "subtotal",
//                 style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
//               ),
//               const SizedBox(height: 3),
//               Text(
//                 "₹ ${(item.product.price * item.quantity).toStringAsFixed(0)}",
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//
//         ],
//       ),
//     );
//   }
//
//   /// ================= ORDER SUMMARY CARD =================
//   Widget _buildOrderSummary(CartProvider cart) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.shade200, width: 0.8),
//       ),
//       child: Column(
//         children: [
//
//           _summaryRow("Items (${cart.items.length})",
//               "₹ ${cart.totalAmount.toStringAsFixed(0)}"),
//
//           const SizedBox(height: 8),
//
//           _summaryRow("Delivery", "Free",
//               valueColor: Colors.green.shade600),
//
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 10),
//             child: Divider(height: 1),
//           ),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 "Total Payable",
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//               ),
//               Text(
//                 "₹ ${cart.totalAmount.toStringAsFixed(0)}",
//                 style: const TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ],
//           ),
//
//         ],
//       ),
//     );
//   }
//
//   Widget _summaryRow(String label, String value, {Color? valueColor}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(label,
//             style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//             color: valueColor ?? Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// ================= BUILD =================
//   @override
//   Widget build(BuildContext context) {
//
//     final cart = context.watch<CartProvider>();
//
//     return Scaffold(
//
//       backgroundColor: Colors.grey.shade50,
//
//       appBar: AppBar(
//         title: Text(
//           "My Cart (${cart.items.length})",
//           style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         surfaceTintColor: Colors.transparent,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1),
//           child: Divider(height: 1, color: Colors.grey.shade200),
//         ),
//       ),
//
//       /// ================= BODY =================
//       body: cart.items.isEmpty
//
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.shopping_cart_outlined,
//                 size: 72, color: Colors.grey.shade300),
//             const SizedBox(height: 16),
//             Text(
//               "Your cart is empty",
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.grey.shade500,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               "Add items to get started",
//               style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
//             ),
//           ],
//         ),
//       )
//
//           : ListView(
//         padding: const EdgeInsets.only(top: 10, bottom: 140),
//         children: [
//
//           ...cart.items.map((item) =>
//               _buildCartItem(context, item, cart)),
//
//           const SizedBox(height: 8),
//
//           _buildOrderSummary(cart),
//
//         ],
//       ),
//
//       /// ================= BOTTOM BAR =================
//       bottomNavigationBar: cart.items.isEmpty
//
//           ? BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Category'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
//           BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
//         ],
//       )
//
//           : Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//
//           /// CHECKOUT STRIP
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border(
//                 top: BorderSide(color: Colors.grey.shade200, width: 0.8),
//               ),
//             ),
//             child: Row(
//               children: [
//
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Total",
//                       style: TextStyle(
//                           fontSize: 12, color: Colors.grey.shade500),
//                     ),
//                     Text(
//                       "₹ ${cart.totalAmount.toStringAsFixed(0)}",
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const Spacer(),
//
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 28, vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 0,
//                   ),
//                   onPressed: () => showConfirmDialog(context),
//                   child: const Text(
//                     "Place Order",
//                     style: TextStyle(
//                         fontSize: 15, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//
//           BottomNavigationBar(
//             type: BottomNavigationBarType.fixed,
//             currentIndex: _selectedIndex,
//             selectedItemColor: Colors.blue,
//             unselectedItemColor: Colors.grey,
//             onTap: _onItemTapped,
//             items: const [
//               BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//               BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Category'),
//               BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
//               BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
//             ],
//           ),
//
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// //
// // import 'account_screen.dart';
// // import 'category_screen.dart';
// // import 'home.dart';
// //
// // import '../provider/cart_provider.dart';
// // import '../service/order_service.dart';
// //
// //
// // class CartPage extends StatefulWidget {
// //   const CartPage({super.key});
// //
// //   @override
// //   State<CartPage> createState() => _CartPageState();
// // }
// //
// // class _CartPageState extends State<CartPage> {
// //
// //   int _selectedIndex = 3;
// //
// //   /// ================= BOTTOM NAV =================
// //   void _onItemTapped(int index) {
// //
// //     if (index == _selectedIndex) return;
// //
// //     if (index == 0) {
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (_) => const HomeScreen()),
// //       );
// //     }
// //
// //     if (index == 1) {
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (_) => const CategoryPage()),
// //       );
// //     }
// //
// //     if (index == 2) {
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (_) => const AccountPage()),
// //       );
// //     }
// //   }
// //
// //   /// ================= CONFIRM DIALOG (with name + address) =================
// //   void showConfirmDialog(BuildContext context) {
// //
// //     final cart = context.read<CartProvider>();
// //
// //     final nameController = TextEditingController();
// //     final addressController = TextEditingController();
// //     final formKey = GlobalKey<FormState>();
// //
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //
// //         return AlertDialog(
// //
// //           title: const Text("Confirm Order"),
// //
// //           content: SingleChildScrollView(
// //             child: Form(
// //               key: formKey,
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //
// //                   // Order summary
// //                   Container(
// //                     padding: const EdgeInsets.all(12),
// //                     decoration: BoxDecoration(
// //                       color: Colors.grey.shade100,
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         const Text("Total Amount",
// //                             style: TextStyle(color: Colors.grey)),
// //                         Text(
// //                           "₹${cart.totalAmount.toStringAsFixed(2)}",
// //                           style: const TextStyle(
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 16,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //
// //                   const SizedBox(height: 16),
// //
// //                   // Customer name field
// //                   const Text(
// //                     "Delivery Details",
// //                     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
// //                   ),
// //
// //                   const SizedBox(height: 10),
// //
// //                   TextFormField(
// //                     controller: nameController,
// //                     decoration: InputDecoration(
// //                       labelText: "Full Name",
// //                       hintText: "Enter your name",
// //                       prefixIcon: const Icon(Icons.person_outline),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                       contentPadding: const EdgeInsets.symmetric(
// //                           horizontal: 12, vertical: 12),
// //                     ),
// //                     validator: (value) {
// //                       if (value == null || value.trim().isEmpty) {
// //                         return "Please enter your name";
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //
// //                   const SizedBox(height: 12),
// //
// //                   // Address field
// //                   TextFormField(
// //                     controller: addressController,
// //                     maxLines: 3,
// //                     decoration: InputDecoration(
// //                       labelText: "Delivery Address",
// //                       hintText: "House no, Street, City, Pincode",
// //                       prefixIcon: const Icon(Icons.location_on_outlined),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                       contentPadding: const EdgeInsets.symmetric(
// //                           horizontal: 12, vertical: 12),
// //                     ),
// //                     validator: (value) {
// //                       if (value == null || value.trim().isEmpty) {
// //                         return "Please enter your address";
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //
// //           actions: [
// //
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.pop(context);
// //               },
// //               child: const Text("Cancel"),
// //             ),
// //
// //             ElevatedButton(
// //               onPressed: () async {
// //
// //                 // Validate form before placing order
// //                 if (!formKey.currentState!.validate()) return;
// //
// //                 Navigator.pop(context);
// //
// //                 await placeOrder(
// //                   context,
// //                   customerName: nameController.text.trim(),
// //                   customerAddress: addressController.text.trim(),
// //                 );
// //
// //               },
// //               child: const Text("Confirm Order"),
// //             ),
// //
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   /// ================= PLACE ORDER =================
// //   Future<void> placeOrder(
// //       BuildContext context, {
// //         required String customerName,
// //         required String customerAddress,
// //       }) async {
// //
// //     final cart = context.read<CartProvider>();
// //
// //     final user = Supabase.instance.client.auth.currentUser;
// //
// //     if (user == null) {
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Please login first")),
// //       );
// //
// //       return;
// //     }
// //
// //     try {
// //
// //       final orderService = OrderService();
// //
// //       await orderService.placeOrder(
// //         userId: user.id,
// //         items: cart.items,
// //         totalAmount: cart.totalAmount,
// //         customerName: customerName,
// //         customerAddress: customerAddress,
// //       );
// //
// //       await cart.clearCart();
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Order placed successfully! 🎉")),
// //       );
// //
// //     } catch (e) {
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Order failed: $e")),
// //       );
// //     }
// //   }
// //
// //   /// ================= BUILD =================
// //   @override
// //   Widget build(BuildContext context) {
// //
// //     final cart = context.watch<CartProvider>();
// //
// //     return Scaffold(
// //
// //       appBar: AppBar(
// //         title: Text("Cart (${cart.items.length} items)"),
// //         centerTitle: true,
// //       ),
// //
// //       /// ================= CART LIST =================
// //       body: cart.items.isEmpty
// //
// //           ? const Center(
// //         child: Text(
// //           "Your cart is empty",
// //           style: TextStyle(fontSize: 18),
// //         ),
// //       )
// //
// //           : ListView.builder(
// //
// //         padding: const EdgeInsets.only(bottom: 120),
// //
// //         itemCount: cart.items.length,
// //
// //         itemBuilder: (context, index) {
// //
// //           final item = cart.items[index];
// //
// //           return Container(
// //
// //             margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// //
// //             padding: const EdgeInsets.all(12),
// //
// //             decoration: BoxDecoration(
// //
// //               color: Colors.white,
// //
// //               borderRadius: BorderRadius.circular(14),
// //
// //               boxShadow: const [
// //                 BoxShadow(
// //                   color: Colors.black12,
// //                   blurRadius: 6,
// //                   offset: Offset(0, 3),
// //                 )
// //               ],
// //             ),
// //
// //             child: Row(
// //               children: [
// //
// //                 /// IMAGE
// //                 ClipRRect(
// //                   borderRadius: BorderRadius.circular(10),
// //                   child: Image.asset(
// //                     item.product.image,
// //                     width: 70,
// //                     height: 70,
// //                     fit: BoxFit.cover,
// //                   ),
// //                 ),
// //
// //                 const SizedBox(width: 12),
// //
// //                 /// PRODUCT INFO
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //
// //                       Text(
// //                         item.product.name,
// //                         style: const TextStyle(
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.w600,
// //                         ),
// //                       ),
// //
// //                       const SizedBox(height: 6),
// //
// //                       Text(
// //                         "₹ ${item.product.price}",
// //                         style: const TextStyle(
// //                           fontSize: 14,
// //                           color: Colors.grey,
// //                         ),
// //                       ),
// //
// //                       /// QUANTITY CONTROLLER
// //                       Container(
// //                         decoration: BoxDecoration(
// //                           border: Border.all(color: Colors.grey),
// //                           borderRadius: BorderRadius.circular(8),
// //                         ),
// //
// //                         child: Row(
// //                           mainAxisSize: MainAxisSize.min,
// //                           children: [
// //
// //                             IconButton(
// //                               icon: const Icon(Icons.remove),
// //                               onPressed: () {
// //                                 cart.decreaseQty(item.product.id);
// //                               },
// //                             ),
// //
// //                             Text(
// //                               "${item.quantity}",
// //                               style: const TextStyle(
// //                                 fontSize: 14,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //
// //                             IconButton(
// //                               icon: const Icon(Icons.add),
// //                               onPressed: () {
// //                                 cart.increaseQty(item.product.id);
// //                               },
// //                             ),
// //
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //
// //                 Column(
// //                   children: [
// //
// //                     Text(
// //                       "₹ ${(item.product.price * item.quantity).toStringAsFixed(0)}",
// //                       style: const TextStyle(
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 16,
// //                       ),
// //                     ),
// //
// //                     const SizedBox(height: 6),
// //
// //                     IconButton(
// //                       icon: const Icon(Icons.delete_outline, color: Colors.red),
// //                       onPressed: () {
// //                         cart.removeItem(item.product.id);
// //                       },
// //                     ),
// //
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //
// //       /// ================= CHECKOUT BAR =================
// //       bottomNavigationBar: cart.items.isEmpty
// //           ? BottomNavigationBar(
// //
// //         type: BottomNavigationBarType.fixed,
// //
// //         currentIndex: _selectedIndex,
// //
// //         selectedItemColor: Colors.blue,
// //
// //         unselectedItemColor: Colors.grey,
// //
// //         onTap: _onItemTapped,
// //
// //         items: const [
// //
// //           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
// //
// //           BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Category'),
// //
// //           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
// //
// //           BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
// //         ],
// //       )
// //
// //           : Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //
// //           Container(
// //
// //             padding: const EdgeInsets.all(16),
// //
// //             decoration: const BoxDecoration(
// //               color: Colors.white,
// //               boxShadow: [
// //                 BoxShadow(color: Colors.black12, blurRadius: 8)
// //               ],
// //             ),
// //
// //             child: Row(
// //               children: [
// //
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //
// //                       const Text(
// //                         "Total",
// //                         style: TextStyle(color: Colors.grey),
// //                       ),
// //
// //                       Text(
// //                         "₹ ${cart.totalAmount.toStringAsFixed(0)}",
// //                         style: const TextStyle(
// //                           fontSize: 20,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //
// //                 ElevatedButton(
// //                   style: ElevatedButton.styleFrom(
// //                     padding: const EdgeInsets.symmetric(
// //                         horizontal: 24, vertical: 14),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                   ),
// //                   onPressed: () {
// //                     showConfirmDialog(context);
// //                   },
// //                   child: const Text(
// //                     "Place Order",
// //                     style: TextStyle(fontSize: 16),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //
// //           BottomNavigationBar(
// //
// //             type: BottomNavigationBarType.fixed,
// //
// //             currentIndex: _selectedIndex,
// //
// //             selectedItemColor: Colors.blue,
// //
// //             unselectedItemColor: Colors.grey,
// //
// //             onTap: _onItemTapped,
// //
// //             items: const [
// //
// //               BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
// //
// //               BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Category'),
// //
// //               BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
// //
// //               BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
//
//
//
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// //
// // import 'account_screen.dart';
// // import 'category_screen.dart';
// // import 'home.dart';
// //
// // import '../provider/cart_provider.dart';
// // import '../service/order_service.dart';
// //
// // class CartPage extends StatefulWidget {
// //   const CartPage({super.key});
// //
// //   @override
// //   State<CartPage> createState() => _CartPageState();
// // }
// //
// // class _CartPageState extends State<CartPage> {
// //
// //   int _selectedIndex = 3;
// //
// //   /// ================= BOTTOM NAV =================
// //   void _onItemTapped(int index) {
// //
// //     if (index == _selectedIndex) return;
// //
// //     if (index == 0) {
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (_) => const HomeScreen()),
// //       );
// //     }
// //
// //     if (index == 1) {
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (_) => const CategoryPage()),
// //       );
// //     }
// //
// //     if (index == 2) {
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (_) => const AccountPage()),
// //       );
// //     }
// //   }
// //
// //   /// ================= CONFIRM DIALOG =================
// //   void showConfirmDialog(BuildContext context) {
// //
// //     final cart = context.read<CartProvider>();
// //
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //
// //         return AlertDialog(
// //
// //           title: const Text("Confirm Order"),
// //
// //           content: Text(
// //             "Total Amount: ₹${cart.totalAmount.toStringAsFixed(2)}\n\nDo you want to place the order?",
// //           ),
// //
// //           actions: [
// //
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.pop(context);
// //               },
// //               child: const Text("Cancel"),
// //             ),
// //
// //             ElevatedButton(
// //               onPressed: () async {
// //
// //                 Navigator.pop(context);
// //
// //                 await placeOrder(context);
// //
// //               },
// //               child: const Text("Confirm"),
// //             ),
// //
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   /// ================= PLACE ORDER =================
// //   Future<void> placeOrder(BuildContext context) async {
// //
// //     final cart = context.read<CartProvider>();
// //
// //     final user = Supabase.instance.client.auth.currentUser;
// //
// //     if (user == null) {
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Please login first")),
// //       );
// //
// //       return;
// //     }
// //
// //     try {
// //
// //       final orderService = OrderService();
// //
// //       await orderService.placeOrder(
// //         userId: user.id,
// //         items: cart.items,
// //         totalAmount: cart.totalAmount,
// //       );
// //
// //       await cart.clearCart();
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Order placed successfully")),
// //       );
// //
// //     } catch (e) {
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Order failed: $e")),
// //       );
// //     }
// //   }
// //
// //   /// ================= BUILD =================
// //   @override
// //   Widget build(BuildContext context) {
// //
// //     final cart = context.watch<CartProvider>();
// //
// //     return Scaffold(
// //
// //       appBar: AppBar(
// //         title: Text("Cart (${cart.items.length} items)"),
// //         centerTitle: true,
// //       ),
// //
// //       /// ================= CART LIST =================
// //       body: cart.items.isEmpty
// //
// //           ? const Center(
// //         child: Text(
// //           "Your cart is empty",
// //           style: TextStyle(fontSize: 18),
// //         ),
// //       )
// //
// //           : ListView.builder(
// //
// //         padding: const EdgeInsets.only(bottom: 120),
// //
// //         itemCount: cart.items.length,
// //
// //         itemBuilder: (context, index) {
// //
// //           final item = cart.items[index];
// //
// //           return Container(
// //
// //             margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// //
// //             padding: const EdgeInsets.all(12),
// //
// //             decoration: BoxDecoration(
// //
// //               color: Colors.white,
// //
// //               borderRadius: BorderRadius.circular(14),
// //
// //               boxShadow: const [
// //                 BoxShadow(
// //                   color: Colors.black12,
// //                   blurRadius: 6,
// //                   offset: Offset(0, 3),
// //                 )
// //               ],
// //             ),
// //
// //             child: Row(
// //               children: [
// //
// //                 /// IMAGE
// //                 ClipRRect(
// //                   borderRadius: BorderRadius.circular(10),
// //                   child: Image.asset(
// //                     item.product.image,
// //                     width: 70,
// //                     height: 70,
// //                     fit: BoxFit.cover,
// //                   ),
// //                 ),
// //
// //                 const SizedBox(width: 12),
// //
// //                 /// PRODUCT INFO
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //
// //                       Text(
// //                         item.product.name,
// //                         style: const TextStyle(
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.w600,
// //                         ),
// //                       ),
// //
// //                       const SizedBox(height: 6),
// //
// //                       Text(
// //                         "₹ ${item.product.price}",
// //                         style: const TextStyle(
// //                           fontSize: 14,
// //                           color: Colors.grey,
// //                         ),
// //                       ),
// //
// //                       // const SizedBox(height: 10),
// //
// //                       /// QUANTITY CONTROLLER
// //                       Container(
// //                         decoration: BoxDecoration(
// //                           border: Border.all(color: Colors.grey),
// //                           borderRadius: BorderRadius.circular(8),
// //                         ),
// //
// //                         child: Row(
// //                           mainAxisSize: MainAxisSize.min,
// //                           children: [
// //
// //                             IconButton(
// //                               icon: const Icon(Icons.remove),
// //                               onPressed: () {
// //                                 cart.decreaseQty(item.product.id);
// //                               },
// //                             ),
// //
// //                             Text(
// //                               "${item.quantity}",
// //                               style: const TextStyle(
// //                                 fontSize: 14,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //
// //                             IconButton(
// //                               icon: const Icon(Icons.add),
// //                               onPressed: () {
// //                                 cart.increaseQty(item.product.id);
// //                               },
// //                             ),
// //
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //
// //                 /// ITEM TOTAL PRICE
// //                 // Text(
// //                 //   "₹ ${(item.product.price * item.quantity).toStringAsFixed(0)}",
// //                 //   style: const TextStyle(
// //                 //     fontWeight: FontWeight.bold,
// //                 //     fontSize: 16,
// //                 //   ),
// //                 // ),
// //
// //
// //                 Column(
// //                   children: [
// //
// //                     Text(
// //                       "₹ ${(item.product.price * item.quantity).toStringAsFixed(0)}",
// //                       style: const TextStyle(
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 16,
// //                       ),
// //                     ),
// //
// //                     const SizedBox(height: 6),
// //
// //                     IconButton(
// //                       icon: const Icon(Icons.delete_outline, color: Colors.red),
// //                       onPressed: () {
// //                         cart.removeItem(item.product.id);
// //                       },
// //                     ),
// //
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //
// //       /// ================= CHECKOUT BAR =================
// //       bottomNavigationBar: cart.items.isEmpty
// //           ? BottomNavigationBar(
// //
// //         type: BottomNavigationBarType.fixed,
// //
// //         currentIndex: _selectedIndex,
// //
// //         selectedItemColor: Colors.blue,
// //
// //         unselectedItemColor: Colors.grey,
// //
// //         onTap: _onItemTapped,
// //
// //         items: const [
// //
// //           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
// //
// //           BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Category'),
// //
// //           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
// //
// //           BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
// //         ],
// //       )
// //
// //           : Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //
// //           Container(
// //
// //             padding: const EdgeInsets.all(16),
// //
// //             decoration: const BoxDecoration(
// //               color: Colors.white,
// //               boxShadow: [
// //                 BoxShadow(color: Colors.black12, blurRadius: 8)
// //               ],
// //             ),
// //
// //             child: Row(
// //               children: [
// //
// //                 /// TOTAL
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //
// //                       const Text(
// //                         "Total",
// //                         style: TextStyle(color: Colors.grey),
// //                       ),
// //
// //                       Text(
// //                         "₹ ${cart.totalAmount.toStringAsFixed(0)}",
// //                         style: const TextStyle(
// //                           fontSize: 20,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //
// //                 ElevatedButton(
// //                   style: ElevatedButton.styleFrom(
// //                     padding: const EdgeInsets.symmetric(
// //                         horizontal: 24, vertical: 14),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                   ),
// //                   onPressed: () {
// //                     showConfirmDialog(context);
// //                   },
// //                   child: const Text(
// //                     "Place Order",
// //                     style: TextStyle(fontSize: 16),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //
// //           BottomNavigationBar(
// //
// //             type: BottomNavigationBarType.fixed,
// //
// //             currentIndex: _selectedIndex,
// //
// //             selectedItemColor: Colors.blue,
// //
// //             unselectedItemColor: Colors.grey,
// //
// //             onTap: _onItemTapped,
// //
// //             items: const [
// //
// //               BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
// //
// //               BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Category'),
// //
// //               BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
// //
// //               BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// //
