import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/features/home/presentation/managers/doctor_details_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/doctor_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorDetailsPage extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const DoctorDetailsPage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorDetailsCubit(doctor),
      child: BlocConsumer<DoctorDetailsCubit, DoctorDetailsState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: const Color.fromARGB(255, 255, 156, 156),
              ),
            );
          }

          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: const Color.fromARGB(255, 69, 196, 255),
              ),
            );
          }
        },

        builder: (context, state) {
          final cubit = context.read<DoctorDetailsCubit>();

          ImageProvider imageProvider =
              doctor["image"] != null &&
                      doctor["image"].toString().startsWith("http")
                  ? NetworkImage(doctor["image"])
                  : const AssetImage("assets/images/default_profile.png");

          return Scaffold(
            backgroundColor: const Color(0xFFF7F9FB),

            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                doctor["name"],
                style: const TextStyle(
                  fontFamily: "Gabarito",
                  fontSize: 18,
                  color: Color(0xFF234E9D),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _profileCard(doctor, imageProvider),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _beforeAfterCard('Before', 'assets/images/before.png'),
                      _beforeAfterCard('After', 'assets/images/after.png'),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _pickerButton(
                        label:
                            state.selectedTime == null
                                ? "Select Time"
                                : state.selectedTime!.format(context),
                        icon: Icons.access_time,
                        onTap: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (t != null) cubit.selectTime(t);
                        },
                      ),

                      _pickerButton(
                        label:
                            state.selectedDate == null
                                ? "Select Date"
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
                      ? const CircularProgressIndicator()
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
                        onPressed: () {
                          cubit.bookAppointment();
                        },
                        child: const Text(
                          "Take a Date",
                          style: TextStyle(
                            fontFamily: "Gabarito",
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

  // ----------------------------------------------------------

  Widget _profileCard(
    Map<String, dynamic> doctor,
    ImageProvider imageProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.grey.withOpacity(0.15)),
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
                Text(
                  doctor["name"],
                  style: const TextStyle(
                    fontFamily: "Gabarito",
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                Text(
                  (doctor["location"] ?? "").toString(),
                  style: const TextStyle(
                    fontFamily: "Gabarito",
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                Text(
                  "Specialization: ${doctor["specialization"]}",
                  style: const TextStyle(fontFamily: "Gabarito", fontSize: 12),
                ),
                Text(
                  "Distance: ${doctor["distance"]}",
                  style: const TextStyle(fontFamily: "Gabarito", fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  "Available Time: ${doctor["time"]}",
                  style: const TextStyle(
                    fontFamily: "Gabarito",
                    fontSize: 12,
                    color: Colors.blue,
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

  Widget _beforeAfterCard(String label, String img) {
    return Container(
      width: 150,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(img, height: 70),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: "Gabarito",
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pickerButton({
    required String label,
    required IconData icon,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blueAccent),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontFamily: "Gabarito", fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
