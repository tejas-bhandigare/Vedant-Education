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

  final List<String> bannerImages = [
    "assets/image/SchoolDiary.jpeg",
    "assets/image/SchoolDiary.jpeg",
    "assets/image/SchoolDiary.jpeg",
    "assets/image/SchoolDiary.jpeg",
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CategoryPage()),
      );
    }

    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AccountPage()),
      );
    }

    if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CartPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // SEARCH BAR
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search books, papers, etc',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // CATEGORY ICON LIST
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategory(Icons.book, "Books"),
                    // _buildCategory(Icons.school, "Papers"),
                    _buildCategory(Icons.school, "Papers"),
                    _buildCategory(Icons.menu_book, "Bag"),
                    _buildCategory(Icons.video_library, "Uniform"),
                    _buildCategory(Icons.more_horiz, "More"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // PROMO BANNER
              _buildPromoBanner(),

              const SizedBox(height: 24),

              // RECOMMENDED SECTION
              const Text(
                "Recommended for You",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // CAROUSEL
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE), // ice blue - matches Figma design
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
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
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
            MaterialPageRoute(
              builder: (_) => const CategoryPage(),
            ),
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









// import 'package:flutter/material.dart';
// import '../service/auth_service.dart';
// import 'account_screen.dart';
// import 'cart_screen.dart';
// import 'category_screen.dart';
// import 'package:carousel_slider/carousel_slider.dart';
//
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Book Store UI',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//
//   /// 2 nd slider
//   final ScrollController _scrollController = ScrollController();
//
//
//   final List<String> bannerImages = [
//     "assets/image/SchoolDiary.jpeg",
//     "assets/image/SchoolDiary.jpeg",
//     "assets/image/SchoolDiary.jpeg",
//     "assets/image/SchoolDiary.jpeg",
//   ];
//
//   int _selectedIndex = 0; // Home selected default
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//
//     if (index == 1) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const CategoryPage()),
//       );
//     }
//
//     if (index == 2) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const AccountPage()),
//       );
//     }
//
//     if (index == 3) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const CartPage()),
//       );
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Search books, papers, etc',
//                   prefixIcon: const Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//
//               // CATEGORY ICON LIST
//               SizedBox(
//                 height: 90,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   children: [
//                     _buildCategory(Icons.book, "Books"),
//                     _buildCategory(Icons.school, "Papers"),
//                     _buildCategory(Icons.menu_book, "Bag"),
//                     _buildCategory(Icons.video_library, "Uniform"),
//                     _buildCategory(Icons.more_horiz, "More"),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // PROMO BANNER
//               _buildPromoBanner(),
//
//               const SizedBox(height: 24),
//
//
//               const Text(
//                 "Recommended for You",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//
//               CarouselSlider(
//                 options: CarouselOptions(
//                   height: 190,
//                   autoPlay: true,
//                   autoPlayInterval: const Duration(seconds: 3),
//                   enlargeCenterPage: true,
//                   viewportFraction: 0.9,
//                 ),
//                 items: bannerImages.map((imagePath) {
//                   return Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 5),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       image: DecorationImage(
//                         image: AssetImage(imagePath),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//
//
//
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//
//
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.grid_view),
//             label: 'Category',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Account',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Cart',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPromoBanner() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(25),
//       decoration: BoxDecoration(
//         color: const Color(0xFFD6DCFD),
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Back to School\nEssentials",
//             style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             "Up to 40% off on all\nacademic supplies.",
//             style: TextStyle(color: Colors.white70, fontSize: 13),
//           ),
//           const SizedBox(height: 15),
//           ElevatedButton(
//             onPressed: () {Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const CategoryPage()),
//             );},
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.white,
//               foregroundColor: const Color(0xFF324DF0),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             ),
//             child: const Text("SHOP NOW", style: TextStyle(fontWeight: FontWeight.bold)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCategory(IconData icon, String label) {
//     return GestureDetector(
//       onTap: () {
//
//         if (label == "More") {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => const CategoryPage(),
//             ),
//           );
//         } else {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => CategoryPage(categoryName: label),
//             ),
//           );
//         }
//
//       },
//       child: Container(
//         width: 80,
//         margin: const EdgeInsets.only(right: 12),
//         child: Column(
//           children: [
//             CircleAvatar(
//               radius: 25,
//               backgroundColor: Colors.blue.shade50,
//               child: Icon(icon, color: Colors.blue),
//             ),
//             const SizedBox(height: 6),
//             Text(label, style: const TextStyle(fontSize: 12)),
//           ],
//         ),
//       ),
//     );
//   }
// }







// import 'package:flutter/material.dart';
// import '../service/auth_service.dart';
// import 'account_screen.dart';
// import 'cart_screen.dart';
// import 'category_screen.dart';
// import 'package:carousel_slider/carousel_slider.dart';
//
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Book Store UI',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//
// /// 2 nd slider
//   final ScrollController _scrollController = ScrollController();
//
//
//   final List<String> bannerImages = [
//     "assets/image/SchoolDiary.jpeg",
//     "assets/image/SchoolDiary.jpeg",
//     "assets/image/SchoolDiary.jpeg",
//     "assets/image/SchoolDiary.jpeg",
//   ];
//
//   int _selectedIndex = 0; // Home selected default
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//
//     if (index == 1) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const CategoryPage()),
//       );
//     }
//
//     if (index == 2) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const AccountPage()),
//       );
//     }
//
//     if (index == 3) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const CartPage()),
//       );
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Search books, papers, etc',
//                   prefixIcon: const Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//
//               // CATEGORY ICON LIST
//               SizedBox(
//                 height: 90,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   children: [
//                     _buildCategory(Icons.book, "Books"),
//                     _buildCategory(Icons.school, "Papers"),
//                     _buildCategory(Icons.menu_book, "Bag"),
//                     _buildCategory(Icons.video_library, "Uniform"),
//                     _buildCategory(Icons.more_horiz, "More"),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//
//
//
//               const Text(
//                 "Recommended for You",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//
//               CarouselSlider(
//                 options: CarouselOptions(
//                   height: 190,
//                   autoPlay: true,
//                   autoPlayInterval: const Duration(seconds: 3),
//                   enlargeCenterPage: true,
//                   viewportFraction: 0.9,
//                 ),
//                 items: bannerImages.map((imagePath) {
//                   return Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 5),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       image: DecorationImage(
//                         image: AssetImage(imagePath),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//
//               const SizedBox(height: 40),
//
//
//
//               // SizedBox(
//               //   height: 150,
//               //   child: Row(
//               //     children: [
//               //
//               //       /// LEFT ARROW
//               //       IconButton(
//               //         icon: const Icon(Icons.arrow_back_ios),
//               //         onPressed: () {
//               //           _scrollController.animateTo(
//               //             _scrollController.offset - 150,
//               //             duration: const Duration(milliseconds: 300),
//               //             curve: Curves.ease,
//               //           );
//               //         },
//               //       ),
//               //
//               //       /// IMAGE LIST
//               //       Expanded(
//               //         child: ListView.builder(
//               //           controller: _scrollController,
//               //           scrollDirection: Axis.horizontal,
//               //           itemCount: bannerImages.length,
//               //           itemBuilder: (context, index) {
//               //             return Container(
//               //               width: 150,
//               //               margin: const EdgeInsets.only(right: 12),
//               //               decoration: BoxDecoration(
//               //                 borderRadius: BorderRadius.circular(12),
//               //                 image: DecorationImage(
//               //                   image: AssetImage(bannerImages[index]),
//               //                   fit: BoxFit.cover,
//               //                 ),
//               //               ),
//               //             );
//               //           },
//               //         ),
//               //       ),
//               //
//               //       /// RIGHT ARROW
//               //       IconButton(
//               //         icon: const Icon(Icons.arrow_forward_ios),
//               //         onPressed: () {
//               //           _scrollController.animateTo(
//               //             _scrollController.offset + 150,
//               //             duration: const Duration(milliseconds: 300),
//               //             curve: Curves.ease,
//               //           );
//               //         },
//               //       ),
//               //     ],
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//
//
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.grid_view),
//             label: 'Category',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Account',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Cart',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCategory(IconData icon, String label) {
//     return GestureDetector(
//       onTap: () {
//
//         if (label == "More") {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => const CategoryPage(),
//             ),
//           );
//         } else {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => CategoryPage(categoryName: label),
//             ),
//           );
//         }
//
//       },
//       child: Container(
//         width: 80,
//         margin: const EdgeInsets.only(right: 12),
//         child: Column(
//           children: [
//             CircleAvatar(
//               radius: 25,
//               backgroundColor: Colors.blue.shade50,
//               child: Icon(icon, color: Colors.blue),
//             ),
//             const SizedBox(height: 6),
//             Text(label, style: const TextStyle(fontSize: 12)),
//           ],
//         ),
//       ),
//     );
//   }
//   }
//
//
//
