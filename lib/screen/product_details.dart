import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../provider/cart_provider.dart';
import '../data/product_data.dart';
import 'multi_pdf_viewer_screen.dart'; // ← import the viewer

class ProductDetailsPage extends StatelessWidget {

  final String productId;

  const ProductDetailsPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {

    /// FETCH PRODUCT FROM product_data.dart
    final productMap = ProductData.products[productId];

    /// SAFETY CHECK
    if (productMap == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Product not found")),
        body: const Center(child: Text("Product not found")),
      );
    }

    /// CREATE PRODUCT MODEL
    final product = Product(
      id: productId,
      name: productMap['name'],
      price: productMap['price'],
      image: productMap['image'],
    );

    final description = productMap['description'] ?? "";
    final oldPrice = productMap['oldPrice'];

    /// GRAB PDFs LIST (null if product has no PDFs e.g. bags, certificates)
    final List<Map<String, String>>? pdfs = productMap['pdfs'] != null
        ? List<Map<String, String>>.from(
      (productMap['pdfs'] as List).map(
            (e) => Map<String, String>.from(e as Map),
      ),
    )
        : null;

    final bool hasPreview = pdfs != null && pdfs.isNotEmpty;

    return Scaffold(

      appBar: AppBar(
        title: Text(product.name),
        centerTitle: true,
      ),

      /// ADD TO CART BUTTON
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () {
            context.read<CartProvider>().addToCart(product);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${product.name} added to cart")),
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

            /// PRODUCT IMAGE
            Container(
              height: 220,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  product.image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// PRICE ROW
            Row(
              children: [
                if (oldPrice != null)
                  Text(
                    "₹$oldPrice",
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(width: 10),
                Text(
                  "₹${product.price}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// DESCRIPTION TITLE
            const Text(
              "Product Description",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            /// DESCRIPTION
            Text(description, style: const TextStyle(fontSize: 14)),

            const SizedBox(height: 20),

            /// ── PDF PREVIEW SECTION ──
            /// Only shown for books that have PDFs defined in product_data.dart
            if (hasPreview) ...[
              const Text(
                "Book Preview",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // One row per PDF in the list
              ...List.generate(pdfs.length, (index) {
                final pdf = pdfs[index];
                return _bookRow(
                  context,
                  label: pdf['label'] ?? 'Book ${index + 1}',
                  onPreview: () {
                    // Open viewer starting at this specific PDF tab
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MultiPdfViewerScreen(
                          bookName: product.name,
                          pdfs: pdfs,
                          initialIndex: index, // opens at tapped PDF
                        ),
                      ),
                    );
                  },
                );
              }),
            ],

          ],
        ),
      ),
    );
  }

  /// PREVIEW ROW — one per PDF
  Widget _bookRow(
      BuildContext context, {
        required String label,
        required VoidCallback onPreview,
      }) {
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
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          OutlinedButton(
            onPressed: onPreview,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6A5AE0),
              side: const BorderSide(color: Color(0xFF6A5AE0)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text("Preview only"),
          ),
        ],
      ),
    );
  }
}












// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../models/product_model.dart';
// import '../provider/cart_provider.dart';
// import '../data/product_data.dart';
//
// class ProductDetailsPage extends StatelessWidget {
//
//    final String productId;
//
//   const ProductDetailsPage({
//     super.key,
//     required this.productId,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//
//     /// FETCH PRODUCT FROM product_data.dart
//     final productMap = ProductData.products[productId];
//
//
//     /// SAFETY CHECK
//     if (productMap == null) {
//       return Scaffold(
//         appBar: AppBar(title: const Text("Product not found")),
//         body: const Center(child: Text("Product not found")),
//       );
//     }
//
//     /// CREATE PRODUCT MODEL
//     final product = Product(
//       id: productId,
//       name: productMap['name'],
//       price: productMap['price'],
//       image: productMap['image'],
//
//     );
//
//     bool isBag = productId.startsWith("bag");
//
//     final description = productMap['description'] ?? "";
//     final oldPrice = productMap['oldPrice'];
//
//
//     bool isBook = productId.contains("Books") ||
//         productId.contains("Merged") ||
//         productId.contains("Subject Wise") ||
//         productId.contains("Worksheet") ||
//         productId.contains("Cursive") ||
//         productId.contains("मराठी");
//
//
//     return Scaffold(
//
//       appBar: AppBar(
//         title: Text(product.name),
//         centerTitle: true,
//       ),
//
//       /// ADD TO CART BUTTON
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(12),
//         child: ElevatedButton(
//           onPressed: () {
//
//             context.read<CartProvider>().addToCart(product);
//
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("${product.name} added to cart")),
//             );
//           },
//           child: const Text("Add to Cart"),
//         ),
//       ),
//
//       body: SingleChildScrollView(
//
//         padding: const EdgeInsets.all(16),
//
//         child: Column(
//
//           crossAxisAlignment: CrossAxisAlignment.start,
//
//           children: [
//
//             /// PRODUCT IMAGE
//             ///
//
//             Container(
//               height: 220,
//               width: double.infinity,
//               // decoration: BoxDecoration(
//               //   border: Border.all(color: Colors.grey),
//               //   borderRadius: BorderRadius.circular(12),
//               // ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.asset(
//                   product.image,
//                   width: double.infinity,
//                   height: double.infinity,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//
//
//
//             // Container(
//             //   height: 220,
//             //   width: double.infinity,
//             //   decoration: BoxDecoration(
//             //     border: Border.all(color: Colors.grey),
//             //     borderRadius: BorderRadius.circular(12),
//             //   ),
//             //   child: Image.asset(
//             //     product.image,
//             //     fit: BoxFit.contain,
//             //   ),
//             // ),
//
//             const SizedBox(height: 16),
//
//             /// PRICE ROW
//             Row(
//               children: [
//
//                 if (oldPrice != null)
//                   Text(
//                     "₹$oldPrice",
//                     style: const TextStyle(
//                       decoration: TextDecoration.lineThrough,
//                       color: Colors.grey,
//                     ),
//                   ),
//
//                 const SizedBox(width: 10),
//
//                 Text(
//                   "₹${product.price}",
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green,
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 12),
//
//             /// DESCRIPTION TITLE
//             const Text(
//               "Product Description",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//
//             const SizedBox(height: 6),
//
//             /// DESCRIPTION
//             Text(
//               description,
//               style: const TextStyle(fontSize: 14),
//             ),
//
//             const SizedBox(height: 20),
//
//             // /// BOOK PREVIEW SECTION
//             // bookRow(context, "Preview Book 1"),
//             // bookRow(context, "Preview Book 2"),
//
//
//         if (isBook) ...[
//     bookRow(context, "Preview Book 1"),
//     bookRow(context, "Preview Book 2"),
//     ],
//
//     // if (!isBag) ...[
//     // bookRow(context, "Preview Book 1"),
//     // bookRow(context, "Preview Book 2"),
//     // ],
//
//
//
//
//
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// PREVIEW ROW
//   Widget bookRow(BuildContext context, String title) {
//
//     return Container(
//
//       margin: const EdgeInsets.only(bottom: 10),
//
//       padding: const EdgeInsets.all(8),
//
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade400),
//         borderRadius: BorderRadius.circular(8),
//       ),
//
//       child: Row(
//
//         children: [
//
//           Image.asset("assets/image/sakshi.png", height: 50, width: 50),
//
//           const SizedBox(width: 10),
//
//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//
//           OutlinedButton(
//             onPressed: () => showPdfPreview(context),
//             child: const Text("Preview only"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// PDF PREVIEW POPUP
//   void showPdfPreview(BuildContext context) {
//
//     showDialog(
//
//       context: context,
//
//       builder: (_) {
//         return const Dialog(
//           child: SizedBox(
//             height: 200,
//             child: Center(
//               child: Text("PDF Preview Here"),
//             ),
//           ),
//         );
//       },
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
