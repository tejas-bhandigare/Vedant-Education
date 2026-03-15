import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  final supabase = Supabase.instance.client;

  List orders = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future fetchOrders() async {

    final response = await supabase
        .from('orders')
        .select()
        .order('created_at', ascending: false);

    setState(() {
      orders = response;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Management"),
      ),

      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {

          final order = orders[index];

          return Card(
            margin: const EdgeInsets.all(10),

            child: ListTile(
              title: Text(order['customer_name'] ?? "Unknown Customer"),

              subtitle: Text(
                "Product: ${order['product_name'] ?? "Unknown"} \nOrder ID: ${order['id'] ?? ""}",
              ),

              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    order['status'] ?? "Pending",
                    style: TextStyle(
                      color: order['status'] == "Completed"
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text("\$${order['price'] ?? 0}"),
                ],
              ),


              onTap: () {
                _showOrderDetails(order);
              },
            ),
          );
        },
      ),
    );
  }

  void _showOrderDetails(Map order) {

    showDialog(
      context: context,
      builder: (_) => AlertDialog(

        title: const Text("Order Details"),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text("Customer: ${order['customer_name']}"),
            Text("Product: ${order['product_name']}"),
            Text("Price: \$${order['price']}"),
            Text("Status: ${order['status']}"),

          ],
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }
}