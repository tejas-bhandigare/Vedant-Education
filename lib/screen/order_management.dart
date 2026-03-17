import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {

  final supabase = Supabase.instance.client;

  List orders = [];
  bool loading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future fetchOrders() async {
    setState(() => loading = true);
    final response = await supabase
        .from('orders')
        .select('*, order_items(*)')
        .order('created_at', ascending: false);

    setState(() {
      orders = response;
      loading = false;
    });
  }

  List get pendingOrders =>
      orders.where((o) {
        final status = (o['status'] ?? '').toLowerCase();
        return status == 'pending' || status == 'placed' || status == '';
      }).toList();

  List get processingOrders =>
      orders.where((o) => (o['status'] ?? '').toLowerCase() == 'processing').toList();

  List get completedOrders =>
      orders.where((o) => (o['status'] ?? '').toLowerCase() == 'completed').toList();

  // Short order ID display e.g. #ORD-7721
  String _shortOrderId(String? id) {
    if (id == null) return '#ORD-0000';
    final short = id.replaceAll('-', '').substring(0, 4).toUpperCase();
    return '#ORD-$short';
  }

  // Total quantity across all items
  int _totalQty(List items) {
    if (items.isEmpty) return 0;
    return items.fold(0, (sum, i) => sum + ((i['quantity'] ?? 1) as int));
  }

  // Product names
  String _getProductNames(List items) {
    if (items.isEmpty) return "No items";
    return items.map((i) => "${i['product_name']} x${i['quantity']}").join(", ");
  }

  // Status badge color
  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'processing':
        return const Color(0xFF5B8DEF);
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  // Avatar color from name
  Color _avatarColor(String? name) {
    const colors = [
      Color(0xFFB39DDB),
      Color(0xFF80CBC4),
      Color(0xFFFFCC80),
      Color(0xFFEF9A9A),
      Color(0xFF90CAF9),
    ];
    if (name == null || name.isEmpty) return colors[0];
    return colors[name.codeUnitAt(0) % colors.length];
  }

  String _initials(String? name) {
    if (name == null || name.isEmpty) return '?';
    return name.trim()[0].toUpperCase();
  }

  // ── UPDATE STATUS ────────────────────────────────────────
  Future<void> _updateStatus(String orderId, String status) async {
    await supabase
        .from('orders')
        .update({'status': status}).eq('id', orderId);
    fetchOrders();
  }

  // ── ORDER CARD ───────────────────────────────────────────
  Widget _buildOrderCard(Map order, String tabType) {
    final items = List.from(order['order_items'] ?? []);
    final name = order['customer_name'] ?? 'Unknown';
    final orderId = _shortOrderId(order['id']?.toString());
    final qty = _totalQty(items);
    final status = order['status'] ?? 'pending';
    final statusColor = _statusColor(status);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── TOP ROW ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 22,
                  backgroundColor: _avatarColor(name),
                  child: Text(
                    _initials(name),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name + order info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "$orderId • Qty: $qty",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, indent: 14, endIndent: 14),

          // ── BOTTOM ACTIONS ───────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: _buildActions(order, items, tabType),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(Map order, List items, String tabType) {
    final orderId = order['id']?.toString() ?? '';

    if (tabType == 'pending') {
      return Row(
        children: [
          // Reject button
          Expanded(
            child: OutlinedButton(
              onPressed: () => _confirmAction(
                title: "Reject Order",
                message: "Are you sure you want to reject this order?",
                onConfirm: () => _updateStatus(orderId, 'cancelled'),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                "Reject",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Verify button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () => _confirmAction(
                title: "Verify Order",
                message: "Move this order to Processing?",
                onConfirm: () => _updateStatus(orderId, 'processing'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2ECC71),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
              ),
              child: const Text(
                "Verify Order",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      );
    }

    if (tabType == 'processing') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _confirmAction(
            title: "Mark as Completed",
            message: "Mark this order as completed?",
            onConfirm: () => _updateStatus(orderId, 'completed'),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2B8EF5),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 13),
            elevation: 0,
          ),
          child: const Text(
            "Mark as Completed",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      );
    }

    // Completed
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.check_circle, color: Color(0xFF2ECC71), size: 16),
        SizedBox(width: 6),
        Text(
          "Order Finalized",
          style: TextStyle(
            color: Color(0xFF2ECC71),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  void _confirmAction({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2B8EF5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(List tabOrders, String tabType) {
    if (tabOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              "No ${tabType} orders",
              style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: tabOrders.length,
      itemBuilder: (context, index) =>
          _buildOrderCard(tabOrders[index], tabType),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      appBar: AppBar(
        title: const Text(
          "Order Management",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2B8EF5),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: fetchOrders,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          tabs: [
            Tab(text: "Pending (${pendingOrders.length})"),
            Tab(text: "Processing (${processingOrders.length})"),
            Tab(text: "Completed (${completedOrders.length})"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent(pendingOrders, 'pending'),
          _buildTabContent(processingOrders, 'processing'),
          _buildTabContent(completedOrders, 'completed'),
        ],
      ),
    );
  }
}











// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class OrderScreen extends StatefulWidget {
//   const OrderScreen({super.key});
//
//   @override
//   State<OrderScreen> createState() => _OrderScreenState();
// }
//
// class _OrderScreenState extends State<OrderScreen> {
//
//   final supabase = Supabase.instance.client;
//
//   List orders = [];
//   bool loading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchOrders();
//   }
//
//   Future fetchOrders() async {
//
//     // Join order_items so we get product names + prices
//     final response = await supabase
//         .from('orders')
//         .select('*, order_items(*)')
//         .order('created_at', ascending: false);
//
//     setState(() {
//       orders = response;
//       loading = false;
//     });
//   }
//
//   // Helper: get product names from order_items list
//   String _getProductNames(List items) {
//     if (items.isEmpty) return "No items";
//     return items.map((i) => "${i['product_name']} x${i['quantity']}").join(", ");
//   }
//
//   // Helper: get total price from order_items list
//   String _getTotalPrice(order) {
//     // total_amount is already in orders table
//     return order['total_amount']?.toString() ?? "0";
//   }
//
//   Color _statusColor(String? status) {
//     switch (status?.toLowerCase()) {
//       case 'completed': return Colors.green;
//       case 'cancelled': return Colors.red;
//       default: return Colors.orange;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     if (loading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Order Management"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               setState(() => loading = true);
//               fetchOrders();
//             },
//           )
//         ],
//       ),
//
//       body: orders.isEmpty
//           ? const Center(child: Text("No orders yet"))
//           : ListView.builder(
//         padding: const EdgeInsets.all(10),
//         itemCount: orders.length,
//         itemBuilder: (context, index) {
//
//           final order = orders[index];
//           final items = List.from(order['order_items'] ?? []);
//
//           return Card(
//             margin: const EdgeInsets.only(bottom: 10),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: ListTile(
//               contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16, vertical: 10),
//
//               title: Text(
//                 order['customer_name'] ?? "Unknown Customer",
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//
//               subtitle: Padding(
//                 padding: const EdgeInsets.only(top: 4),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//
//                     // Address
//                     Row(children: [
//                       const Icon(Icons.location_on_outlined,
//                           size: 13, color: Colors.grey),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           order['customer_address'] ?? "No address",
//                           style: const TextStyle(
//                               fontSize: 12, color: Colors.grey),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ]),
//
//                     const SizedBox(height: 4),
//
//                     // Products from order_items
//                     Row(children: [
//                       const Icon(Icons.shopping_bag_outlined,
//                           size: 13, color: Colors.grey),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           _getProductNames(items),
//                           style: const TextStyle(
//                               fontSize: 12, color: Colors.grey),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ]),
//                   ],
//                 ),
//               ),
//
//               trailing:
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//
//                 children:[
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 7, vertical: 3),
//                     decoration: BoxDecoration(
//                       color: _statusColor(order['status']).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(6),
//                       border: Border.all(
//                         color: _statusColor(order['status']).withOpacity(0.4),
//                       ),
//                     ),
//                     child: Text(
//                       order['status'] ?? "placed",
//                       style: TextStyle(
//                         color: _statusColor(order['status']),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     "₹${_getTotalPrice(order)}",
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 15),
//                   ),
//                 ],
//               ),
//
//               onTap: () => _showOrderDetails(order, items),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _showOrderDetails(Map order, List items) {
//
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text("Order Details"),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               _detailRow(Icons.person_outline, "Customer",
//                   order['customer_name'] ?? "-"),
//               const Divider(height: 16),
//
//               _detailRow(Icons.location_on_outlined, "Address",
//                   order['customer_address'] ?? "-"),
//               const Divider(height: 16),
//
//               // List every product from order_items
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Icon(Icons.shopping_bag_outlined,
//                       size: 18, color: Colors.grey),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text("Products",
//                             style: TextStyle(
//                                 color: Colors.grey, fontSize: 12)),
//                         ...items.map((item) => Padding(
//                           padding: const EdgeInsets.only(top: 4),
//                           child: Text(
//                             "${item['product_name']}  x${item['quantity']}  — ₹${item['price']}",
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         )),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const Divider(height: 16),
//
//               _detailRow(Icons.currency_rupee, "Total Amount",
//                   "₹${order['total_amount'] ?? 0}"),
//               const Divider(height: 16),
//
//               _detailRow(Icons.info_outline, "Status",
//                   order['status'] ?? "placed"),
//
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Close"),
//           ),
//           if (order['status'] != 'completed')
//             ElevatedButton(
//               onPressed: () async {
//                 Navigator.pop(context);
//                 await _markCompleted(order['id']);
//               },
//               child: const Text("Mark Completed"),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _detailRow(IconData icon, String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, size: 18, color: Colors.grey),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(label,
//                   style: const TextStyle(color: Colors.grey, fontSize: 12)),
//               Text(value,
//                   style: const TextStyle(
//                       fontWeight: FontWeight.w500, fontSize: 14)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<void> _markCompleted(String orderId) async {
//     await supabase
//         .from('orders')
//         .update({'status': 'completed'})
//         .eq('id', orderId);
//     fetchOrders();
//   }
// }
//








// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class OrderScreen extends StatefulWidget {
//   const OrderScreen({super.key});
//
//   @override
//   State<OrderScreen> createState() => _OrderScreenState();
// }
//
// class _OrderScreenState extends State<OrderScreen> {
//
//   final supabase = Supabase.instance.client;
//
//   List orders = [];
//   bool loading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchOrders();
//   }
//
//   Future fetchOrders() async {
//
//     final response = await supabase
//         .from('orders')
//         .select()
//         .order('created_at', ascending: false);
//
//     setState(() {
//       orders = response;
//       loading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     if (loading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Order Management"),
//       ),
//
//       body: ListView.builder(
//         itemCount: orders.length,
//         itemBuilder: (context, index) {
//
//           final order = orders[index];
//
//           return Card(
//             margin: const EdgeInsets.all(10),
//
//             child: ListTile(
//               title: Text(order['customer_name'] ?? "Unknown Customer"),
//
//               subtitle: Text(
//                 "Product: ${order['product_name'] ?? "Unknown"} \nOrder ID: ${order['id'] ?? ""}",
//               ),
//
//               trailing: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     order['status'] ?? "Pending",
//                     style: TextStyle(
//                       color: order['status'] == "Completed"
//                           ? Colors.green
//                           : Colors.orange,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//
//                   Text("\$${order['price'] ?? 0}"),
//                 ],
//               ),
//
//
//               onTap: () {
//                 _showOrderDetails(order);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _showOrderDetails(Map order) {
//
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//
//         title: const Text("Order Details"),
//
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//
//           children: [
//
//             Text("Customer: ${order['customer_name']}"),
//             Text("Product: ${order['product_name']}"),
//             Text("Price: \$${order['price']}"),
//             Text("Status: ${order['status']}"),
//
//           ],
//         ),
//
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Close"),
//           )
//         ],
//       ),
//     );
//   }
// }