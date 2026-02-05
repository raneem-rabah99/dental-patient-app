import 'package:dentaltreatment/core/classes/icons_classes.dart';
import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/features/home/presentation/pages/teeth_section.dart';
import 'package:flutter/material.dart';

class ShowResult extends StatelessWidget {
  const ShowResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 2),

        /// Main Result Box (same UI as upload)
        Container(
          width: 360,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blueAccent.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(
                  255,
                  188,
                  188,
                  188,
                ).withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icondental.dentalshow,
              const SizedBox(height: 12),

              const Text(
                'Here will show the result of your tooth treatment',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Gabarito',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C3E50),
                ),
              ),

              const SizedBox(height: 12),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "The AI carefully analyzes your image, identifies any teeth that may have issues, and highlights areas that need attention.\n\n"
                  "This helps you understand your dental condition clearly before visiting your dentist — quick, accurate, and easy to use.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Gabarito',
                    fontSize: 13,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ⭐ Added professional instruction
              const Text(
                "To begin your AI dental analysis, continue to the next step and let the system examine your teeth with smart detection.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Gabarito',
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 22),

              // ⭐ Navigation Button
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TeethPage()),
                  );
                },
                child: const Text(
                  "Start AI Treatment",
                  style: TextStyle(
                    fontFamily: 'Gabarito',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
