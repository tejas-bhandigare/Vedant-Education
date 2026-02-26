import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'account_screen.dart';
import 'category_screen.dart';
import 'home.dart';
import '../provider/cart_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  int _selectedIndex = 3; // Cart selected

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

  @override
  Widget build(BuildContext context) {

    // ✅ LISTEN TO PROVIDER
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),

      body: cart.items.isEmpty
          ? const Center(
        child: Text(
          "Cart is empty",
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {

          final item = cart.items[index];

          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(

              // ✅ PRODUCT IMAGE
              leading: Image.asset(
                item.product.image,
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),

              // ✅ PRODUCT NAME
              title: Text(item.product.name),

              // ✅ CLEAN SUBTITLE (NO OVERFLOW)
              subtitle: Text(
                "Qty: ${item.quantity}   |   ₹ ${item.product.price}",
              ),

              // 🔥 FIXED TRAILING (NO COLUMN NOW)
              trailing: SizedBox(
                width: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        cart.decreaseQty(item.product.id);
                      },
                    ),

                    Text("${item.quantity}"),

                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        cart.increaseQty(item.product.id);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      // ✅ YOUR ORIGINAL BOTTOM NAVIGATION (UNCHANGED)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
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






// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'account_screen.dart';
// import 'category_screen.dart';
// import 'home.dart';
// import '../provider/cart_provider.dart';
//
// class CartPage extends StatefulWidget {
//   const CartPage({super.key});
//
//   @override
//   State<CartPage> createState() => _CartPageState();
// }
//
// // 🔥 FIXED CLASS NAME (your code had missing class name)
// class _CartPageState extends State<CartPage> {
//
//   int _selectedIndex = 3; // Cart selected
//
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
//   @override
//   Widget build(BuildContext context) {
//
//     // ✅ LISTEN TO PROVIDER (THIS WAS MISSING)
//     final cart = context.watch<CartProvider>();
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Cart")),
//
//       /// 🔥 UPDATED BODY (PROVIDER DATA)
//       body: cart.items.isEmpty
//           ? const Center(
//         child: Text(
//           "Cart is empty",
//           style: TextStyle(fontSize: 18),
//         ),
//       )
//           : ListView.builder(
//         itemCount: cart.items.length,
//         itemBuilder: (context, index) {
//
//           final item = cart.items[index];
//
//           return Card(
//             margin: const EdgeInsets.all(12),
//             child: ListTile(
//               leading: Image.asset(
//                 item.product.image,
//                 width: 60,
//                 height: 40,
//               ),
//
//               title: Text(item.product.name),
//
//               subtitle: Text("Qty: ${item.quantity}"),
//
//               trailing: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("₹ ${item.product.price}"),
//
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//
//                       IconButton(
//                         icon: const Icon(Icons.remove),
//                         onPressed: () {
//                           cart.decreaseQty(item.product.id);
//                         },
//                       ),
//
//                       IconButton(
//                         icon: const Icon(Icons.add),
//                         onPressed: () {
//                           cart.increaseQty(item.product.id);
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.purple,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Category'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
//           BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
//         ],
//       ),
//     );
//   }
// }
//
//










// import 'package:flutter/material.dart';
//
// import 'account_screen.dart';
// import 'category_screen.dart';
// import 'home.dart';
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
//   // ✅ Cart Service Object
//   final CartService cartService = CartService();
//
//   int _selectedIndex = 3; // Cart selected
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
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
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Cart")),
//
//       /// 🔥 UPDATED BODY (LIVE CART DATA)
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: cartService.getCartItems(),
//         builder: (context, snapshot) {
//
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final items = snapshot.data!;
//
//           if (items.isEmpty) {
//             return const Center(
//               child: Text(
//                 "Cart is empty",
//                 style: TextStyle(fontSize: 18),
//               ),
//             );
//           }
//
//           return ListView.builder(
//             itemCount: items.length,
//             itemBuilder: (context, index) {
//               final item = items[index];
//
//               return Card(
//                 margin: const EdgeInsets.all(12),
//                 child: ListTile(
//                   leading: const Icon(Icons.shopping_bag),
//                   title: Text("Product: ${item['product_id']}"),
//                   subtitle: Text("Qty: ${item['quantity']}"),
//                   trailing: Text("₹ ${item['price_at_time']}"),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.purple,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Category'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
//           BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
//
// import 'account_screen.dart';
// import 'category_screen.dart';
// import 'home.dart';
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
//   final CartService cartService = CartService();
//
//   int _selectedIndex = 3; // Cart selected
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
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
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Cart")),
//       body: const Center(
//         child: Text(
//           "Cart Page",
//           style: TextStyle(fontSize: 22),
//         ),
//       ),
//
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.purple,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.grid_view),
//             label: 'Category',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Account',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Cart',
//           ),
//         ],
//       ),
//     );
//   }
// }
