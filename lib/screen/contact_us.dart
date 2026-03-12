import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> openUrl(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw "Could not launch $link";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        title: const Text("Contact Us"),
        centerTitle: true,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [

                  /// Contact Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      "assets/image/Contact_us.jpeg",
                      height: 200,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Vedant Education",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "We are here to help you",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const Divider(height: 30),

                  /// Phone
                  ListTile(
                    leading: const Icon(Icons.phone, color: Colors.blue),
                    title: const Text("+91 9766117311"),
                    onTap: () => openUrl("tel:+919766117311"),
                  ),

                  /// Email
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.red),
                    title: const Text("vedanteducation.22@gmail.com"),
                    onTap: () => openUrl(
                        "mailto:vedanteducation.22@gmail.com"),
                  ),

                  /// Message
                  const ListTile(
                    leading: Icon(Icons.help_outline, color: Colors.orange),
                    title: Text("Send Your Message"),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Follow Us",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Social Media Icons
                  Wrap(
                    spacing: 20,
                    alignment: WrapAlignment.center,
                    children: [

                      IconButton(
                        icon: Image.asset(
                          "assets/image/Facebook_icon.jpeg",
                          height: 40,
                        ),
                        onPressed: () => openUrl(
                            "https://facebook.com"),
                      ),

                      IconButton(
                        icon: Image.asset(
                          "assets/image/instagram_icon.jpeg",
                          height: 40,
                        ),
                        onPressed: () => openUrl(
                            "https://www.instagram.com/vedant_education11"),
                      ),

                      IconButton(
                        icon: Image.asset(
                          "assets/image/youtube_icon.jpeg",
                          height: 40,
                        ),
                        onPressed: () => openUrl(
                            "https://youtube.com/@vedanteducation5438"),
                      ),

                      IconButton(
                        icon: Image.asset(
                          "assets/image/Twitter_icon.jpeg",
                          height: 40,
                        ),
                        onPressed: () => openUrl(
                            "https://twitter.com"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}











// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
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
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ContactPage(),
//     );
//   }
// }
//
// class ContactPage extends StatelessWidget {
//   const ContactPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//
//       appBar: AppBar(
//         title: const Text("Contact "),
//         centerTitle: true,
//       ),
//
//       body: SingleChildScrollView(
//         child:Center(
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(15),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15),
//             boxShadow: const [
//               BoxShadow(
//                 blurRadius: 8,
//                 color: Colors.black12,
//               )
//             ],
//           ),
//
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//
//               /// Top Image
//               Image.asset(
//                 "assets/image/Contact_us.jpeg",
//                 height: 250,
//               ),
//
//               const SizedBox(height: 15),
//
//               const Text(
//                 "Contact us",
//                 style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold),
//               ),
//
//               const Divider(),
//
//               const SizedBox(height: 10),
//
//               /// Phone
//               GestureDetector(
//                 onTap: () async {
//                   final Uri phoneUri = Uri.parse("tel:+919766117311");
//                   if (!await launchUrl(phoneUri)) {
//                     throw 'Could not launch $phoneUri';
//                   }
//                 },
//                 child: Row(
//                   children: const [
//                     Icon(Icons.phone, color: Colors.black),
//                     SizedBox(width: 10),
//                     Text(
//                       "+91 9766117311",
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontSize: 16,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 15),
//               /// Email
//               Row(
//                 children: const [
//                   Icon(Icons.email, color: Colors.black),
//                   SizedBox(width: 10),
//                   Text(
//                     "vedanteducation.22@gmail.com",
//                     style: TextStyle(
//                         color: Colors.blue,
//                         fontSize: 16),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 15),
//
//               /// Query
//               Row(
//                 children: const [
//                   Icon(Icons.help_outline),
//                   SizedBox(width: 10),
//                   Text(
//                     "Send Your Message",
//                     style: TextStyle(
//                         color: Colors.blue,
//                         fontSize: 16),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 20),
//
//               /// Social Icons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   /// Facebook
//                   IconButton(
//                     icon: Image.asset(
//                       "assets/image/Facebook_icon.jpeg",
//                       height: 40,
//                       width: 40,
//                     ),
//                     onPressed: () async {
//                       final Uri url = Uri.parse("https://youtube.com/@vedanteducation5438?si=JymsaipIrYelkK8j");
//                       if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
//                         throw 'Could not launch $url';
//                       }
//                     },
//                   ),
//                   /// Instagram
//                   IconButton(
//                     icon: Image.asset(
//                       "assets/image/instagram_icon.jpeg",
//                       height: 40,
//                       width: 40,
//                     ),
//                     onPressed: () async {
//                       final Uri url = Uri.parse("https://www.instagram.com/vedant_education11?igsh=NWN2bzRvN2ZoMXBn");
//                       if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
//                         throw 'Could not launch $url';
//                       }
//                     },
//                   ),
//
//                   /// YouTube
//                   IconButton(
//                     icon: Image.asset(
//                       "assets/image/youtube_icon.jpeg",
//                       height: 40,
//                       width: 40,
//                     ),
//                     onPressed: () async {
//                       final Uri url = Uri.parse("https://youtube.com/@vedanteducation5438?si=JymsaipIrYelkK8j");
//                       if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
//                         throw 'Could not launch $url';
//                       }
//                     },
//                   ),
//
//                   /// Twitter
//                   IconButton(
//                     icon: Image.asset(
//                       "assets/image/Twitter_icon.jpeg",
//                       height: 30,
//                       width: 30,
//                     ),
//                     onPressed: () async {
//                       final Uri url = Uri.parse("https://youtube.com/@vedanteducation5438?si=JymsaipIrYelkK8j");
//                       if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
//                         throw 'Could not launch $url';
//                       }
//                     },
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//       ));
//   }
// }