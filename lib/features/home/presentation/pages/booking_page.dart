import 'package:dentaltreatment/features/home/data/sources/doctor_service.dart';
import 'package:dentaltreatment/features/home/presentation/managers/doctor_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/pages/booking_onprogress .dart';
import 'package:dentaltreatment/features/home/presentation/pages/doctors_list_page.dart';
import 'package:flutter/material.dart';
import 'package:dentaltreatment/core/classes/icons_classes.dart';
import 'package:dentaltreatment/core/theme/app_assets.dart';
import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/core/localization/app_strings.dart';
import 'package:dentaltreatment/features/home/presentation/pages/booking_cancel.dart';
import 'package:dentaltreatment/features/home/presentation/pages/booking_done.dart';
import 'package:dentaltreatment/features/home/presentation/pages/booking_waiting.dart';
import 'package:dentaltreatment/features/home/presentation/pages/home_page.dart';
import 'package:dentaltreatment/features/home/presentation/managers/language_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(context.watch<LanguageCubit>().isArabic);
    final isArabic = context.watch<LanguageCubit>().isArabic;

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Directionality(
          textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
          child: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,

            // ❌ نمنع Flutter من التحكم بالـ leading
            automaticallyImplyLeading: false,

            // ✅ نثبت الأيقونة في اليسار دائمًا
            actions: [
              Directionality(
                textDirection: TextDirection.ltr, // يمنع الانعكاس
                child: IconButton(
                  icon:
                      isArabic
                          ? Iconarowright.arrow(context) // → عربي
                          : Iconarrowleft.arrow(context), // ← إنجليزي
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],

            title: Text(
              strings.booking,
              style: theme.appBarTheme.titleTextStyle,
            ),
            centerTitle: true,
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 12),

          // ===== DOCTOR PREVIEW CARD =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.darkblue, AppColor.lightblue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 250, 252, 252),
                    radius: 32,
                    backgroundImage: AssetImage(AppAssets.doctor),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.findSpecialist,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          strings.browseDoctors,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => BlocProvider(
                                create:
                                    (_) =>
                                        DoctorCubit(DoctorService())
                                          ..loadDoctors(),
                                child: const DoctorsListPage(),
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColor.darkblue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      strings.show,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ===== TAB BAR =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: theme.textTheme.bodySmall?.color,
                indicatorWeight: 10,
                indicator: BoxDecoration(
                  color: AppColor.darkblue,
                  borderRadius: BorderRadius.circular(20),
                ),
                labelStyle: const TextStyle(
                  fontFamily: 'Gabarito',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                tabs: [
                  Tab(text: strings.onProgress),
                  Tab(text: strings.waiting),
                  Tab(text: strings.done),
                  Tab(text: strings.canceled),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                BookingOnProgressSection(),
                BookingWaitingSection(),
                BookingDoneSection(),
                BookingCancelSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
