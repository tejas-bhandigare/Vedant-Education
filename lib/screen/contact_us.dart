import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  // This function handles opening the links
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Contact Us", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TOP IMAGE
            Center(
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/image/CONTACTUS.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            const Text(
              "Get in Touch",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A47D8)),
            ),
            const SizedBox(height: 30),

            // 2. CONTACT FORM (Simplified for space)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildContactInput("Full Name", "Enter your name"),
                  const SizedBox(height: 20),
                  _buildContactInput("Email Address", "Enter your email"),
                  const SizedBox(height: 20),
                  _buildContactInput("Message", "How can we help?", lines: 3),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A47D8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Send Message", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 3. SOCIAL MEDIA SECTION WITH YOUR LINKS
            const Text(
              "Our Channels",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // --- FACEBOOK LINK ---
                  _buildSocialIcon(
                    "Facebook",
                    const Color(0xFF1877F2),
                        () => _launchURL("https://www.facebook.com/profile.php?id=100083100170258"),
                  ),
                  // --- INSTAGRAM LINK ---
                  _buildSocialIcon(
                    "Instagram",
                    const Color(0xFFE4405F),
                        () => _launchURL("https://www.instagram.com/vedant_education11?igsh=NWN2bzRvN2ZoMXBn"),
                  ),
                  // --- YOUTUBE LINK ---
                  _buildSocialIcon(
                    "YouTube",
                    const Color(0xFFFF0000),
                        () => _launchURL("https://youtube.com/@vedanteducation5438?si=JymsaipIrYelkK8j"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- YOUR ICON CODE (KEEPING IT AS IT IS) ---
  Widget _buildSocialIcon(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          if (label == "Instagram")
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color(0xFFFEDA77),
                    Color(0xFFF58529),
                    Color(0xFFDD2A7B),
                    Color(0xFF8134AF),
                    Color(0xFF515BD4),
                  ],
                ),
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
            )
          else if (label == "YouTube")
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFFFF0000),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
            )
          else
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFF1877F2),
              child: const Icon(Icons.facebook, color: Colors.white, size: 30),
            ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInput(String label, String hint, {int lines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          maxLines: lines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF1F4FF),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class ContactPage extends StatelessWidget {
//   const ContactPage({super.key});
//
//   Future<void> openUrl(String link) async {
//     final Uri url = Uri.parse(link);
//     if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
//       throw "Could not launch $link";
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//
//       appBar: AppBar(
//         title: const Text("Contact Us"),
//         centerTitle: true,
//         elevation: 0,
//       ),
//
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//
//           child: Card(
//             elevation: 8,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//
//               child: Column(
//                 children: [
//
//                   /// Contact Image
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(15),
//                     child: Image.asset(
//                       "assets/image/Contact_us.jpeg",
//                       height: 200,
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   const Text(
//                     "Vedant Education",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//
//                   const SizedBox(height: 5),
//
//                   const Text(
//                     "We are here to help you",
//                     style: TextStyle(
//                       color: Colors.grey,
//                     ),
//                   ),
//
//                   const Divider(height: 30),
//
//                   /// Phone
//                   ListTile(
//                     leading: const Icon(Icons.phone, color: Colors.blue),
//                     title: const Text("+91 9766117311"),
//                     onTap: () => openUrl("tel:+919766117311"),
//                   ),
//
//                   /// Email
//                   ListTile(
//                     leading: const Icon(Icons.email, color: Colors.red),
//                     title: const Text("vedanteducation.22@gmail.com"),
//                     onTap: () => openUrl(
//                         "mailto:vedanteducation.22@gmail.com"),
//                   ),
//
//                   /// Message
//                   const ListTile(
//                     leading: Icon(Icons.help_outline, color: Colors.orange),
//                     title: Text("Send Your Message"),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   const Text(
//                     "Follow Us",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//
//                   const SizedBox(height: 10),
//
//                   /// Social Media Icons
//                   Wrap(
//                     spacing: 20,
//                     alignment: WrapAlignment.center,
//                     children: [
//
//                       IconButton(
//                         icon: Image.asset(
//                           "assets/image/Facebook_icon.jpeg",
//                           height: 40,
//                         ),
//                         onPressed: () => openUrl(
//                             "https://facebook.com"),
//                       ),
//
//                       IconButton(
//                         icon: Image.asset(
//                           "assets/image/instagram_icon.jpeg",
//                           height: 40,
//                         ),
//                         onPressed: () => openUrl(
//                             "https://www.instagram.com/vedant_education11"),
//                       ),
//
//                       IconButton(
//                         icon: Image.asset(
//                           "assets/image/youtube_icon.jpeg",
//                           height: 40,
//                         ),
//                         onPressed: () => openUrl(
//                             "https://youtube.com/@vedanteducation5438"),
//                       ),
//
//                       IconButton(
//                         icon: Image.asset(
//                           "assets/image/Twitter_icon.jpeg",
//                           height: 40,
//                         ),
//                         onPressed: () => openUrl(
//                             "https://twitter.com"),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
