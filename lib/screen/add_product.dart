import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _originalPriceController = TextEditingController();
  final TextEditingController _discountPercentController = TextEditingController();
  final TextEditingController _finalPriceController = TextEditingController();

  String? selectedCategory;
  List<String> imageList = ["main_img"];
  List<String> pdfList = ["main_pdf"];

  @override
  void initState() {
    super.initState();
    _originalPriceController.addListener(_calculatePrice);
    _discountPercentController.addListener(_calculatePrice);
  }

  void _calculatePrice() {
    double original = double.tryParse(_originalPriceController.text) ?? 0.0;
    double discount = double.tryParse(_discountPercentController.text) ?? 0.0;

    if (original > 0) {
      double calculated = original - (original * (discount / 100));
      _finalPriceController.text = calculated.toStringAsFixed(2);
    } else {
      _finalPriceController.text = "0.00";
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _originalPriceController.dispose();
    _discountPercentController.dispose();
    _finalPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text("Create Product Listing",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// CATEGORY
            _buildSection("Product Category", Icons.grid_view, [
              _buildDropdown("Select Category", [
                "Books",
                "Bag",
                "Certification",
                "ID Card",
                "Medals",
                "Notebooks",
                "Uniform"
              ], (val) => setState(() => selectedCategory = val)),
            ]),

            /// BOOK CLASSIFICATION
            if (selectedCategory == "Books")
              _buildSection("Book Classification", Icons.account_tree, [
                _buildDropdown("Sub Category", [
                  "Play Group",
                  "Nursery",
                  "Junior Kg",
                  "Senior Kg",
                  "English Cursive",
                  "School Diary",
                  "मराठी भाषा",
                  "ગુજરાતી ભાષા",
                  "Worksheets"
                ], (v) {}),

                const SizedBox(height: 15),

                _buildDropdown("Sub-Sub Category", [
                  "Merge Book",
                  "Subject Wise Book",
                ], (v) {}),
              ]),

            /// PRODUCT INFO
            _buildSection("General Information & Pricing", Icons.payments, [

              _buildInput(
                  "Product Title",
                  "e.g., Play Group Merge Book",
                  controller: _titleController,
                  isNumber: false),

              const SizedBox(height: 15),

              _buildInput("Description", "Enter details..."),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                      child: _buildInput(
                          "Original Price",
                          "0.00",
                          controller: _originalPriceController)),

                  const SizedBox(width: 10),

                  Expanded(
                      child: _buildInput(
                          "Discount (%)",
                          "0",
                          controller: _discountPercentController)),

                  const SizedBox(width: 10),

                  Expanded(
                      child: _buildInput(
                          "Discounted Price",
                          "0.00",
                          controller: _finalPriceController,
                          readOnly: true)),
                ],
              ),
            ]),

            /// PRODUCT MEDIA
            _buildSection("Product Media", Icons.image, [
              const Text("Images",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),

              const SizedBox(height: 10),

              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == imageList.length) {
                      return GestureDetector(
                        onTap: () => setState(() => imageList.add("new_img")),
                        child: _uploadSlot(Icons.add, true),
                      );
                    }

                    return Stack(
                      children: [
                        _uploadSlot(Icons.image, false),

                        Positioned(
                          right: 5,
                          top: 0,
                          child: GestureDetector(
                            onTap: () => setState(() => imageList.removeAt(index)),
                            child: const Icon(Icons.cancel,
                                color: Colors.red,
                                size: 18),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ]),

            /// PDF SECTION
            if (selectedCategory == "Books")
              _buildSection("Product Documents (PDF)", Icons.picture_as_pdf, [

                ...pdfList.asMap().entries.map((entry) {
                  int idx = entry.key;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.picture_as_pdf,
                              color: Colors.red),

                          const SizedBox(width: 10),

                          Expanded(child: Text("Document ${idx + 1}")),

                          if (idx > 0)
                            IconButton(
                                icon: const Icon(Icons.delete, size: 18),
                                onPressed: () =>
                                    setState(() => pdfList.removeAt(idx))),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                TextButton.icon(
                    onPressed: () => setState(() => pdfList.add("new_pdf")),
                    icon: const Icon(Icons.add_circle),
                    label: const Text("Add Another PDF")),
              ]),

            const SizedBox(height: 20),

            /// BUTTONS
            Row(
              children: [

                Expanded(
                    child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"))),

                const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {

                      if (_titleController.text.isNotEmpty) {

                        Navigator.pop(context, {
                          'title': _titleController.text,
                          'price': _finalPriceController.text,
                          'status': 'IN STOCK'
                        });

                      }

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A47D8),
                        foregroundColor: Colors.white),
                    child: const Text("Save Product"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(icon, color: Colors.blue, size: 18),
                const SizedBox(width: 10),
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ]),
              const Divider(height: 30),
              ...children
            ]),
      ),
    );
  }

  Widget _buildInput(String label, String hint,
      {TextEditingController? controller,
        bool readOnly = false,
        bool isNumber = true}) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold)),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType:
          isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor:
            readOnly ? Colors.grey.shade100 : const Color(0xFFF1F4FF),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
      String label,
      List<String> items,
      Function(String?) onChanged) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold)),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF1F4FF),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
          ),
          items: items
              .map((e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _uploadSlot(IconData icon, bool isPlus) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: isPlus
            ? Colors.blue.withOpacity(0.1)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon,
          color: isPlus ? Colors.blue : Colors.grey),
    );
  }
}






