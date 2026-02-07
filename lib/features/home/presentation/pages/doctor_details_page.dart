import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/core/localization/app_strings.dart';
import 'package:dentaltreatment/features/home/presentation/managers/language_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/doctor_details_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/doctor_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorDetailsPage extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const DoctorDetailsPage({super.key, required this.doctor});

  @override
  State<DoctorDetailsPage> createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  late final DoctorDetailsCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = DoctorDetailsCubit(widget.doctor);
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LanguageCubit>().isArabic;
    final strings = AppStrings(isArabic);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return BlocProvider.value(
      value: cubit,
      child: BlocConsumer<DoctorDetailsCubit, DoctorDetailsState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: colors.error,
              ),
            );
          }

          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: colors.primary,
              ),
            );
          }
        },
        builder: (context, state) {
          final ImageProvider imageProvider =
              widget.doctor["image"] != null &&
                      widget.doctor["image"].toString().startsWith("http")
                  ? NetworkImage(widget.doctor["image"])
                  : const AssetImage("assets/images/default_profile.png");

          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,

            appBar: AppBar(
              backgroundColor: theme.appBarTheme.backgroundColor,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                widget.doctor["name"],
                style: theme.appBarTheme.titleTextStyle,
              ),
              centerTitle: true,
            ),

            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _profileCard(context, widget.doctor, imageProvider, strings),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _beforeAfterCard(
                        context,
                        strings.before,
                        'assets/images/before.png',
                      ),
                      _beforeAfterCard(
                        context,
                        strings.after,
                        'assets/images/after.png',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ================= TIME PICKER =================
                      _pickerButton(
                        context,
                        label:
                            state.selectedTime == null
                                ? strings.selectTime
                                : state.selectedTime!.format(context),
                        icon: Icons.access_time,
                        onTap: () async {
                          final initial = cubit.rangeStart;

                          final t = await showTimePicker(
                            context: context,
                            initialTime: initial,

                            // 👇 keep default Material time picker UI (AM / PM)
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  timePickerTheme: TimePickerThemeData(
                                    dialHandColor: AppColor.darkblue,
                                    hourMinuteColor: AppColor.darkblue
                                        .withOpacity(0.15),
                                    hourMinuteTextColor: AppColor.darkblue,
                                    dayPeriodColor: AppColor.darkblue
                                        .withOpacity(0.2),
                                    dayPeriodTextColor: AppColor.darkblue,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          // 🔥 DO NOT CHANGE LOGIC
                          cubit.selectTime(t ?? initial);
                        },
                      ),

                      // ================= DATE PICKER =================
                      _pickerButton(
                        context,
                        label:
                            state.selectedDate == null
                                ? strings.selectDate
                                : "${state.selectedDate!.day}/${state.selectedDate!.month}/${state.selectedDate!.year}",
                        icon: Icons.calendar_month,
                        onTap: () async {
                          final d = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                            initialDate: DateTime.now(),
                          );
                          if (d != null) cubit.selectDate(d);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  state.isLoading
                      ? CircularProgressIndicator(color: AppColor.darkblue)
                      : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.darkblue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: cubit.bookAppointment,
                        child: Text(
                          strings.takeDate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= PROFILE CARD =================
  Widget _profileCard(
    BuildContext context,
    Map<String, dynamic> doctor,
    ImageProvider imageProvider,
    AppStrings strings,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.1)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColor.lightblue,
            radius: 40,
            backgroundImage: imageProvider,
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doctor["name"], style: theme.textTheme.titleMedium),
                Text(
                  doctor["location"] ?? "",
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  "${strings.specialization}: ${doctor["specialization"]}",
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  "${strings.distance}: ${doctor["distance"]}",
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 6),
                Text(
                  "${strings.availableTime}: ${doctor["time"]}",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= BEFORE / AFTER CARD =================
  Widget _beforeAfterCard(BuildContext context, String label, String img) {
    final theme = Theme.of(context);

    return Container(
      width: 150,
      height: 140,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(img, height: 70),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ================= PICKER BUTTON =================
  Widget _pickerButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: theme.iconTheme.color),
            const SizedBox(width: 8),
            Text(label, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
