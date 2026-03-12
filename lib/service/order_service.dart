import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cart_model.dart';

class OrderService {

  final supabase = Supabase.instance.client;

  Future<void> placeOrder({
    required String userId,
    required List<CartItem> items,
    required double totalAmount,
  }) async {

    try {

      /// 1. INSERT ORDER
      final order = await supabase
          .from('orders')
          .insert({
        'user_id': userId,
        'total_amount': totalAmount,
        'status': 'placed',
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


  /// FETCH USER ORDERS
///
///
  Future<List<Map<String, dynamic>>> fetchOrders(String userId) async {

    final response = await supabase
        .from('orders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
  // Future<List<Map<String, dynamic>>> fetchOrders(String userId) async {
  //
  //   final orders = await supabase
  //       .from('orders')
  //       .select()
  //       .eq('user_id', userId)
  //       .order('created_at', ascending: false);
  //
  //   return orders;
  // }

}







