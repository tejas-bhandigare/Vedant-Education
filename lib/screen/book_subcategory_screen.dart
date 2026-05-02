import 'package:flutter/material.dart';
import 'package:vedant_education_app/screen/product_details.dart';

/// ================================================================
/// BookSubCategoryScreen
/// Shows a list of sub-products (BookListTile) for a given book group.
/// Pass [groupId] which maps to [BookSubCategories.groups].
/// ================================================================

class BookSubCategoryScreen extends StatelessWidget {
  final String groupId;

  const BookSubCategoryScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final items = BookSubCategories.groups[groupId] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vedant Education"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _BookListTile(
            title: item['title']!,
            subtitle: item['subtitle']!,
            imagePath: item['image']!,
            productId: item['productId']!,
          );
        },
      ),
    );
  }
}

/// ================================================================
/// BookListTile — image left, title + subtitle right
/// ================================================================
class _BookListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final String productId;

  const _BookListTile({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailsPage(productId: productId),
        ),
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left: book cover image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // Right: title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ================================================================
/// BookSubCategories — all sub-category group definitions
/// ================================================================
class BookSubCategories {
  static const Map<String, List<Map<String, String>>> groups = {

    // ── Nursery Subject Wise ── 4 items
    "Nursery Subject Wise": [
      {
        "title": "Nursery Subjectwise Books",
        "subtitle": "English- LTI PATTERN or...",
        "image": "assets/image/Nursery.jpeg",
        "productId": "Nursery Subjectwise Books",
      },
      {
        "title": "हिंदी",
        "subtitle": "Reading Book",
        "image": "assets/image/Nursery.jpeg",
        "productId": "Nursery Hindi Reading Book",
      },
      {
        "title": "Nursery Hindi L-1",
        "subtitle": "Writing Book",
        "image": "assets/image/nursoryhindil1.jpeg",
        "productId": "Nursery Hindi L-1",
      },
      {
        "title": "Drawing Book (Optional)",
        "subtitle": "Optional\nNo Quantity Restriction ...",
        "image": "assets/image/sakshi.png",
        "productId": "Nursery Drawing Book",
      },
    ],

    // ── Junior KG Subject Wise ── 2 items
    "Junior Subject Wise": [
      {
        "title": "Junior Kg Subject wise",
        "subtitle": "English\nहिंदी 1.6.1...",
        "image": "assets/image/JuniorKgEnglish.jpeg",
        "productId": "Junior Kg Subject wise",
      },
      {
        "title": "Marathi Level 1 Book",
        "subtitle": "Level 1",
        "image": "assets/image/marathijrl1.jpeg",
        "productId": "Marathi Level 1 Book",
      },
    ],

    // ── Senior Subject Wise ── 3 items
    "Senior Subject Wise": [
      {
        "title": "Senior Kg Subjectwise",
        "subtitle": "English 1.7.1\nOR...",
        "image": "assets/image/seniorkgsubjectwise.jpeg",
        "productId": "Senior Kg Subjectwise",
      },
      {
        "title": "Marathi Level 2 Book",
        "subtitle": "Level 2",
        "image": "assets/image/MarathiL2.jpeg",
        "productId": "Marathi Level 2 Book",
      },
      {
        "title": "Marathi Level 3 Book",
        "subtitle": "Marathi Matra Book",
        "image": "assets/image/MarathiL3.jpeg",
        "productId": "Marathi Level 3 Book",
      },
    ],

    // ── Senior Merged Books ── 2 items
    "Senior Merged Books": [
      {
        "title": "Senior Kg Merge Books",
        "subtitle": "Book No. 1\nBook No. ...",
        "image": "assets/image/seniorkgmergebook5.jpeg",
        "productId": "Senior Kg Merge Books",
      },
      {
        "title": "Senior Kg Level 2",
        "subtitle": "Book No. 1\nBook No....",
        "image": "assets/image/seniorkglevel2.jpeg",
        "productId": "Senior Kg Level 2",
      },
    ],
  };
}