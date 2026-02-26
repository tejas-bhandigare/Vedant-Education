import 'package:flutter/material.dart';
import 'package:vedant_education_app/screen/product_details.dart';

import 'account_screen.dart';
import 'cart_screen.dart';
import 'home.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int _selectedIndex = 1;
  int selectedCategoryIndex = 0;

  final List<String> categories = [
    "Bag",
    "Books",
    "Certificate",
    "Id Card",
    "Medals",
    "Notebooks",
    "Progress Card",
    "Results",
    "Sample Papers",
    "Uniform",
  ];

  /// ================= BOTTOM NAVIGATION =================
  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vedant Education"),
        centerTitle: true,
      ),

      /// ================= BODY =================
      body: Row(
        children: [
          /// ===== LEFT CATEGORY LIST =====
          Container(
            width: 120,
            color: Colors.grey.shade200,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => setState(() => selectedCategoryIndex = index),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: selectedCategoryIndex == index
                        ? Colors.white
                        : Colors.grey.shade200,
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        fontWeight: selectedCategoryIndex == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// ===== RIGHT CONTENT =====
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: rightContent(),
            ),
          ),
        ],
      ),

      /// ===== BOTTOM NAV =====
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
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

  /// ================= RIGHT SWITCH =================
  Widget rightContent() {
    final selected = categories[selectedCategoryIndex];

    switch (selected) {
      case "Bag":
        return bagUI();
      case "Books":
        return booksUI();
      case "Certificate":
        return certificateUI();
      case "Id Card":
        return idCardUI();
      case "Medals":
        return medalsUI();
      case "Notebooks":
        return notebooksUI();
      case "Progress Card":
        return progressCardUI();
      case "Sample Papers":
        return samplePapersUI();
      case "Uniform":
        return uniformsUI();
      default:
        return Center(
          child: Text(
            selected,
            style: const TextStyle(fontSize: 18),
          ),
        );
    }
  }
  /// ================= BAG UI =================
  Widget bagUI() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle("Bags"),
          Row(children: [
            ContentBox(title: "Bag 1", imagePath: "assets/image/sakshi.png"),
            ContentBox(title: "Bag 2", imagePath: "assets/image/sakshi.png"),
          ]),
          Row(children: [
            ContentBox(title: "Bag 3", imagePath: "assets/image/sakshi.png"),
            ContentBox(title: "Bag 4", imagePath: "assets/image/sakshi.png"),
          ]),
          Row(children: [
            ContentBox(title: "Bag 5", imagePath: "assets/image/sakshi.png"),
            ContentBox(title: "Bag 6", imagePath: "assets/image/sakshi.png"),
          ]),
          Row(children: [
            ContentBox(title: "Bag 7", imagePath: "assets/image/sakshi.png"),
            ContentBox(title: "Bag 8", imagePath: "assets/image/sakshi.png"),
          ]),
          Row(children: [
            ContentBox(title: "Bag 9", imagePath: "assets/image/sakshi.png"),
            Spacer(),
          ]),
        ],
      ),
    );
  }
  /// ================= BOOKS UI =================
  Widget booksUI() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle("Play Group"),
          Row(children: [
            ContentBox(
              title: "Merged Books",
              imagePath: "assets/image/sakshi.png",
              onTap: () => openBook("Merged Books"),
            ),
             ContentBox(title: "Subject Wise", imagePath: "assets/image/sakshi.png"),
          ]),
          const SectionTitle("Nursery"),
          const Row(children: [
            ContentBox(title: "Merged", imagePath: "assets/image/sakshi.png"),
            ContentBox(title: "Subject Wise", imagePath: "assets/image/sakshi.png"),
          ]),
          const SectionTitle("Junior"),
          const Row(children: [
            ContentBox(title: "Merged", imagePath: "assets/image/sakshi.png"),
            ContentBox(title: "Subject Wise", imagePath: "assets/image/sakshi.png"),
          ]),
          const SectionTitle("Senior"),
          const Row(children: [
            ContentBox(title: "Subject Wise", imagePath: "assets/image/sakshi.png"),
            ContentBox(title: "Merged", imagePath: "assets/image/sakshi.png"),
          ]),
          const Row(children: [
            ContentBox(title: "Senior KG Worksheet", imagePath: "assets/image/sakshi.png"),
            Spacer(),
          ]),
          const SectionTitle("English Cursive"),
          const Row(children: [
            ContentBox(title: "Level 1", imagePath: "assets/image/sakshi.png"),
            ContentBox(title: "Level 2", imagePath: "assets/image/sakshi.png"),
          ]),
        //मराठी भाषा
        const SectionTitle("मराठी भाषा"),
    Row(
    children: [
    ContentBox(
    title: "मराठी Nursery Book",
    imagePath: "assets/image/sakshi.png",
    ),
    ContentBox(
    title: "मराठी Junior Kg Book",
    imagePath: "assets/image/sakshi.png",
    ),
    ],
    ),
        ],
      ),
    );
  }
  void openBook(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsPage(
          title: title,
          productId: title, // 🔥 temporary unique id (later from DB)
          price: 749,       // 🔥 temporary price
        ),
      ),
    );
  }


  /// ================= CERTIFICATE UI =================
  Widget certificateUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SectionTitle("Certificates"),
        Row(children: [
          ContentBox(title: "Certificate 1", imagePath: "assets/image/sakshi.png"),
          ContentBox(title: "Certificate 2", imagePath: "assets/image/sakshi.png"),
        ]),
        Row(children: [
          ContentBox(title: "Certificate 3", imagePath: "assets/image/sakshi.png"),
          ContentBox(title: "Certificate 4", imagePath: "assets/image/sakshi.png"),
        ]),
      ],
    );
  }

  Widget idCardUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SectionTitle("Id Card"),
        Row(children: [
          ContentBox(title: "Id Card 1", imagePath: "assets/image/sakshi.png"),
          ContentBox(title: "Id Card 2", imagePath: "assets/image/sakshi.png"),
        ]),
      ],
    );
  }

  Widget medalsUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SectionTitle("Medals"),
        Row(children: [
          ContentBox(title: "Gold Silver Bronze", imagePath: "assets/image/sakshi.png"),
          Spacer(),
        ]),
      ],
    );
  }

  Widget notebooksUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SectionTitle("Notebook"),
        Row(children: [
          ContentBox(title: "Notebook 1", imagePath: "assets/image/sakshi.png"),
          ContentBox(title: "Notebook 2", imagePath: "assets/image/sakshi.png"),
        ]),
        Row(children: [
          ContentBox(title: "Notebook 3", imagePath: "assets/image/sakshi.png"),
          Spacer(),
        ]),
      ],
    );
  }

  Widget progressCardUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SectionTitle("Progress Card"),
        Row(children: [
          ContentBox(title: "Progress Card 1", imagePath: "assets/image/sakshi.png"),
          ContentBox(title: "Progress Card 2", imagePath: "assets/image/sakshi.png"),
        ]),
        Row(children: [
          ContentBox(title: "Progress Card 3", imagePath: "assets/image/sakshi.png"),
          ContentBox(title: "Result", imagePath: "assets/image/sakshi.png"),
        ]),
      ],
    );
  }


  // sample paper

  Widget samplePapersUI() {
    // 🔹 clickable item (merged here)
    Widget clickableItem(String title) {
      return ListTile(
        title: Text(title),
        onTap: () => print("$title clicked"),
      );
    }
    // 🔹 expandable section
    Widget section(String title) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ExpansionTile(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            clickableItem("Unit 1"),
            clickableItem("Test 1"),
            clickableItem("Unit 2"),
            clickableItem("Test 2"),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle("Sample Papers"),
          section("Play Group"),
          section("Junior"),
          section("Nursery"),
          section("Senior"),
        ],
      ),
    );
  }



  Widget uniformsUI() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle("Uniform"),
          Row(children: [
            ContentBox(title: "Uniform 1", imagePath: "assets/image/sakshi.png"),
            ContentBox(title: "Uniform 2", imagePath: "assets/image/sakshi.png"),
          ]),
          Row(children: [
            ContentBox(title: "Uniform 3", imagePath: "assets/image/sakshi.png"),
            ContentBox(title: "Uniform 4", imagePath: "assets/image/sakshi.png"),
          ]),
          Row(children: [
            ContentBox(title: "Uniform 5", imagePath: "assets/image/sakshi.png"),
            Spacer(),
          ]),
        ],
      ),
    );
  }
}

