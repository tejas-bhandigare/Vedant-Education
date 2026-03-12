import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../service/order_service.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Supabase.instance.client.auth.currentUser;
    final orderService = OrderService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
      ),

      body: user == null
          ? const Center(
        child: Text("Please login to see your orders"),
      )
          : FutureBuilder<List<Map<String, dynamic>>>(

        future: orderService.fetchOrders(user.id),

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const Center(
              child: Text("No orders yet"),
            );
          }

          return ListView.builder(
            itemCount: orders.length,

            itemBuilder: (context, index) {

              final order = orders[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),

                child: ListTile(
                  leading: const Icon(Icons.shopping_bag),

                  title: Text(
                    "Order ID: ${order['id'].toString().substring(0, 8)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    "₹${order['total_amount']} | ${order['status']}",
                  ),

                  trailing: Text(
                    order['created_at']
                        .toString()
                        .substring(0, 10),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}