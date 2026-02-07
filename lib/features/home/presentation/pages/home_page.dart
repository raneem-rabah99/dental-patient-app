import 'package:dentaltreatment/core/classes/icons_classes.dart';
import 'package:dentaltreatment/core/localization/app_strings.dart';
import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/features/home/presentation/managers/language_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/pages/ai_page.dart';
import 'package:dentaltreatment/features/home/presentation/pages/before_and_after_section.dart';
import 'package:dentaltreatment/features/home/presentation/pages/booking_page.dart';
import 'package:dentaltreatment/features/home/presentation/pages/chatbot.dart';
import 'package:dentaltreatment/features/home/presentation/pages/edit_page.dart';
import 'package:dentaltreatment/features/home/presentation/pages/header_home_page.dart';
import 'package:dentaltreatment/features/home/presentation/pages/setting_page.dart';
import 'package:dentaltreatment/features/home/presentation/pages/show_result.dart';
import 'package:dentaltreatment/features/home/presentation/widgets/chatdialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  late final List<Widget> _pages = [
    const EditPage(),
    BookingPage(),
    _homeBody(),
    const AiPage(),
    const SettingPage(),
  ];

  // ============================================================
  // 🧊 GLASS CARD
  // ============================================================
  Widget _glassCard(BuildContext context, Widget child) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      decoration: BoxDecoration(
        color:
            isDark
                ? Colors.black.withOpacity(0.55)
                : Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurRadius: 25,
            spreadRadius: -5,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(isDark ? 0.09 : 0.08),
          ),
        ],
        border: Border.all(
          color:
              isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.white.withOpacity(0.6),
        ),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  // ============================================================
  // HOME BODY
  // ============================================================
  Widget _homeBody() {
    return Builder(
      builder: (context) {
        final strings = AppStrings(context.watch<LanguageCubit>().isArabic);

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(),

              // ===== TOP GRADIENT =====
              Stack(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColor.darkblue, AppColor.lightblue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 50,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "ByteDent",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Gabarito',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              strings.Keepsmile,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontFamily: 'Gabarito',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 130,
                          height: 130,
                          child: Opacity(
                            opacity: 0.95,
                            child: Iconsteeth.teeth,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ===== BEFORE / AFTER =====
              _glassCard(context, const BeforeAfterSection()),

              // ===== SHOW RESULT =====
              _glassCard(context, const ShowResult()),

              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // NAVIGATION
  // ============================================================
  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // ✅ نفس BeforeAfterSection
    final strings = AppStrings(context.watch<LanguageCubit>().isArabic);

    return Scaffold(
      backgroundColor: colors.background,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _pages[_selectedIndex],

          // ✅ Chat Button (فوق الـ Navigation يمين)
          ByteDentChatFloatingButton(chatApi: ByteDentChatMessageApi()),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colors.surface,
        selectedItemColor: AppColor.darkblue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          _navItem('assets/icons/people.png', strings.editProfile, 0),
          _navItem('assets/icons/dental-appointment.png', strings.bookings, 1),
          _navItem('assets/icons/tooth (1).png', strings.topDoctors, 2),
          _navItem('assets/icons/treatment.png', strings.aiTreatment, 3),
          _navItem('assets/icons/settings.png', strings.settings, 4),
        ],
      ),
    );
  }

  BottomNavigationBarItem _navItem(String icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        icon,
        width: 26,
        height: 26,
        color: _selectedIndex == index ? AppColor.darkblue : Colors.grey,
      ),
      label: label,
    );
  }
}
