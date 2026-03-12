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

  /// ================= CONFIRM DIALOG =================
  void showConfirmDialog(BuildContext context) {

    final cart = context.read<CartProvider>();

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(

          title: const Text("Confirm Order"),

          content: Text(
            "Total Amount: ₹${cart.totalAmount.toStringAsFixed(2)}\n\nDo you want to place the order?",
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {

                Navigator.pop(context);

                await placeOrder(context);

              },
              child: const Text("Confirm"),
            ),

          ],
        );
      },
    );
  }

  /// ================= PLACE ORDER =================
  Future<void> placeOrder(BuildContext context) async {

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
      );

      await cart.clearCart();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully")),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order failed: $e")),
      );
    }
  }

  /// ================= BUILD =================
  @override
  Widget build(BuildContext context) {

    final cart = context.watch<CartProvider>();

    return Scaffold(

      appBar: AppBar(
        title: Text("Cart (${cart.items.length} items)"),
        centerTitle: true,
      ),

      /// ================= CART LIST =================
      body: cart.items.isEmpty

          ? const Center(
        child: Text(
          "Your cart is empty",
          style: TextStyle(fontSize: 18),
        ),
      )

          : ListView.builder(

        padding: const EdgeInsets.only(bottom: 120),

        itemCount: cart.items.length,

        itemBuilder: (context, index) {

          final item = cart.items[index];

          return Container(

            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius: BorderRadius.circular(14),

              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )
              ],
            ),

            child: Row(
              children: [

                /// IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    item.product.image,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 12),

                /// PRODUCT INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        item.product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "₹ ${item.product.price}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),

                      // const SizedBox(height: 10),

                      /// QUANTITY CONTROLLER
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                cart.decreaseQty(item.product.id);
                              },
                            ),

                            Text(
                              "${item.quantity}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                cart.increaseQty(item.product.id);
                              },
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// ITEM TOTAL PRICE
                // Text(
                //   "₹ ${(item.product.price * item.quantity).toStringAsFixed(0)}",
                //   style: const TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 16,
                //   ),
                // ),


                Column(
                  children: [

                    Text(
                      "₹ ${(item.product.price * item.quantity).toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 6),

                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        cart.removeItem(item.product.id);
                      },
                    ),

                  ],
                ),
              ],
            ),
          );
        },
      ),

      /// ================= CHECKOUT BAR =================
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

          Container(

            padding: const EdgeInsets.all(16),

            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 8)
              ],
            ),

            child: Row(
              children: [

                /// TOTAL
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Total",
                        style: TextStyle(color: Colors.grey),
                      ),

                      Text(
                        "₹ ${cart.totalAmount.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    showConfirmDialog(context);
                  },
                  child: const Text(
                    "Place Order",
                    style: TextStyle(fontSize: 16),
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
//   /// ================= CONFIRM DIALOG =================
//   void showConfirmDialog(BuildContext context) {
//
//     final cart = context.read<CartProvider>();
//
//     showDialog(
//
//       context: context,
//
//       builder: (context) {
//
//         return AlertDialog(
//
//           title: const Text("Confirm Order"),
//
//           content: Text(
//             "Total Amount: ₹${cart.totalAmount.toStringAsFixed(2)}\n\nDo you want to place the order?",
//           ),
//
//           actions: [
//
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Cancel"),
//             ),
//
//             ElevatedButton(
//               onPressed: () async {
//
//                 Navigator.pop(context);
//
//                 await placeOrder(context);
//
//               },
//               child: const Text("Confirm"),
//             ),
//
//           ],
//         );
//       },
//     );
//   }
//
//   /// ================= PLACE ORDER (SUPABASE) =================
//   Future<void> placeOrder(BuildContext context) async {
//
//     final cart = context.read<CartProvider>();
//
//     final user = Supabase.instance.client.auth.currentUser;
//
//     if (user == null) {
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please login first"),
//         ),
//       );
//
//       return;
//     }
//
//     try {
//
//       final orderService = OrderService();
//
//       await orderService.placeOrder(
//
//         userId: user.id,
//
//         items: cart.items,
//
//         totalAmount: cart.totalAmount,
//
//       );
//
//       /// CLEAR CART
//       await cart.clearCart();
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Order placed successfully"),
//         ),
//       );
//
//     } catch (e) {
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Order failed: $e"),
//         ),
//       );
//     }
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
//       appBar: AppBar(
//         title: const Text("Cart"),
//       ),
//
//       /// ================= CART LIST =================
//       body: cart.items.isEmpty
//
//           ? const Center(
//         child: Text(
//           "Cart is empty",
//           style: TextStyle(fontSize: 18),
//         ),
//       )
//
//           : ListView.builder(
//
//         itemCount: cart.items.length,
//
//         itemBuilder: (context, index) {
//
//           final item = cart.items[index];
//
//           return Card(
//
//             margin: const EdgeInsets.all(12),
//
//             child: ListTile(
//
//               leading: Image.asset(
//                 item.product.image,
//                 width: 50,
//                 height: 50,
//                 fit: BoxFit.contain,
//               ),
//
//               title: Text(item.product.name),
//
//               subtitle: Text(
//                 "Qty: ${item.quantity}   |   ₹ ${item.product.price}",
//               ),
//
//               // trailing: SizedBox(
//               //   width: 120,
//               //   child: Row(
//               //     mainAxisAlignment: MainAxisAlignment.end,
//               //     children: [
//               //
//               //       IconButton(
//               //         icon: const Icon(Icons.remove),
//               //         onPressed: () {
//               //           cart.decreaseQty(item.product.id);
//               //         },
//               //       ),
//               //
//               //       Text("${item.quantity}"),
//               //
//               //       IconButton(
//               //         icon: const Icon(Icons.add),
//               //         onPressed: () {
//               //           cart.increaseQty(item.product.id);
//               //         },
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               trailing: SizedBox(
//                 width: 160,
//                 child: Row(
//                   children: [
//
//                     IconButton(
//                       icon: const Icon(Icons.remove),
//                       onPressed: () {
//                         cart.decreaseQty(item.product.id);
//                       },
//                     ),
//
//                     SizedBox(
//                       width: 40,
//                       height: 35,
//                       child: TextFormField(
//                         initialValue: item.quantity.toString(),
//                         keyboardType: TextInputType.number,
//                         textAlign: TextAlign.center,
//                         decoration: const InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(vertical: 5),
//                           border: OutlineInputBorder(),
//                         ),
//                         onFieldSubmitted: (value) {
//
//                           int? newQty = int.tryParse(value);
//
//                           if (newQty != null && newQty > 0) {
//
//                             int diff = newQty - item.quantity;
//
//                             if (diff > 0) {
//                               for (int i = 0; i < diff; i++) {
//                                 cart.increaseQty(item.product.id);
//                               }
//                             } else if (diff < 0) {
//                               for (int i = 0; i < diff.abs(); i++) {
//                                 cart.decreaseQty(item.product.id);
//                               }
//                             }
//
//                           }
//
//                         },
//                       ),
//                     ),
//
//                     IconButton(
//                       icon: const Icon(Icons.add),
//                       onPressed: () {
//                         cart.increaseQty(item.product.id);
//                       },
//                     ),
//
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//
//       /// ================= CHECKOUT BUTTON =================
//       bottomSheet: cart.items.isEmpty
//
//           ? null
//
//           : Container(
//
//         padding: const EdgeInsets.all(12),
//
//         width: double.infinity,
//
//         child: ElevatedButton(
//
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(vertical: 14),
//           ),
//
//           onPressed: () {
//             showConfirmDialog(context);
//           },
//
//           child: const Text(
//             "Proceed to Checkout",
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//       ),
//
//       /// ================= BOTTOM NAV =================
//       bottomNavigationBar: BottomNavigationBar(
//
//         type: BottomNavigationBarType.fixed,
//
//         currentIndex: _selectedIndex,
//
//         selectedItemColor: Colors.blue,
//
//         unselectedItemColor: Colors.grey,
//
//         onTap: _onItemTapped,
//
//         items: const [
//
//           BottomNavigationBarItem(
//               icon: Icon(Icons.home), label: 'Home'),
//
//           BottomNavigationBarItem(
//               icon: Icon(Icons.grid_view), label: 'Category'),
//
//           BottomNavigationBarItem(
//               icon: Icon(Icons.person), label: 'Account'),
//
//           BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_cart), label: 'Cart'),
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
