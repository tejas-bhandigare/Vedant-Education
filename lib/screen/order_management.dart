import 'package:flutter/material.dart';

class OrderManagement extends StatelessWidget {
  const OrderManagement({super.key});

  Widget orderCard(String order, String customer, String price) {
    return Card(
      child: ListTile(
        title: Text(order),
        subtitle: Text(customer),
        trailing: Text(price),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Order Management"),
      ),

      body: ListView(
        children: [
          orderCard("Order #8492", "Alex Rivera", "\$124"),
          orderCard("Order #8488", "Sarah Chen", "\$59"),
          orderCard("Order #8491", "Jordan Smith", "\$342"),
        ],
      ),
    );
  }
}