import 'package:flutter/material.dart';

import 'order_management.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Admin Dashboard"),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.inventory),
                text: "Products",
              ),
              Tab(
                icon: Icon(Icons.shopping_cart),
                text: "Orders",
              ),
            ],
          ),
        ),

        body: const TabBarView(
          children: [

            OrderManagement(),
          ],
        ),
      ),
    );
  }
}