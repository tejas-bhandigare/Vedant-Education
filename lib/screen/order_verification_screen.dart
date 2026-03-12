import 'package:flutter/material.dart';

void main() => runApp(const OrderApp());

class OrderApp extends StatelessWidget {
  const OrderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const OrderVerificationScreen(),
    );
  }
}

class OrderVerificationScreen extends StatelessWidget {
  const OrderVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text('Order Verification', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh, color: Colors.white)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert, color: Colors.white)),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search orders, users...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All Pending (24)', isSelected: true),
                      _buildFilterChip('Processing'),
                      _buildFilterChip('Completed'),
                      _buildFilterChip('Unfulfilled'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Orders List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _buildOrderCard(
                  name: 'John Doe',
                  initials: 'JD',
                  avatarColor: Colors.blue,
                  time: '12 mins ago',
                  orderId: '#ORD-7721',
                  items: [
                    {'name': '1x iPhone 15 Pro Max', 'price': '\$1,199.00'},
                    {'name': '1x Silicone Case (Blue)', 'price': '\$49.00'},
                  ],
                  total: '\$1,248.00',
                ),
                _buildOrderCard(
                  name: 'Alice Smith',
                  initials: 'AS',
                  avatarColor: Colors.purple,
                  time: '45 mins ago',
                  orderId: '#ORD-7718',
                  items: [
                    {'name': '2x Wireless Headphones', 'price': '\$598.00'},
                  ],
                  total: '\$598.00',
                ),
                _buildOrderCard(
                  name: 'Michael Brown',
                  initials: 'MB',
                  avatarColor: Colors.orange,
                  time: '1 hour ago',
                  orderId: '#ORD-7715',
                  isNewUser: true,
                  items: [
                    {'name': '1x Mechanical Keyboard', 'price': '\$159.00'},
                  ],
                  total: '\$159.00',
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in_outlined), label: 'Verify'),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping_outlined), label: 'Shipping'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) {},
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.blue[100],
        labelStyle: TextStyle(color: isSelected ? Colors.blue[800] : Colors.black54),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildOrderCard({
    required String name,
    required String initials,
    required Color avatarColor,
    required String time,
    required String orderId,
    required List<Map<String, String>> items,
    required String total,
    bool isNewUser = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isNewUser ? const Color(0xFFE3F2FD) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          if (isNewUser)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('NEW USER FIRST ORDER',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(backgroundColor: avatarColor, child: Text(initials, style: const TextStyle(color: Colors.white))),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('Ordered: $time • $orderId', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(4)),
                        child: const Text('PENDING', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const Divider(height: 24),
                  ...items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item['name']!, style: const TextStyle(color: Colors.black87)),
                        Text(item['price']!, style: const TextStyle(color: Colors.black87)),
                      ],
                    ),
                  )),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(total, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('✕ Reject'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('✓ Verify Order'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}