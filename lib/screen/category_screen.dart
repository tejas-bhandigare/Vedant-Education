import 'package:flutter/material.dart';
import 'package:vedant_education_app/screen/product_details.dart';

import 'account_screen.dart';
import 'cart_screen.dart';
import 'home.dart';


class CategoryPage extends StatefulWidget {

  final String? categoryName;

  const CategoryPage({super.key, this.categoryName});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int _selectedIndex = 1;
  int selectedCategoryIndex = 0;


  @override
  void initState() {
    super.initState();

    if (widget.categoryName != null) {
      int index = categories.indexOf(widget.categoryName!);

      if (index != -1) {
        selectedCategoryIndex = index;
      }
    }
  }

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
            color: Colors.blue.shade50,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => setState(() => selectedCategoryIndex = index),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    color: selectedCategoryIndex == index
                        ? Colors.white
                        : Colors.blue.shade50,
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
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view), label: 'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
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
        children: [
          const SectionTitle("Bags"),
          Row(children: [
            ContentBox(
              title: "Bag 1",
              imagePath: "assets/image/Bag1.jpg", ///1️⃣ imagePath (for ContentBox UI) //  This is used only for displaying the image in the category/product grid
              onTap: () =>
                  openBag(
                    id: "bag1",
                    name: "School Bag",
                    price: 799,
                    image: "assets/image/Bag1.jpg", ///2️⃣ image inside openBag() (for Product Page)  This is passed to the Product Details Page.
                    description: "Durable school bag with multiple compartments.",
                  ),
            ),


            ContentBox(
              title: "Bag 2",
              imagePath: "assets/image/Bag2.jpg",
              onTap: () =>
                  openBag(
                    id: "bag2",
                    name: "Travel Bag",
                    price: 999,
                    image: "assets/image/Bag2.jpg",
                    description: "Large capacity travel bag for students.",
                  ),
            ),
          ]),
          Row(children: [
            ContentBox(
              title: "Bag 3",
              imagePath: "assets/image/Bag3.jpg",
              onTap: () =>
                  openBag(
                    id: "bag3",
                    name: "Kids School Bag",
                    price: 850,
                    image: "assets/image/Bag3.jpg",
                    description: "Comfortable kids school bag with adjustable straps.",
                  ),
            ),


            ContentBox(
              title: "Bag 4",
              imagePath: "assets/image/Bag4.jpeg",
              onTap: () =>
                  openBag(
                    id: "bag4",
                    name: "Junior School Bag",
                    price: 900,
                    image: "assets/image/Bag4.jpeg",
                    description: "Stylish junior school bag with strong zip and pockets.",
                  ),
            ),
          ]),
          Row(children: [
            ContentBox(
              title: "Bag 5",
              imagePath: "assets/image/Bag4.jpeg",
              onTap: () =>
                  openBag(
                    id: "bag5",
                    name: "Senior School Bag",
                    price: 1050,
                    image: "assets/image/Bag4.jpeg",
                    description: "Large capacity senior school bag for books and notebooks.",
                  ),
            ),
            ContentBox(
              title: "Bag 6",
              imagePath: "assets/image/Bag4.jpeg",
              onTap: () =>
                  openBag(
                    id: "bag6",
                    name: "Waterproof School Bag",
                    price: 1100,
                    image: "assets/image/Bag4.jpeg",
                    description: "Waterproof school bag to protect books from rain.",
                  ),
            ),
          ]),
          Row(children: [
            ContentBox(
              title: "Bag 7",
              imagePath: "assets/image/Bag4.jpeg",
              onTap: () =>
                  openBag(
                    id: "bag7",
                    name: "Lightweight School Bag",
                    price: 950,
                    image: "assets/image/Bag4.jpeg",
                    description: "Lightweight and comfortable bag for daily school use.",
                  ),
            ),
            ContentBox(
              title: "Bag 8",
              imagePath: "assets/image/Bag4.jpeg",
              onTap: () =>
                  openBag(
                    id: "bag8",
                    name: "Multi Pocket Bag",
                    price: 1200,
                    image: "assets/image/Bag4.jpeg",
                    description: "Multi pocket bag for organizing books and accessories.",
                  ),
            ),
          ]),
          Row(children: [
            ContentBox(
              title: "Bag 9",
              imagePath: "assets/image/Bag4.jpeg",
              onTap: () =>
                  openBag(
                    id: "bag9",
                    name: "Premium School Bag",
                    price: 1350,
                    image: "assets/image/Bag4.jpeg",
                    description: "Premium quality school bag with strong material.",
                  ),
            ),
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

          /// PLAY GROUP
          const SectionTitle("Play Group"),
          Row(children: [
            ContentBox(
              title: "Merged Books",
              imagePath: "assets/image/PlayGroup.jpeg",
              onTap: () => openBook("PlayGroup Merged Books"),
            ),
            ContentBox(
              title: "Subject Wise",
              imagePath: "assets/image/PlayGroup.jpeg",
              onTap: () => openBook("PlayGroup Subject Wise"),
            ),
          ]),


          /// NURSERY
          const SectionTitle("Nursery"),
          Row(children: [
            ContentBox(
              title: "Merged Books",
              imagePath: "assets/image/Nursery.jpeg",
              onTap: () => openBook("Nursery Merged Books"),
            ),
            ContentBox(
              title: "Subject Wise",
              imagePath: "assets/image/Nursery.jpeg",
              onTap: () => openBook("Nursery Subject Wise"),
            ),
          ]),

          /// JUNIOR
          const SectionTitle("Junior"),
          Row(children: [
            ContentBox(
              title: "Merged Books",
              imagePath: "assets/image/JuniorKgEnglish.jpeg",
              onTap: () => openBook("Junior Merged Books"),
            ),
            ContentBox(
              title: "Subject Wise",
              imagePath: "assets/image/JuniorKgEnglish.jpeg",
              onTap: () => openBook("Junior Subject Wise"),
            ),
          ]),

          /// SENIOR
          const SectionTitle("Senior"),
          Row(children: [
            ContentBox(
              title: "Subject Wise",
              imagePath: "assets/image/sakshi.png",
              onTap: () => openBook("Senior Subject Wise"),
            ),
            ContentBox(
              title: "Merged Books",
              imagePath: "assets/image/sakshi.png",
              onTap: () => openBook("Senior Merged Books"),
            ),
          ]),

          Row(children: [
            ContentBox(
              title: "KG Worksheet",
              imagePath: "assets/image/sakshi.png",
              onTap: () => openBook("Senior KG Worksheet"),
            ),
            const Spacer(),
          ]),

          /// ENGLISH CURSIVE
          const SectionTitle("English Cursive"),
          Row(children: [
            ContentBox(
              title: "Cursive Level 1",
              imagePath: "assets/image/sakshi.png",
              onTap: () => openBook("English Cursive Level 1"),
            ),
            ContentBox(
              title: "Cursive Level 2",
              imagePath: "assets/image/sakshi.png",
              onTap: () => openBook("English Cursive Level 2"),
            ),
          ]),

          /// MARATHI
          const SectionTitle("मराठी भाषा"),
          Row(children: [
            ContentBox(
              title: "Nursery Book",
              imagePath: "assets/image/sakshi.png",
              onTap: () => openBook("मराठी Nursery Book"),
            ),
            ContentBox(
              title: "Junior Kg Book",
              imagePath: "assets/image/sakshi.png",
              onTap: () => openBook("मराठी Junior Kg Book"),
            ),
          ]),

        ],
      ),
    );
  }


  void openBook(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ProductDetailsPage(
              productId: title,
            ),
      ),
    );
  }


  ///bag section
  void openBag({
    required String id,
    required String name,
    required int price,
    required String image,
    required String description,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ProductDetailsPage(
              productId: id,
            ),
      ),
    );
  }


  void openProduct(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsPage(productId: id),
      ),
    );
  }


  Widget certificateUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Certificates"),

        Row(children: [
          ContentBox(
            title: "Certificate 1",
            imagePath: "assets/image/Certification1.jpeg",
            onTap: () => openProduct("Certificate 1"),
          ),
          ContentBox(
            title: "Certificate 2",
            imagePath: "assets/image/Certification2.jpeg",
            onTap: () => openProduct("Certificate 2"),
          ),
        ]),

        Row(children: [
          ContentBox(
            title: "Certificate 3",
            imagePath: "assets/image/Certification3.jpeg",
            onTap: () => openProduct("Certificate 3"),
          ),
          ContentBox(
            title: "Certificate 4",
            imagePath: "assets/image/Certification4.jpeg",
            onTap: () => openProduct("Certificate 4"),
          ),
        ]),

        Row(children: [
          ContentBox(
            title: "Certificate 5",
            imagePath: "assets/image/Certification5.jpeg",
            onTap: () => openProduct("Certificate 5"),
          ),
          ContentBox(
            title: "Certificate 6",
            imagePath: "assets/image/Certification6.jpeg",
            onTap: () => openProduct("Certificate 6"),
          ),
        ]),


      ],
    );
  }


  Widget idCardUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("ID Cards"),

        Row(children: [
          ContentBox(
            title: "Id Card 1",
            imagePath: "assets/image/IdCard1.jpeg",
            onTap: () => openProduct("Id Card 1"),
          ),
          ContentBox(
            title: "Id Card 2",
            imagePath: "assets/image/IdCard2.jpeg",
            onTap: () => openProduct("Id Card 2"),
          ),
        ]),
      ],
    );
  }


  Widget medalsUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Medals"),

        Row(children: [
          ContentBox(
            title: "Gold Silver Bronze",
            imagePath: "assets/image/sakshi.png",
            onTap: () => openProduct("Gold Silver Bronze"),
          ),
          const Spacer(),
        ]),
      ],
    );
  }


  Widget notebooksUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Notebooks"),

        Row(children: [
          ContentBox(
            title: "Notebook 1",
            imagePath: "assets/image/sakshi.png",
            onTap: () => openProduct("Notebook 1"),
          ),
          ContentBox(
            title: "Notebook 2",
            imagePath: "assets/image/sakshi.png",
            onTap: () => openProduct("Notebook 2"),
          ),
        ]),

        Row(children: [
          ContentBox(
            title: "Notebook 3",
            imagePath: "assets/image/sakshi.png",
            onTap: () => openProduct("Notebook 3"),
          ),
          const Spacer(),
        ]),
      ],
    );
  }


  Widget progressCardUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Progress Cards"),

        Row(children: [
          ContentBox(
            title: "Progress Card 1",
            imagePath: "assets/image/ProgressCard1.jpeg",
            onTap: () => openProduct("Progress Card 1"),
          ),
          ContentBox(
            title: "Progress Card 2",
            imagePath: "assets/image/ProgressCard2.jpeg",
            onTap: () => openProduct("Progress Card 2"),
          ),
        ]),

        Row(children: [
          ContentBox(
            title: "Progress Card 3",
            imagePath: "assets/image/ProgressCard1.jpeg",
            onTap: () => openProduct("Progress Card 3"),
          ),
          ContentBox(
            title: "Progress Card 4",
            imagePath: "assets/image/ProgressCard1.jpeg",
            onTap: () => openProduct("Progress Card 4"),
          ),
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
        children: [

          const SectionTitle("Uniform"),

          Row(
            children: [
              ContentBox(
                title: "Uniform 1",
                imagePath: "assets/image/sakshi.png",
                onTap: () => openProduct("Uniform 1"),
              ),
              ContentBox(
                title: "Uniform 2",
                imagePath: "assets/image/sakshi.png",
                onTap: () => openProduct("Uniform 2"),
              ),
            ],
          ),

          Row(
            children: [
              ContentBox(
                title: "Uniform 3",
                imagePath: "assets/image/sakshi.png",
                onTap: () => openProduct("Uniform 3"),
              ),
              ContentBox(
                title: "Uniform 4",
                imagePath: "assets/image/sakshi.png",
                onTap: () => openProduct("Uniform 4"),
              ),
            ],
          ),

          Row(
            children: [
              ContentBox(
                title: "Uniform 5",
                imagePath: "assets/image/sakshi.png",
                onTap: () => openProduct("Uniform 5"),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}



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
//           Row(children: [
//             ContentBox(title: "Uniform 3", imagePath: "assets/image/sakshi.png"),
//             ContentBox(title: "Uniform 4", imagePath: "assets/image/sakshi.png"),
//           ]),
//           Row(children: [
//             ContentBox(title: "Uniform 5", imagePath: "assets/image/sakshi.png"),
//             Spacer(),
//           ]),
//         ],
//       ),
//     );
//   }
// }



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
                fit: BoxFit.cover,
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