/// ================= SECTION TITLE =================
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// ================= CONTENT BOX =================
/// Later you can add:
/// ElevatedButton(onPressed: addToCart)
class ContentBox extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const ContentBox({
    super.key,
    required this.title,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell( // ✅ THIS MAKES IT CLICKABLE
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 170,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 80,
                width: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:vedant_education_app/screen/product_details.dart';
//
// import 'account_screen.dart';
// import 'cart_screen.dart';
// import 'home.dart';
//
// class CategoryPage extends StatefulWidget {
//   const CategoryPage({super.key});
//
//   @override
//   State<CategoryPage> createState() => _CategoryPageState();
// }
//
// class _CategoryPageState extends State<CategoryPage> {
//   int _selectedIndex = 1;
//   int selectedCategoryIndex = 0;
//
//   final List<String> categories = [
//     "Bag",
//     "Books",
//     "Certificate",
//     "Id Card",
//     "Medals",
//     "Notebooks",
//     "Progress Card",
//     "Results",
//     "Sample Papers",
//     "Uniform",
//   ];
//
//   /// ================= BOTTOM NAVIGATION =================
//   void _onItemTapped(int index) {
//     setState(() => _selectedIndex = index);
//
//     if (index == 0) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//       );
//     } else if (index == 2) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const AccountPage()),
//       );
//     } else if (index == 3) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const CartPage()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Vedant Education"),
//         centerTitle: true,
//       ),
//
//       /// ================= BODY =================
//       body: Row(
//         children: [
//           /// ===== LEFT CATEGORY LIST =====
//           Container(
//             width: 120,
//             color: Colors.grey.shade200,
//             child: ListView.builder(
//               itemCount: categories.length,
//               itemBuilder: (context, index) {
//                 return InkWell(
//                   onTap: () => setState(() => selectedCategoryIndex = index),
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     color: selectedCategoryIndex == index
//                         ? Colors.white
//                         : Colors.grey.shade200,
//                     child: Text(
//                       categories[index],
//                       style: TextStyle(
//                         fontWeight: selectedCategoryIndex == index
//                             ? FontWeight.bold
//                             : FontWeight.normal,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           /// ===== RIGHT CONTENT =====
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: rightContent(),
//             ),
//           ),
//         ],
//       ),
//
//       /// ===== BOTTOM NAV =====
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.purple,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Category'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
//           BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
//         ],
//       ),
//     );
//   }
//
//   /// ================= RIGHT SWITCH =================
//   Widget rightContent() {
//     final selected = categories[selectedCategoryIndex];
//
//     switch (selected) {
//       case "Bag":
//         return bagUI();
//       case "Books":
//         return booksUI();
//       case "Certificate":
//         return certificateUI();
//       case "Id Card":
//         return idCardUI();
//       case "Medals":
//         return medalsUI();
//       case "Notebooks":
//         return notebooksUI();
//       case "Progress Card":
//         return progressCardUI();
//       case "Uniform":
//         return uniformsUI();
//       default:
//         return Center(
//           child: Text(selected, style: const TextStyle(fontSize: 18)),
//         );
//     }
//   }
//
//   /// ================= BAG UI =================
//   Widget bagUI() {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: const [
//           SectionTitle("Bags"),
//           Row(children: [
//             ContentBox(title: "Bag 1", imagePath: "assets/image/sakshi.png"),
//             ContentBox(title: "Bag 2", imagePath: "assets/image/sakshi.png"),
//           ]),
//         ],
//       ),
//     );
//   }
//
//   /// ================= BOOKS UI (CLICK ENABLED) =================
//   Widget booksUI() {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SectionTitle("Play Group"),
//
//           Row(children: [
//             ContentBox(
//               title: "Merged Books",
//               imagePath: "assets/image/sakshi.png",
//               onTap: () => openBook("Merged Books"),
//             ),
//             ContentBox(
//               title: "Subject Wise",
//               imagePath: "assets/image/sakshi.png",
//               onTap: () => openBook("Subject Wise"),
//             ),
//           ]),
//
//           const SectionTitle("Nursery"),
//           Row(children: [
//             ContentBox(
//               title: "Nursery Merged",
//               imagePath: "assets/image/sakshi.png",
//               onTap: () => openBook("Nursery Merged"),
//             ),
//             ContentBox(
//               title: "Nursery Subject Wise",
//               imagePath: "assets/image/sakshi.png",
//               onTap: () => openBook("Nursery Subject Wise"),
//             ),
//           ]),
//         ],
//       ),
//     );
//   }
//
//   void openBook(String title) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ProductDetailsPage(title: title),
//       ),
//     );
//   }
//
//   /// ================= CERTIFICATE UI =================
//   Widget certificateUI() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         SectionTitle("Certificates"),
//         Row(children: [
//           ContentBox(title: "Certificate 1", imagePath: "assets/image/sakshi.png"),
//           ContentBox(title: "Certificate 2", imagePath: "assets/image/sakshi.png"),
//         ]),
//       ],
//     );
//   }
//
//   Widget idCardUI() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         SectionTitle("Id Card"),
//         Row(children: [
//           ContentBox(title: "Id Card 1", imagePath: "assets/image/sakshi.png"),
//           ContentBox(title: "Id Card 2", imagePath: "assets/image/sakshi.png"),
//         ]),
//       ],
//     );
//   }
//
//   Widget medalsUI() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         SectionTitle("Medals"),
//         Row(children: [
//           ContentBox(title: "Gold Silver Bronze", imagePath: "assets/image/sakshi.png"),
//           Spacer(),
//         ]),
//       ],
//     );
//   }
//
//   Widget notebooksUI() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         SectionTitle("Notebook"),
//         Row(children: [
//           ContentBox(title: "Notebook 1", imagePath: "assets/image/sakshi.png"),
//           ContentBox(title: "Notebook 2", imagePath: "assets/image/sakshi.png"),
//         ]),
//       ],
//     );
//   }
//
//   Widget progressCardUI() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         SectionTitle("Progress Card"),
//         Row(children: [
//           ContentBox(title: "Progress Card 1", imagePath: "assets/image/sakshi.png"),
//           ContentBox(title: "Progress Card 2", imagePath: "assets/image/sakshi.png"),
//         ]),
//       ],
//     );
//   }
//
//   Widget uniformsUI() {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: const [
//           SectionTitle("Uniform"),
//           Row(children: [
//             ContentBox(title: "Uniform 1", imagePath: "assets/image/sakshi.png"),
//             ContentBox(title: "Uniform 2", imagePath: "assets/image/sakshi.png"),
//           ]),
//         ],
//       ),
//     );
//   }
// }
//
// /// ================= SECTION TITLE =================
// class SectionTitle extends StatelessWidget {
//   final String title;
//   const SectionTitle(this.title, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Text(
//         title,
//         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }
//
// /// ================= CONTENT BOX =================
// class ContentBox extends StatelessWidget {
//   final String title;
//   final String imagePath;
//   final VoidCallback? onTap;
//
//   const ContentBox({
//     super.key,
//     required this.title,
//     required this.imagePath,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: InkWell(
//         onTap: onTap,
//         child: Container(
//           height: 170,
//           margin: const EdgeInsets.all(8),
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 imagePath,
//                 height: 80,
//                 width: 80,
//                 fit: BoxFit.contain,
//               ),
//               const SizedBox(height: 8),
//               Text(title, textAlign: TextAlign.center),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// ================= BOOK DETAILS PAGE =================
// class BooksDetailsPage extends StatelessWidget {
//   final String title;
//   const BooksDetailsPage({super.key, required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(title)),
//       body: Center(
//         child: Text(
//           "You opened $title",
//           style: const TextStyle(fontSize: 22),
//         ),
//       ),
//     );
//   }
// }





