import 'package:flutter/material.dart';
import '../service/auth_service.dart';
import 'account_screen.dart';
import 'cart_screen.dart';
import 'category_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Store UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final List<String> bannerImages = [
    "assets/image/SchoolDiary.jpeg",
    "assets/image/WhatsApp Image 2026-05-04 at 9.58.43 AM.jpeg",
    "assets/image/WhatsApp Image 2026-05-04 at 9.58.43 AM (1).jpeg",
    "assets/image/WhatsApp Image 2026-05-04 at 9.58.44 AM.jpeg",
  ];

  int _selectedIndex = 0;

  // ─── Full product → category mapping ───────────────────────────────────────
  // Add / edit entries here whenever new products are added to CategoryPage.
  final Map<String, String> _productCategoryMap = {
    // Bags
    "bag": "Bag",
    "school bag": "Bag",
    "travel bag": "Bag",
    "kids school bag": "Bag",
    "junior school bag": "Bag",
    "senior school bag": "Bag",
    "waterproof school bag": "Bag",
    "lightweight school bag": "Bag",
    "multi pocket bag": "Bag",
    "premium school bag": "Bag",
    // Books
    "book": "Books",
    "merged books": "Books",
    "subject wise": "Books",
    "play group": "Books",
    "nursery": "Books",
    "junior": "Books",
    "senior": "Books",
    "english cursive": "Books",
    "cursive": "Books",
    "gujarati": "Books",
    "marathi": "Books",
    // Certificates
    "certificate": "Certificate",
    // ID Cards
    "id card": "Id Card",
    "idcard": "Id Card",
    "identity": "Id Card",
    // Medals
    "medal": "Medals",
    "gold": "Medals",
    "silver": "Medals",
    "bronze": "Medals",
    // Notebooks
    "notebook": "Notebooks",
    // Progress Cards
    "progress": "Progress Card",
    "progress card": "Progress Card",
    // Papers
    "paper": "Papers",
    "sample paper": "Papers",
    "unit": "Papers",
    "test": "Papers",
    // Uniform
    "uniform": "Uniform",
    "dress": "Uniform",
    "shirt": "Uniform",
  };

  // ─── All valid categories (must match CategoryPage.categories list) ─────────
  final List<String> _allCategories = [
    "Bag",
    "Books",
    "Certificate",
    "Id Card",
    "Medals",
    "Notebooks",
    "Progress Card",
    "Papers",
    "Uniform",
  ];

  /// Resolves the best matching category for the typed query.
  /// Returns null if nothing matches.
  String? _resolveCategory(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return null;

    // 1. Direct category name match
    for (final cat in _allCategories) {
      if (cat.toLowerCase() == q || cat.toLowerCase().contains(q)) {
        return cat;
      }
    }

    // 2. Product keyword match
    for (final entry in _productCategoryMap.entries) {
      if (entry.key.contains(q) || q.contains(entry.key)) {
        return entry.value;
      }
    }

    return null;
  }

  /// Called when the user submits the search (keyboard action or tap).
  void _onSearch(String query) {
    final category = _resolveCategory(query);

    if (category != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryPage(
            categoryName: category,
            searchQuery: query.trim(),
          ),
        ),
      );
    } else {
      // No match — show a brief snackbar to guide the user.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No results found for "$query"'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CategoryPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AccountPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CartPage()),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── SEARCH BAR ────────────────────────────────────────────────
              TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: _onSearch,
                decoration: InputDecoration(
                  hintText: 'Search books, papers, bags, uniforms…',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () => _onSearch(_searchController.text),
                    tooltip: 'Search',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── CATEGORY ICON LIST ────────────────────────────────────────
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategory(Icons.book, "Books"),
                    // _buildCategory(Icons.school, "Papers"),
                    _buildCategory(Icons.menu_book, "Bag"),
                    _buildCategory(Icons.video_library, "Uniform"),
                    _buildCategory(Icons.more_horiz, "More"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── PROMO BANNER ──────────────────────────────────────────────
              _buildPromoBanner(),

              const SizedBox(height: 24),

              // ── RECOMMENDED SECTION ───────────────────────────────────────
              const Text(
                "Recommended for You",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              // ── CAROUSEL ──────────────────────────────────────────────────
              CarouselSlider(
                options: CarouselOptions(
                  height: 190,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                ),
                items: bannerImages.map((imagePath) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Back to School\nEssentials",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "up to 40% off overall \ncategory products",
            style: TextStyle(color: Colors.black, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CategoryPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0,
              side: const BorderSide(color: Colors.black12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: const Text(
              "Shop Now",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == "More") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CategoryPage()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryPage(categoryName: label),
            ),
          );
        }
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blue.shade50,
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}




