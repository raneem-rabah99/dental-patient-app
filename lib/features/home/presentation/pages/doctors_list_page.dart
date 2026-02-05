import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dentaltreatment/features/home/data/models/doctor_model.dart';
import '../managers/doctor_cubit.dart';
import '../managers/doctor_state.dart';
import 'doctor_details_page.dart';

class DoctorsListPage extends StatefulWidget {
  const DoctorsListPage({super.key});

  @override
  State<DoctorsListPage> createState() => _DoctorsListPageState();
}

class _DoctorsListPageState extends State<DoctorsListPage> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Doctors",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF234E9D),
          ),
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Color(0xFF4C89FF), Color(0xFF6AA7FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.medical_information,
                    color: Colors.white,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Click the right doctor for your needs.\nSearch by doctor, specialization, or location.",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged:
                  (value) => context.read<DoctorCubit>().searchDoctors(value),
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(fontSize: 15),
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<DoctorCubit, DoctorState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.error != null) {
                  return Center(child: Text(state.error!));
                }

                final doctors = state.doctors;

                if (doctors.isEmpty) {
                  return const Center(child: Text("No doctors found"));
                }

                return ListView.builder(
                  itemCount: doctors.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];

                    return _doctorItem(context, doctor);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _doctorItem(BuildContext context, DoctorModel doctor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => DoctorDetailsPage(
                  doctor: {
                    "id": doctor.id, // ← FIXED 🔥🔥🔥 IMPORTANT
                    "name": doctor.name,
                    "location": context.read<DoctorCubit>().cleanAddress(
                      doctor.location,
                    ),
                    "specialization": doctor.specialization,
                    "distance":
                        doctor.distanceKm != null
                            ? "${doctor.distanceKm!.toStringAsFixed(2)} KM"
                            : "N/A",
                    "time": doctor.time,
                    "image": doctor.photo,
                  },
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.14),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: AppColor.lightblue,
              backgroundImage:
                  doctor.photo != null
                      ? NetworkImage(doctor.photo!)
                      : const AssetImage("assets/images/default_profile.png")
                          as ImageProvider,
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    context.read<DoctorCubit>().cleanAddress(doctor.location),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text("Specialization: ${doctor.specialization}"),
                  Text("Time: ${doctor.time}"),
                ],
              ),
            ),

            Column(
              children: [
                const Icon(Icons.location_on, color: Colors.blue),
                Text(
                  doctor.distanceKm != null
                      ? "${doctor.distanceKm!.toStringAsFixed(2)} KM"
                      : "N/A",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
