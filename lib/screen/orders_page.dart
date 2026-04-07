import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../service/order_service.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'all';

  final _orderService = OrderService();
  Future<List<Map<String, dynamic>>>? _ordersFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) return;
      setState(() {
        switch (_tabController.index) {
          case 0: _selectedFilter = 'all'; break;
          case 1: _selectedFilter = 'placed'; break;
          case 2: _selectedFilter = 'completed'; break;
          case 3: _selectedFilter = 'cancelled'; break;
        }
      });
    });

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      _ordersFuture = _orderService.fetchOrders(userId);
    }
  }

  void _loadOrders() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null && mounted) {
      setState(() {
        _ordersFuture = _orderService.fetchOrders(userId);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _filterOrders(List<Map<String, dynamic>> orders) {
    return orders.where((order) {
      final matchesFilter = _selectedFilter == 'all' ||
          (order['status'] ?? '').toString().toLowerCase() == _selectedFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          order['id']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'placed':     return const Color(0xFF8B5CF6);
      case 'completed':  return const Color(0xFF22C55E);
      case 'cancelled':  return const Color(0xFFEF4444);
      case 'pending':    return const Color(0xFFF59E0B);
      case 'processing': return const Color(0xFF3B82F6);
      default:           return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'placed':     return Icons.shopping_bag_rounded;
      case 'completed':  return Icons.check_circle_rounded;
      case 'cancelled':  return Icons.cancel_rounded;
      case 'pending':    return Icons.access_time_rounded;
      case 'processing': return Icons.sync_rounded;
      default:           return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "My Orders",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 22),
            tooltip: "Refresh",
            onPressed: _loadOrders,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF4F46E5),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF4F46E5),
            indicatorWeight: 2.5,
            labelStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            isScrollable: true,
            tabs: const [
              Tab(text: "All"),
              Tab(text: "Placed"),
              Tab(text: "Completed"),
              Tab(text: "Cancelled"),
            ],
          ),
        ),
      ),
      body: user == null
          ? _buildLoginPrompt()
          : _ordersFuture == null
          ? _buildLoading()
          : FutureBuilder<List<Map<String, dynamic>>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          }
          if (snapshot.hasError) {
            return _buildError(snapshot.error.toString());
          }

          final allOrders = snapshot.data ?? [];
          final filtered = _filterOrders(allOrders);
          final completed = allOrders
              .where((o) => o['status'] == 'completed')
              .toList();
          final totalSpent = completed.fold<double>(
            0,
                (sum, o) =>
            sum +
                (double.tryParse(o['total_amount'].toString()) ?? 0),
          );

          return Column(
            children: [
              _buildSummaryBar(
                  allOrders.length, completed.length, totalSpent),
              _buildSearchBar(),
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                  color: const Color(0xFF4F46E5),
                  onRefresh: () async => _loadOrders(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                        12, 4, 12, 20),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _OrderCard(
                        order: filtered[index],
                        statusColor: _statusColor(
                            filtered[index]['status'] ?? ''),
                        statusIcon: _statusIcon(
                            filtered[index]['status'] ?? ''),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryBar(int total, int completed, double spent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          _StatChip(label: "Total", value: "$total"),
          const SizedBox(width: 8),
          _StatChip(
              label: "Spent",
              value: "₹${spent.toStringAsFixed(0)}",
              accent: const Color(0xFF4F46E5)),
          const SizedBox(width: 8),
          _StatChip(
              label: "Done",
              value: "$completed",
              accent: const Color(0xFF22C55E)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: "Search by order ID...",
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          prefixIcon: const Icon(Icons.search, size: 18, color: Colors.grey),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: () {
              _searchController.clear();
              setState(() => _searchQuery = '');
            },
          )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
            const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Color(0xFF4F46E5)),
          SizedBox(height: 16),
          Text("Loading your orders...",
              style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 52, color: Color(0xFFEF4444)),
          const SizedBox(height: 12),
          const Text("Something went wrong",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 6),
          Text(error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadOrders,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text("Retry"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_bag_outlined,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text("No orders found",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 6),
          const Text("Try a different filter or search term",
              style: TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_outline_rounded,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text("Please log in",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 6),
          const Text("Login to see your orders",
              style: TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }
}

// ─── Stat Chip ────────────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color? accent;

  const _StatChip({required this.label, required this.value, this.accent});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: (accent ?? Colors.grey).withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: accent ?? Colors.black87)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ─── Order Card ───────────────────────────────────────────────────────────────
class _OrderCard extends StatefulWidget {
  final Map<String, dynamic> order;
  final Color statusColor;
  final IconData statusIcon;

  const _OrderCard({
    required this.order,
    required this.statusColor,
    required this.statusIcon,
  });

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _animController;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _expandAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _animController.forward() : _animController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final orderId = order['id'].toString().substring(0, 8);
    final amount = order['total_amount'];
    final status = (order['status'] ?? 'unknown').toString();
    final date = order['created_at'].toString().substring(0, 10);
    final isCompleted = status.toLowerCase() == 'completed';
    final isCancelled = status.toLowerCase() == 'cancelled';
    final isPlaced = status.toLowerCase() == 'placed';

    return GestureDetector(
      onTap: _toggle,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        // ✅ FIX: Use ClipRRect + Stack for the left color stripe
        // instead of Border(left:...) which clips content with borderRadius
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Left color stripe
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  color: widget.statusColor,
                ),
              ),

              // Card content
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Row
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 14, 14, 14),
                      child: Row(
                        children: [
                          // Status Icon
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: widget.statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(widget.statusIcon,
                                color: widget.statusColor, size: 22),
                          ),
                          const SizedBox(width: 12),

                          // Order Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "#$orderId",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black87),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color:
                                    widget.statusColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: widget.statusColor),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Amount + Date + Chevron
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "₹$amount",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Colors.black87),
                              ),
                              const SizedBox(height: 4),
                              Text(date,
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey)),
                              const SizedBox(height: 4),
                              AnimatedRotation(
                                turns: _expanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 250),
                                child: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 18,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Expandable Action Buttons
                    SizeTransition(
                      sizeFactor: _expandAnim,
                      child: Column(
                        children: [
                          Divider(
                              height: 1,
                              color: Colors.grey.shade200,
                              indent: 12,
                              endIndent: 12),
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(12, 10, 12, 12),
                            child: Row(
                              children: [
                                if (isPlaced) ...[
                                  _ActionButton(
                                      label: "Track",
                                      icon: Icons.local_shipping_rounded,
                                      primary: true,
                                      onTap: () {}),
                                ],
                                if (isCompleted) ...[
                                  _ActionButton(
                                      label: "Invoice",
                                      icon: Icons.receipt_long_rounded,
                                      onTap: () {}),
                                  const SizedBox(width: 8),
                                  _ActionButton(
                                      label: "Reorder",
                                      icon: Icons.replay_rounded,
                                      onTap: () {}),
                                  const SizedBox(width: 8),
                                  _ActionButton(
                                      label: "Track",
                                      icon: Icons.local_shipping_rounded,
                                      primary: true,
                                      onTap: () {}),
                                ],
                                if (isCancelled) ...[
                                  _ActionButton(
                                      label: "Help",
                                      icon: Icons.support_agent_rounded,
                                      onTap: () {}),
                                  const SizedBox(width: 8),
                                  _ActionButton(
                                      label: "Reorder",
                                      icon: Icons.replay_rounded,
                                      primary: true,
                                      onTap: () {}),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Action Button ────────────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool primary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: primary ? const Color(0xFF4F46E5) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
              primary ? const Color(0xFF4F46E5) : Colors.grey.shade300,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 14,
                  color: primary ? Colors.white : Colors.black87),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: primary ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../service/order_service.dart';
//
// class OrdersPage extends StatefulWidget {
//   const OrdersPage({super.key});
//
//   @override
//   State<OrdersPage> createState() => _OrdersPageState();
// }
//
// class _OrdersPageState extends State<OrdersPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';
//   String _selectedFilter = 'all';
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _tabController.addListener(() {
//       setState(() {
//         switch (_tabController.index) {
//           case 0:
//             _selectedFilter = 'all';
//             break;
//           case 1:
//             _selectedFilter = 'completed';
//             break;
//           case 2:
//             _selectedFilter = 'cancelled';
//             break;
//         }
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   List<Map<String, dynamic>> _filterOrders(List<Map<String, dynamic>> orders) {
//     return orders.where((order) {
//       final matchesFilter = _selectedFilter == 'all' ||
//           (order['status'] ?? '').toString().toLowerCase() == _selectedFilter;
//       final matchesSearch = _searchQuery.isEmpty ||
//           order['id']
//               .toString()
//               .toLowerCase()
//               .contains(_searchQuery.toLowerCase());
//       return matchesFilter && matchesSearch;
//     }).toList();
//   }
//
//   Color _statusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'completed':
//         return const Color(0xFF22C55E);
//       case 'cancelled':
//         return const Color(0xFFEF4444);
//       case 'pending':
//         return const Color(0xFFF59E0B);
//       case 'processing':
//         return const Color(0xFF3B82F6);
//       default:
//         return Colors.grey;
//     }
//   }
//
//   IconData _statusIcon(String status) {
//     switch (status.toLowerCase()) {
//       case 'completed':
//         return Icons.check_circle_rounded;
//       case 'cancelled':
//         return Icons.cancel_rounded;
//       case 'pending':
//         return Icons.access_time_rounded;
//       case 'processing':
//         return Icons.sync_rounded;
//       default:
//         return Icons.help_outline_rounded;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final user = Supabase.instance.client.auth.currentUser;
//     final orderService = OrderService();
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6FA),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         title: const Text(
//           "My Orders",
//           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(48),
//           child: TabBar(
//             controller: _tabController,
//             labelColor: const Color(0xFF4F46E5),
//             unselectedLabelColor: Colors.grey,
//             indicatorColor: const Color(0xFF4F46E5),
//             indicatorWeight: 2.5,
//             labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
//             tabs: const [
//               Tab(text: "All"),
//               Tab(text: "Completed"),
//               Tab(text: "Cancelled"),
//             ],
//           ),
//         ),
//       ),
//       body: user == null
//           ? _buildLoginPrompt()
//           : FutureBuilder<List<Map<String, dynamic>>>(
//         future: orderService.fetchOrders(user.id),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return _buildLoading();
//           }
//           if (snapshot.hasError) {
//             return _buildError(snapshot.error.toString());
//           }
//
//           final allOrders = snapshot.data ?? [];
//           final filtered = _filterOrders(allOrders);
//           final completed =
//           allOrders.where((o) => o['status'] == 'completed').toList();
//           final totalSpent = completed.fold<double>(
//             0,
//                 (sum, o) =>
//             sum + (double.tryParse(o['total_amount'].toString()) ?? 0),
//           );
//
//           return Column(
//             children: [
//               // Summary Cards
//               _buildSummaryBar(allOrders.length, completed.length, totalSpent),
//
//               // Search Bar
//               _buildSearchBar(),
//
//               // Orders List
//               Expanded(
//                 child: filtered.isEmpty
//                     ? _buildEmptyState()
//                     : ListView.builder(
//                   padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
//                   itemCount: filtered.length,
//                   itemBuilder: (context, index) {
//                     return _OrderCard(
//                       order: filtered[index],
//                       statusColor: _statusColor(
//                           filtered[index]['status'] ?? ''),
//                       statusIcon: _statusIcon(
//                           filtered[index]['status'] ?? ''),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildSummaryBar(int total, int completed, double spent) {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
//       child: Row(
//         children: [
//           _StatChip(label: "Total", value: "$total"),
//           const SizedBox(width: 8),
//           _StatChip(
//               label: "Spent",
//               value: "₹${spent.toStringAsFixed(0)}",
//               accent: const Color(0xFF4F46E5)),
//           const SizedBox(width: 8),
//           _StatChip(label: "Done", value: "$completed",
//               accent: const Color(0xFF22C55E)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
//       child: TextField(
//         controller: _searchController,
//         onChanged: (v) => setState(() => _searchQuery = v),
//         decoration: InputDecoration(
//           hintText: "Search by order ID...",
//           hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
//           prefixIcon: const Icon(Icons.search, size: 18, color: Colors.grey),
//           suffixIcon: _searchQuery.isNotEmpty
//               ? IconButton(
//             icon: const Icon(Icons.close, size: 16),
//             onPressed: () {
//               _searchController.clear();
//               setState(() => _searchQuery = '');
//             },
//           )
//               : null,
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding:
//           const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade200),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade200),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide:
//             const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoading() {
//     return const Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CircularProgressIndicator(color: Color(0xFF4F46E5)),
//           SizedBox(height: 16),
//           Text("Loading your orders...",
//               style: TextStyle(color: Colors.grey, fontSize: 14)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildError(String error) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(Icons.error_outline_rounded,
//               size: 52, color: Color(0xFFEF4444)),
//           const SizedBox(height: 12),
//           const Text("Something went wrong",
//               style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
//           const SizedBox(height: 6),
//           Text(error,
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Colors.grey, fontSize: 13)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey.shade300),
//           const SizedBox(height: 16),
//           const Text("No orders found",
//               style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
//           const SizedBox(height: 6),
//           const Text("Try a different filter or search term",
//               style: TextStyle(color: Colors.grey, fontSize: 13)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLoginPrompt() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.lock_outline_rounded,
//               size: 64, color: Colors.grey.shade300),
//           const SizedBox(height: 16),
//           const Text("Please log in",
//               style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
//           const SizedBox(height: 6),
//           const Text("Login to see your orders",
//               style: TextStyle(color: Colors.grey, fontSize: 13)),
//         ],
//       ),
//     );
//   }
// }
//
// // ─── Stat Chip ────────────────────────────────────────────────────────────────
// class _StatChip extends StatelessWidget {
//   final String label;
//   final String value;
//   final Color? accent;
//
//   const _StatChip({required this.label, required this.value, this.accent});
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         decoration: BoxDecoration(
//           color: (accent ?? Colors.grey).withOpacity(0.08),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           children: [
//             Text(value,
//                 style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                     color: accent ?? Colors.black87)),
//             const SizedBox(height: 2),
//             Text(label,
//                 style: const TextStyle(fontSize: 10, color: Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ─── Order Card ───────────────────────────────────────────────────────────────
// class _OrderCard extends StatefulWidget {
//   final Map<String, dynamic> order;
//   final Color statusColor;
//   final IconData statusIcon;
//
//   const _OrderCard({
//     required this.order,
//     required this.statusColor,
//     required this.statusIcon,
//   });
//
//   @override
//   State<_OrderCard> createState() => _OrderCardState();
// }
//
// class _OrderCardState extends State<_OrderCard>
//     with SingleTickerProviderStateMixin {
//   bool _expanded = false;
//   late AnimationController _animController;
//   late Animation<double> _expandAnim;
//
//   @override
//   void initState() {
//     super.initState();
//     _animController = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 250));
//     _expandAnim = CurvedAnimation(
//         parent: _animController, curve: Curves.easeInOut);
//   }
//
//   @override
//   void dispose() {
//     _animController.dispose();
//     super.dispose();
//   }
//
//   void _toggle() {
//     setState(() => _expanded = !_expanded);
//     _expanded ? _animController.forward() : _animController.reverse();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final order = widget.order;
//     final orderId = order['id'].toString().substring(0, 8);
//     final amount = order['total_amount'];
//     final status = (order['status'] ?? 'unknown').toString();
//     final date = order['created_at'].toString().substring(0, 10);
//     final isCompleted = status.toLowerCase() == 'completed';
//     final isCancelled = status.toLowerCase() == 'cancelled';
//
//     return GestureDetector(
//       onTap: _toggle,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         margin: const EdgeInsets.only(bottom: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border(
//             left: BorderSide(color: widget.statusColor, width: 4),
//             top: BorderSide(color: Colors.grey.shade100),
//             right: BorderSide(color: Colors.grey.shade100),
//             bottom: BorderSide(color: Colors.grey.shade100),
//           ),
//         ),
//         child: Column(
//           children: [
//             // Main Row
//             Padding(
//               padding: const EdgeInsets.all(14),
//               child: Row(
//                 children: [
//                   // Icon
//                   Container(
//                     width: 42,
//                     height: 42,
//                     decoration: BoxDecoration(
//                       color: widget.statusColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(widget.statusIcon,
//                         color: widget.statusColor, size: 22),
//                   ),
//                   const SizedBox(width: 12),
//
//                   // Info
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "#$orderId",
//                           style: const TextStyle(
//                               fontWeight: FontWeight.w600, fontSize: 14),
//                         ),
//                         const SizedBox(height: 4),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: widget.statusColor.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             status,
//                             style: TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w600,
//                                 color: widget.statusColor),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Right side
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         "₹$amount",
//                         style: const TextStyle(
//                             fontWeight: FontWeight.w700, fontSize: 15),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(date,
//                           style: const TextStyle(
//                               fontSize: 11, color: Colors.grey)),
//                       const SizedBox(height: 4),
//                       AnimatedRotation(
//                         turns: _expanded ? 0.5 : 0,
//                         duration: const Duration(milliseconds: 250),
//                         child: const Icon(Icons.keyboard_arrow_down_rounded,
//                             size: 18, color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             // Expanded Actions
//             SizeTransition(
//               sizeFactor: _expandAnim,
//               child: Column(
//                 children: [
//                   Divider(height: 1, color: Colors.grey.shade100),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
//                     child: Row(
//                       children: [
//                         if (isCompleted) ...[
//                           _ActionButton(
//                               label: "Invoice",
//                               icon: Icons.receipt_long_rounded,
//                               onTap: () {}),
//                           const SizedBox(width: 8),
//                           _ActionButton(
//                               label: "Reorder",
//                               icon: Icons.replay_rounded,
//                               onTap: () {}),
//                           const SizedBox(width: 8),
//                           _ActionButton(
//                               label: "Track",
//                               icon: Icons.local_shipping_rounded,
//                               primary: true,
//                               onTap: () {}),
//                         ],
//                         if (isCancelled) ...[
//                           _ActionButton(
//                               label: "Help",
//                               icon: Icons.support_agent_rounded,
//                               onTap: () {}),
//                           const SizedBox(width: 8),
//                           _ActionButton(
//                               label: "Reorder",
//                               icon: Icons.replay_rounded,
//                               primary: true,
//                               onTap: () {}),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ─── Action Button ────────────────────────────────────────────────────────────
// class _ActionButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final bool primary;
//   final VoidCallback onTap;
//
//   const _ActionButton({
//     required this.label,
//     required this.icon,
//     required this.onTap,
//     this.primary = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 9),
//           decoration: BoxDecoration(
//             color: primary ? const Color(0xFF4F46E5) : Colors.transparent,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               color: primary
//                   ? const Color(0xFF4F46E5)
//                   : Colors.grey.shade300,
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon,
//                   size: 14,
//                   color: primary ? Colors.white : Colors.black87),
//               const SizedBox(width: 4),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: primary ? Colors.white : Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//









// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../service/order_service.dart';
//
// class OrdersPage extends StatelessWidget {
//   const OrdersPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     final user = Supabase.instance.client.auth.currentUser;
//     final orderService = OrderService();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Orders"),
//       ),
//
//       body: user == null
//           ? const Center(
//         child: Text("Please login to see your orders"),
//       )
//           : FutureBuilder<List<Map<String, dynamic>>>(
//
//         future: orderService.fetchOrders(user.id),
//
//         builder: (context, snapshot) {
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           if (snapshot.hasError) {
//             return Center(
//               child: Text("Error: ${snapshot.error}"),
//             );
//           }
//
//           final orders = snapshot.data ?? [];
//
//           if (orders.isEmpty) {
//             return const Center(
//               child: Text("No orders yet"),
//             );
//           }
//
//           return ListView.builder(
//             itemCount: orders.length,
//
//             itemBuilder: (context, index) {
//
//               final order = orders[index];
//
//               return Card(
//                 margin: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//
//                 child: ListTile(
//                   leading: const Icon(Icons.shopping_bag),
//
//                   title: Text(
//                     "Order ID: ${order['id'].toString().substring(0, 8)}",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//
//                   subtitle: Text(
//                     "₹${order['total_amount']} | ${order['status']}",
//                   ),
//
//                   trailing: Text(
//                     order['created_at']
//                         .toString()
//                         .substring(0, 10),
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }