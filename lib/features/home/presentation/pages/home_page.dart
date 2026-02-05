import 'package:dentaltreatment/core/classes/icons_classes.dart';
import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/features/home/data/sources/delete_photo_service.dart';
import 'package:dentaltreatment/features/home/data/sources/rate_app_service.dart';
import 'package:dentaltreatment/features/home/data/sources/update_photo_service.dart';
import 'package:dentaltreatment/features/home/presentation/managers/account_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/delete_photo_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/language_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/rate_app_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/theme_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/update_photo_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/pages/ai_page.dart';
import 'package:dentaltreatment/features/home/presentation/pages/before_and_after_section.dart';
import 'package:dentaltreatment/features/home/presentation/pages/booking_page.dart';
import 'package:dentaltreatment/features/home/presentation/pages/header_home_page.dart';
import 'package:dentaltreatment/features/home/presentation/pages/edit_page.dart';
import 'package:dentaltreatment/features/home/presentation/pages/setting_page.dart';
import 'package:dentaltreatment/features/home/presentation/pages/show_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2; // Default to Home page

  static final List<Widget> _pages = <Widget>[
    EditPage(),
    BookingPage(),
    // ✅ Home content
    SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        color: const Color(0xFFF7F9FB),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(), // keep header here
            // 🌈 Curved gradient header with teeth image on the right
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 61, 123, 249),
                        Color.fromARGB(255, 138, 190, 255),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Positioned(
                  top: 50, // tighter spacing inside the blue header
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left texts
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            " Dental Treatment ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Gabarito',
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Keep your smile healthy today!",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontFamily: 'Gabarito',
                            ),
                          ),
                        ],
                      ),
                      // Right teeth image (NOT IconData)
                      // Uses your class:
                      // class Iconsteeth { static Image teeth = Image.asset('assets/icons/care (1).png', width: 150, height: 150); }
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Opacity(opacity: 0.95, child: Iconsteeth.teeth),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),
            const BeforeAfterSection(),

            // 📸 Upload Panorama Card — glass style
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0, left: 18, right: 18),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.15),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.blueAccent.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ShowResult(),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    ),
    AiPage(),
    SettingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: _pages[_selectedIndex],
      bottomNavigationBar: SizedBox(
        width: 390,
        height: 100,
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFFFFFFFF),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColor.darkblue,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/people.png',
                width: 30,
                height: 30,
                color: _selectedIndex == 0 ? AppColor.darkblue : Colors.grey,
              ),
              label: 'Edit',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/dental-appointment.png',
                width: 30,
                height: 30,
                color: _selectedIndex == 1 ? AppColor.darkblue : Colors.grey,
              ),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/tooth (1).png',
                width: 30,
                height: 30,
                color: _selectedIndex == 2 ? AppColor.darkblue : Colors.grey,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/treatment.png',
                width: 30,
                height: 30,
                color: _selectedIndex == 3 ? AppColor.darkblue : Colors.grey,
              ),
              label: 'Treatment',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/settings.png',
                width: 30,
                height: 30,
                color: _selectedIndex == 4 ? AppColor.darkblue : Colors.grey,
              ),
              label: 'Setting',
            ),
          ],
        ),
      ),
    );
  }
}
