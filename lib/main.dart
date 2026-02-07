import 'package:dentaltreatment/core/theme/app_theme.dart';
import 'package:dentaltreatment/features/auth/presentation/pages/login_page.dart';
import 'package:dentaltreatment/features/auth/presentation/pages/splash_screen.dart';
import 'package:dentaltreatment/features/home/data/sources/booking_delete_service.dart';
import 'package:dentaltreatment/features/home/data/sources/booking_status_service.dart';
import 'package:dentaltreatment/features/home/data/sources/delete_photo_service.dart';
import 'package:dentaltreatment/features/home/data/sources/doctor_details_service.dart';
import 'package:dentaltreatment/features/home/data/sources/doctor_service.dart';
import 'package:dentaltreatment/features/home/data/sources/favorite_case_service.dart';
import 'package:dentaltreatment/features/home/data/sources/logout_service.dart';
import 'package:dentaltreatment/features/home/data/sources/rate_app_service.dart';
import 'package:dentaltreatment/features/home/data/sources/update_photo_service.dart';
import 'package:dentaltreatment/features/home/presentation/managers/booking_status_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/doctor_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/doctor_details_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/favorite_case_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/pages/home_page.dart';
import 'package:dentaltreatment/features/home/presentation/managers/account_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/delete_photo_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/language_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/logout_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/rate_app_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/theme_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/update_photo_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => LanguageCubit()),
        BlocProvider(create: (_) => AccountCubit()),
        BlocProvider(create: (_) => RateAppCubit(RateAppService())),
        BlocProvider(create: (_) => LogoutCubit(LogoutService())),
        BlocProvider(create: (_) => UpdatePhotoCubit(UpdatePhotoService())),
        BlocProvider(create: (_) => DeletePhotoCubit(DeletePhotoService())),
        BlocProvider(create: (_) => BookingStatusCubit(BookingStatusService())),
        BlocProvider(create: (_) => DoctorCubit(DoctorService())),
        BlocProvider(create: (_) => FavoriteCaseCubit(FavoriteCaseService())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode, // 🔥 هذا المهم

          initialRoute: "/",
          routes: {
            "/": (_) => const SplashScreen(),
            "/login": (_) => LoginPage(),
            "/home": (_) => const HomePage(),
          },
        );
      },
    );
  }
}
