import 'package:dentaltreatment/core/classes/icons_classes.dart';
import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/features/home/presentation/pages/home_page.dart';
import 'package:dentaltreatment/features/home/presentation/pages/upload_panorama_section.dart';
import 'package:flutter/material.dart';

class AiPage extends StatelessWidget {
  const AiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.colorapp,
        leading: IconButton(
          icon: Iconarrowleft.arowleft,
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          },
        ),
        title: Text(
          "Dental Treatment with AI",
          style: const TextStyle(
            fontFamily: 'Gabarito',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF234E9D),
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ⭐ Beautiful Top Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4C8CFF), Color(0xFF8FC3FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // TEXT
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "AI Treatment Scan",
                        style: TextStyle(
                          fontFamily: 'Gabarito',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Analyze your teeth with AI\nto detect possible issues.",
                        style: TextStyle(
                          fontFamily: 'Gabarito',
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),

                  // IMAGE / ICON
                  SizedBox(
                    height: 90,
                    width: 90,
                    child: Image.asset(
                      'assets/images/medical-check.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            UploadPanoramaSection(),

            const SizedBox(height: 40),

            // ⭐ Upload Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.darkblue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                shadowColor: Colors.blueAccent,
                elevation: 6,
              ),
              onPressed: () {
                /* Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UplaodPage()),
                );*/
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  //Icon(Icons.camera_alt_outlined, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "submint",
                    style: TextStyle(
                      fontFamily: 'Gabarito',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
