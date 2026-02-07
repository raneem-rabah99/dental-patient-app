import 'package:dentaltreatment/core/classes/icons_classes.dart';
import 'package:dentaltreatment/core/localization/app_strings.dart';
import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/features/home/presentation/managers/account_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/language_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/logout_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/logout_state.dart';
import 'package:dentaltreatment/features/home/presentation/managers/rate_app_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/rate_app_state.dart';
import 'package:dentaltreatment/features/home/presentation/managers/theme_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LanguageCubit>().isArabic;
    final strings = AppStrings(isArabic);

    // ✅ مهم: نعرف هل الوضع داكن
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return BlocListener<RateAppCubit, RateAppState>(
      listener: (context, state) {
        if (state.success != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.success!)));
        } else if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

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
                strings.settings,
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              centerTitle: true,
            ),
          ),
        ),

        body: Column(
          children: [
            const SizedBox(height: 16),

            // 🌙 THEME MODE (TEXT CHANGES)
            _tileContainer(
              context,
              child: _toggleTile(
                context,
                title: isDark ? strings.LightMode : strings.darkMode,
                value: isDark,
                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
              ),
            ),

            const SizedBox(height: 12),

            // 🌍 Language (كما هو)
            _tileContainer(
              context,
              child: _toggleTile(
                context,
                title: strings.language,
                value: isArabic,
                onChanged: (_) => context.read<LanguageCubit>().toggleLang(),
              ),
            ),

            const SizedBox(height: 12),

            // ⭐ Rate
            _tileContainer(
              context,
              child: _normalTile(
                context,
                title: strings.rateFeedback,
                icon: Icons.star,
                onTap: () => _showRateFeedbackDialog(context, strings),
              ),
            ),

            const SizedBox(height: 12),

            // 🔴 Logout
            _tileContainer(
              context,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: _logoutTile(
                  context,
                  title: strings.logout,
                  onTap: () => confirmLogout(context, strings),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= TILE CONTAINER =================
  Widget _tileContainer(BuildContext context, {required Widget child}) {
    return Container(
      width: double.infinity,
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: child,
    );
  }

  // ================= TOGGLE TILE =================
  Widget _toggleTile(
    BuildContext context, {
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColor.darkblue,
          ),
        ],
      ),
    );
  }

  // ================= NORMAL TILE =================
  Widget _normalTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            Icon(icon, color: Colors.amber),
          ],
        ),
      ),
    );
  }

  // ================= LOGOUT TILE =================
  Widget _logoutTile(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.red),
        ),
      ),
    );
  }

  // ================= RATE DIALOG =================
  void _showRateFeedbackDialog(BuildContext context, AppStrings strings) {
    double rating = 0;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (_, setState) {
            return AlertDialog(
              title: Text(strings.rateFeedback),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(strings.tapStars),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () => setState(() => rating = index + 1.0),
                      );
                    }),
                  ),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: strings.writeFeedback,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(strings.cancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (rating == 0) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        SnackBar(content: Text(strings.selectRating)),
                      );
                      return;
                    }
                    dialogContext.read<RateAppCubit>().rateApp(
                      rate: rating.toInt(),
                      feedback: controller.text.trim(),
                    );
                    Navigator.pop(dialogContext);
                  },
                  child: Text(strings.send),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// ================= LOGOUT =================
void confirmLogout(BuildContext context, AppStrings strings) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return BlocListener<LogoutCubit, LogoutState>(
        listener: (_, state) {
          if (state.isLoading) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(strings.loggingOut)));
          }
          if (state.success) {
            Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
          }
        },
        child: AlertDialog(
          title: Text(strings.logout),
          content: Text(strings.confirmLogout),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(strings.cancel),
            ),
            TextButton(
              onPressed: () => dialogContext.read<LogoutCubit>().logout(),
              child: Text(
                strings.logout,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    },
  );
}
