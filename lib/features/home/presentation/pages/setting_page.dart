import 'package:dentaltreatment/core/classes/icons_classes.dart';
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
            'Setting',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // 🔵 DARK MODE
            buildTileContainer(
              child: settingToggle(
                context: context,
                title: "Dark Mode",
                value: context.watch<ThemeCubit>().state == ThemeMode.dark,
                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
              ),
            ),

            const SizedBox(height: 12),

            // 🌍 LANGUAGE
            buildTileContainer(
              child: settingToggle(
                context: context,
                title: "Language (AR/EN)",
                value: context.watch<LanguageCubit>().state == "ar",
                onChanged: (_) => context.read<LanguageCubit>().toggleLang(),
              ),
            ),

            const SizedBox(height: 12),

            // ⭐ RATE + FEEDBACK COMBINED
            buildTileContainer(
              child: settingTile(
                context: context,
                title: "Rate & Feedback",
                icon: Icons.star,
                onTap: () => _showRateFeedbackDialog(context),
              ),
            ),

            const SizedBox(height: 12),

            // 🔴 LOGOUT
            buildTileContainer(
              child: settingTileRed(
                context: context,
                title: "Log Out",
                onTap: () => confirmLogout(context),
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // ---------------- TILE CONTAINER ----------------
  Widget buildTileContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 216, 216, 216).withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }

  // ---------------- TOGGLE UI ----------------
  Widget settingToggle({
    required BuildContext context,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Serif',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColor.darkblue,
          ),
        ],
      ),
    );
  }

  // ---------------- NORMAL TILE ----------------
  Widget settingTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Serif',
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(icon, size: 22, color: Colors.amber),
          ],
        ),
      ),
    );
  }

  // ---------------- RED TILE ----------------
  Widget settingTileRed({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Serif',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.red.shade700,
          ),
        ),
      ),
    );
  }

  // ---------------- RATE + FEEDBACK DIALOG (COMBINED) ----------------
  void _showRateFeedbackDialog(BuildContext context) {
    double rating = 0;
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: const Text("Rate & Feedback"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Tap the stars to rate:"),
                  const SizedBox(height: 10),

                  // ⭐⭐⭐⭐⭐ STAR ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          size: 32,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() => rating = index + 1.0);
                        },
                      );
                    }),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: feedbackController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Write your feedback here...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (rating == 0) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a rating."),
                        ),
                      );
                      return;
                    }

                    dialogContext.read<RateAppCubit>().rateApp(
                      rate: rating.toInt(),
                      feedback: feedbackController.text.trim(),
                    );

                    Navigator.pop(dialogContext);
                  },
                  child: const Text("Send"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// ---------------- CONFIRM LOGOUT ----------------
void confirmLogout(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return BlocListener<LogoutCubit, LogoutState>(
        listener: (dialogContext, state) {
          if (state.isLoading) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Logging out...")));
          }

          if (state.success) {
            Navigator.pop(context); // close dialog
            Navigator.pushNamedAndRemoveUntil(
              context,
              "/login",
              (route) => false,
            ); // go to Login page
          }

          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        child: AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                dialogContext.read<LogoutCubit>().logout();
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    },
  );
}

// ---------------- CONFIRM DELETE ----------------
void confirmDelete(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: const Text("Delete Account"),
          content: const Text("This action cannot be undone. Continue?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                context.read<AccountCubit>().deleteAccount();
                Navigator.pop(context);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
  );
}
