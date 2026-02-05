import 'package:dentaltreatment/features/home/data/sources/doctor_service.dart';
import 'package:dentaltreatment/features/home/presentation/managers/doctor_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/pages/booking_onprogress .dart';
import 'package:dentaltreatment/features/home/presentation/pages/doctors_list_page.dart';
import 'package:flutter/material.dart';
import 'package:dentaltreatment/core/classes/icons_classes.dart';
import 'package:dentaltreatment/core/theme/app_assets.dart';
import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/features/home/presentation/pages/booking_cancel.dart';
import 'package:dentaltreatment/features/home/presentation/pages/booking_done.dart';
import 'package:dentaltreatment/features/home/presentation/pages/booking_waiting.dart';
import 'package:dentaltreatment/features/home/presentation/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ADDED
import 'package:dentaltreatment/features/home/data/sources/booking_service.dart';
import 'package:dentaltreatment/features/home/presentation/managers/booking_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/booking_state.dart';

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
    return BlocProvider(
      create: (_) => BookingCubit(BookingService())..loadBookings(),

      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FB),

        appBar: AppBar(
          backgroundColor: const Color(0xFFF7F9FB),
          elevation: 0,
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
          title: const Text(
            "Booking",
            style: TextStyle(
              fontFamily: 'Gabarito',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF234E9D),
            ),
          ),
          centerTitle: true,
        ),

        body: Column(
          children: [
            const SizedBox(height: 12),

            // ⭐ Top card
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
                      color: Colors.blue.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 32,
                      backgroundImage: AssetImage(AppAssets.doctor),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Find a Specialist",
                            style: TextStyle(
                              fontFamily: 'Gabarito',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Browse doctors and manage your appointments.",
                            style: TextStyle(
                              fontFamily: 'Gabarito',
                              fontSize: 12,
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
                                (context) => BlocProvider(
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Show",
                        style: TextStyle(
                          fontFamily: 'Gabarito',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ⭐ TabBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black54,
                  indicator: BoxDecoration(
                    color: AppColor.darkblue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelStyle: const TextStyle(
                    fontFamily: 'Gabarito',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                  tabs: const [
                    Tab(text: "OnProgress"),
                    Tab(text: "Waiting"),
                    Tab(text: "Done"),
                    Tab(text: "Canceled"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ⭐ Pages
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  BookingOnProgressSection(),
                  BookingWaaitingSection(),
                  BookingDoneSection(),
                  BookingCancelSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
