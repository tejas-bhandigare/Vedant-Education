import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  bool isProductOpen = false;
  String selectedPage = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(selectedPage),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      drawer: Drawer(
        child: Container(
          color: Colors.black87,
          child: ListView(
            children: [

              const DrawerHeader(
                child: Center(
                  child: Text(
                    "ADMIN PANEL",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              sidebarItem("Dashboard"),

              /// PRODUCTS DROPDOWN
              ListTile(
                title: const Text("Products",
                    style: TextStyle(color: Colors.white)),
                trailing: Icon(
                  isProductOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
                onTap: () {
                  setState(() {
                    isProductOpen = !isProductOpen;
                  });
                },
              ),

              if (isProductOpen) ...[
                subMenuItem("Bag"),
                subMenuItem("Certificates"),
              ],

              sidebarItem("Orders"),
              sidebarItem("Logout"),
            ],
          ),
        ),
      ),

      body: getSelectedPage(),
    );
  }

  /// PAGE SWITCHER
  Widget getSelectedPage() {

    switch (selectedPage) {

      case "Dashboard":
        return const DashboardPage();

      case "Bag":
        return const BagPage();

      case "Certificates":
        return const CertificationPage();

      case "Orders":
        return const OrdersPage();

      default:
        return const DashboardPage();
    }
  }

  /// SIDEBAR ITEM
  Widget sidebarItem(String title) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        setState(() {
          selectedPage = title;
        });
        Navigator.pop(context);
      },
    );
  }

  /// SUB MENU ITEM
  Widget subMenuItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: ListTile(
        title: Text(title,
            style: const TextStyle(color: Colors.white70)),
        onTap: () {
          setState(() {
            selectedPage = title;
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}

/// ================= DASHBOARD =================

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {

    return const Center(
      child: Text(
        "Welcome Admin",
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

/// ================= BAG PAGE =================

class BagPage extends StatefulWidget {
  const BagPage({super.key});

  @override
  State<BagPage> createState() => _BagPageState();
}

class _BagPageState extends State<BagPage> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  List<Map<String, String>> bagList = [];

  void addBag() {

    if (titleController.text.isEmpty || priceController.text.isEmpty) {
      return;
    }

    setState(() {
      bagList.add({
        "title": titleController.text,
        "price": priceController.text,
        "discount": discountController.text.isEmpty
            ? "0"
            : discountController.text,
        "description": descController.text,
      });
    });

    titleController.clear();
    priceController.clear();
    discountController.clear();
    descController.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        Expanded(
          child: bagList.isEmpty
              ? const Center(child: Text("No Bags Added"))
              : ListView.builder(

            itemCount: bagList.length,

            itemBuilder: (context, index) {

              double price =
                  double.tryParse(bagList[index]["price"]!) ?? 0;

              double discount =
                  double.tryParse(bagList[index]["discount"]!) ?? 0;

              double finalPrice =
                  price - (price * discount / 100);

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    bagList[index]["title"]!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),

                  subtitle: Text(
                      bagList[index]["description"]!),

                  trailing: Text(
                    "₹${finalPrice.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        /// ADD PRODUCT FORM
        Container(

          padding: const EdgeInsets.all(15),

          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                color: Colors.black12,
              )
            ],
          ),

          child: Column(

            children: [

              const Text(
                "Add Bag Product",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: discountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Discount %",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: addBag,
                  child: const Text("Add Product"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ================= CERTIFICATION =================

class CertificationPage extends StatelessWidget {
  const CertificationPage({super.key});

  @override
  Widget build(BuildContext context) {

    return const Center(
      child: Text(
        "Certification Management",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

/// ================= ORDERS PAGE =================

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {

    return const Center(
      child: Text(
        "Orders Management",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}