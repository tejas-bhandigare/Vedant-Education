import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../provider/cart_provider.dart';

class ProductDetailsPage extends StatelessWidget {
  final String title;
  final String productId;
  final double price;

  const ProductDetailsPage({
    super.key,
    required this.title,
    required this.productId,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {

    // ✅ CREATE PRODUCT OBJECT
    final product = Product(
      id: productId,
      name: title,
      price: price,
      image: "assets/image/sakshi.png",
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),

      // 🔵 ADD TO CART BUTTON
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () {
            print("🔥 ADD TO CART CLICKED");

            // ✅ SEND TO PROVIDER
            context.read<CartProvider>().addToCart(product);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Added to Cart")),
            );
          },
          child: const Text("Add to Cart"),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                "assets/image/sakshi.png",
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "₹$price",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "This is the product description. Books included with preview only option.",
            ),

            const SizedBox(height: 16),

            bookRow(context, "Book 1"),
            bookRow(context, "Book 2"),
            bookRow(context, "Book 3"),
            bookRow(context, "Book 4"),
          ],
        ),
      ),
    );
  }

  Widget bookRow(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Image.asset("assets/image/sakshi.png", height: 50, width: 50),
          const SizedBox(width: 10),
          Expanded(
            child: Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          OutlinedButton(
            onPressed: () => showPdfPreview(context),
            child: const Text("Preview only"),
          ),
        ],
      ),
    );
  }

  void showPdfPreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return const Dialog(
          child: SizedBox(
            height: 200,
            child: Center(child: Text("PDF Preview Here")),
          ),
        );
      },
    );
  }
}







// import 'package:flutter/material.dart';
// import '../service/order_service.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ProductDetailsPage(
//         title: "Sample Product",
//         productId: "demo123",   // 🔥 temporary demo id
//         price: 749,             // 🔥 temporary demo price
//       ),
//     );
//   }
// }
//
// class ProductDetailsPage extends StatelessWidget {
//   // ✅ SERVICE OBJECT (ADD HERE)
//   final CartService cartService = CartService();
//
//   // ✅ REQUIRED VARIABLES
//   final String title;
//   final String productId;
//   final double price;
//
//    ProductDetailsPage({
//     super.key,
//     required this.title,
//     required this.productId,
//     required this.price,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//         centerTitle: true,
//       ),
//
//       // 🔵 ADD TO CART BUTTON (MAIN BUTTON)
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(12),
//         child: ElevatedButton(
//           onPressed: () async {
//
//             print("🔥 ADD TO CART CLICKED");
//
//             await cartService.addToCart(
//               productId: productId,
//               price: price,
//             );
//
//             print("🔥 ADD TO CART FUNCTION FINISHED");
//
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Added to Cart")),
//             );
//           },
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(vertical: 14),
//           ),
//           child: const Text("Add to Cart"),
//         ),
//       ),
//
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // PRODUCT IMAGE
//             Container(
//               height: 200,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Image.asset(
//                 "assets/image/sakshi.png",
//                 fit: BoxFit.contain,
//               ),
//             ),
//
//             const SizedBox(height: 12),
//
//             // PRICE
//             const Text(
//               "55% OFF 1699 ₹749",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green,
//               ),
//             ),
//
//             const SizedBox(height: 8),
//
//             // DESCRIPTION
//             const Text(
//               "This is the product description. Books included with preview only option.",
//               style: TextStyle(fontSize: 14),
//             ),
//
//             const SizedBox(height: 16),
//
//             // BOOK LIST
//             bookRow(context, "Book 1"),
//             bookRow(context, "Book 2"),
//             bookRow(context, "Book 3"),
//             bookRow(context, "Book 4"),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // BOOK ROW
//   Widget bookRow(BuildContext context, String title) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade400),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Image.asset(
//             "assets/image/sakshi.png",
//             height: 50,
//             width: 50,
//             fit: BoxFit.contain,
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           OutlinedButton(
//             onPressed: () => showPdfPreview(context),
//             child: const Text("Preview only"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // PDF POPUP
//   void showPdfPreview(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) {
//         return Dialog(
//           insetPadding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 color: Colors.grey.shade200,
//                 child: Row(
//                   children: [
//                     const Expanded(
//                       child: Text(
//                         "Product Details",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () => Navigator.pop(context),
//                     )
//                   ],
//                 ),
//               ),
//               const Expanded(
//                 child: Center(
//                   child: Text(
//                     "PDF Preview Here",
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }







// import 'package:flutter/material.dart';
// import '../service/order_service.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ProductDetailsPage(title: '',),
//     );
//   }
// }
//
// class ProductDetailsPage extends StatelessWidget {
//
//
//   const ProductDetailsPage({super.key, required String title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Product Details"),
//         centerTitle: true,
//       ),
//
//       // FOOTER
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(12),
//         child: ElevatedButton(
//           onPressed: () {},
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(vertical: 14),
//           ),
//           child: const Text("Add to Cart"),
//         ),
//       ),
//
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // PRODUCT IMAGE
//             Container(
//               height:200,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Image.asset(
//                 "assets/image/sakshi.png",
//                 fit: BoxFit.contain,
//               ),
//             ),
//
//             const SizedBox(height: 12),
//
//             // PRICE
//             const Text(
//               "55% OFF 1699 ₹749",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green,
//               ),
//             ),
//
//             const SizedBox(height: 8),
//
//             // DESCRIPTION
//             const Text(
//               "This is the product description. Books included with preview only option.",
//               style: TextStyle(fontSize: 14),
//             ),
//
//             const SizedBox(height: 16),
//
//             // BOOK LIST
//             bookRow(context, "Book 1"),
//             bookRow(context, "Book 2"),
//             bookRow(context, "Book 3"),
//             bookRow(context, "Book 4"),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // BOOK ROW
//   Widget bookRow(BuildContext context, String title) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade400),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           // IMAGE
//           Image.asset(
//             "assets/image/sakshi.png",
//             height: 50,
//             width: 50,
//             fit: BoxFit.contain,
//           ),
//
//           const SizedBox(width: 10),
//
//           // TITLE
//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//
//           // PREVIEW BUTTON
//           OutlinedButton(
//             onPressed: () => showPdfPreview(context),
//             child: const Text("Preview only"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // PDF POPUP
//   void showPdfPreview(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) {
//         return Dialog(
//           insetPadding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               // HEADER WITH CLOSE
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 color: Colors.grey.shade200,
//                 child: Row(
//                   children: [
//                     const Expanded(
//                       child: Text(
//                         "Product Details",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () => Navigator.pop(context),
//                     )
//                   ],
//                 ),
//               ),
//
//               // PDF AREA
//               Expanded(
//                 child: Center(
//                   child: Container(
//                     margin: const EdgeInsets.all(16),
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                     ),
//                     child: const Center(
//                       child: Text(
//                         "PDF Preview Here",
//                         style: TextStyle(fontSize: 18),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//
//               // FOOTER BUTTON
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child:ElevatedButton(
//                   onPressed: () async {
//                     await cartService.addToCart(
//                       productId: product.id,
//                       price: product.price,
//                     );
//
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("Added to Cart")),
//                     );
//                   },
//                   child: const Text("Add to Cart"),
//                 )
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }