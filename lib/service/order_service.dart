import 'package:supabase_flutter/supabase_flutter.dart';

class CartService {
  final supabase = Supabase.instance.client;

  /// 🔵 STEP A — Get active cart of current user
  Future<String?> getActiveCartId() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final response = await supabase
        .from('carts')
        .select('id')
        .eq('user_id', user.id)
        .eq('status', 'active')
        .maybeSingle();

    return response?['id'];
  }

  /// 🔵 STEP B — Create cart if not exists
  Future<String> createCart() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    print("CREATING CART FOR USER = ${user.id}");

    final response = await supabase
        .from('carts')
        .insert({
      'user_id': user.id,
      'status': 'active',
    })
        .select('id')
        .single();

    print("CART CREATED = ${response['id']}");

    return response['id'];
  }


  /// 🔵 STEP D — Fetch cart items (for cart screen)
  Stream<List<Map<String, dynamic>>> getCartItems() {
    return supabase
        .from('cart_items')
        .stream(primaryKey: ['id']);
  }

  Future<void> addToCart({required String productId, required double price}) async {}
}
