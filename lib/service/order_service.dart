import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cart_model.dart';

class OrderService {
  final supabase = Supabase.instance.client;

  Future<void> placeOrder({
    required String userId,
    required List<CartItem> items,
    required double totalAmount,
    required String customerName,
    required String customerAddress,
  }) async {
    try {
      /// 1. INSERT ORDER
      final order = await supabase
          .from('orders')
          .insert({
        'user_id': userId,
        'total_amount': totalAmount,
        'status': 'placed',
        'customer_name': customerName,
        'customer_address': customerAddress,
      })
          .select()
          .single();

      final orderId = order['id'];

      /// 2. INSERT ORDER ITEMS
      for (var item in items) {
        await supabase.from('order_items').insert({
          'order_id': orderId,
          'product_id': item.product.id,
          'product_name': item.product.name,
          'price': item.product.price,
          'quantity': item.quantity,
          'image': item.product.image,
        });
      }
    } catch (e) {
      print("Order error: $e");
      rethrow;
    }
  }

  /// Fetches all orders for the user, with their order_items joined in.
  Future<List<Map<String, dynamic>>> fetchOrders(String userId) async {
    final response = await supabase
        .from('orders')
        .select('''
          *,
          items:order_items (
            product_name,
            price,
            quantity,
            image
          )
        ''')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    print("DEBUG fetchOrders → userId: $userId, count: ${response.length}");

    return List<Map<String, dynamic>>.from(response);
  }
}





// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/cart_model.dart';
//
// class OrderService {
//   final supabase = Supabase.instance.client;
//
//   Future<void> placeOrder({
//     required String userId,
//     required List<CartItem> items,
//     required double totalAmount,
//     required String customerName,
//     required String customerAddress,
//   }) async {
//     try {
//       /// 1. INSERT ORDER
//       final order = await supabase
//           .from('orders')
//           .insert({
//         'user_id': userId,
//         'total_amount': totalAmount,
//         'status': 'placed',
//         'customer_name': customerName,
//         'customer_address': customerAddress,
//       })
//           .select()
//           .single();
//
//       final orderId = order['id'];
//
//       /// 2. INSERT ORDER ITEMS
//       for (var item in items) {
//         await supabase.from('order_items').insert({
//           'order_id': orderId,
//           'product_id': item.product.id,
//           'product_name': item.product.name,
//           'price': item.product.price,
//           'quantity': item.quantity,
//           'image': item.product.image,
//         });
//       }
//     } catch (e) {
//       print("Order error: $e");
//       rethrow;
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> fetchOrders(String userId) async {
//     final response = await supabase
//         .from('orders')
//         .select()
//         .eq('user_id', userId)
//         .order('created_at', ascending: false);
//
//     print("DEBUG fetchOrders → userId: $userId, count: ${response.length}");
//
//     return List<Map<String, dynamic>>.from(response);
//   }
// }
//










// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/cart_model.dart';
//
// class OrderService {
//
//   final supabase = Supabase.instance.client;
//
//   Future<void> placeOrder({
//     required String userId,
//     required List<CartItem> items,
//     required double totalAmount,
//     required String customerName,      // NEW
//     required String customerAddress,   // NEW
//   }) async {
//
//     try {
//
//       /// 1. INSERT ORDER (now includes name + address)
//       final order = await supabase
//           .from('orders')
//           .insert({
//         'user_id': userId,
//         'total_amount': totalAmount,
//         'status': 'placed',
//         'customer_name': customerName,        // NEW
//         'customer_address': customerAddress,  // NEW
//       })
//           .select()
//           .single();
//
//       final orderId = order['id'];
//
//       /// 2. INSERT ORDER ITEMS (unchanged)
//       for (var item in items) {
//
//         await supabase.from('order_items').insert({
//           'order_id': orderId,
//           'product_id': item.product.id,
//           'product_name': item.product.name,
//           'price': item.product.price,
//           'quantity': item.quantity,
//           'image': item.product.image,
//         });
//       }
//
//     } catch (e) {
//
//       print("Order error: $e");
//
//       rethrow;
//     }
//   }
//
//
//   Future<List<Map<String, dynamic>>> fetchOrders(String userId) async {
//     final response = await supabase
//         .from('orders')
//         .select()
//         .eq('user_id', userId)
//         .order('created_at', ascending: false);
//
//     print("DEBUG fetchOrders → userId: $userId, count: ${response.length}");
//
//     return List<Map<String, dynamic>>.from(response);
//   }
//   // /// FETCH USER ORDERS (unchanged)
//   // Future<List<Map<String, dynamic>>> fetchOrders(String userId) async {
//   //
//   //   final response = await supabase
//   //       .from('orders')
//   //       .select()
//   //       .eq('user_id', userId)
//   //       .order('created_at', ascending: false);
//   //
//   //   return List<Map<String, dynamic>>.from(response);
//   // }
// }
//
//
//
