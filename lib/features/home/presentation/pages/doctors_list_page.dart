import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/core/localization/app_strings.dart';
import 'package:dentaltreatment/features/home/presentation/managers/language_cubit.dart';
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
    final isArabic = context.watch<LanguageCubit>().isArabic;
    final strings = AppStrings(isArabic);

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: AppBar(
            backgroundColor: theme.appBarTheme.backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              strings.doctors,
              style: theme.appBarTheme.titleTextStyle,
            ),
            centerTitle: true,
          ),
        ),
      ),

      body: Column(
        children: [
          // ===== INFO CARD =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4C89FF), Color(0xFF6AA7FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_search,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      strings.doctorsHint,
                      style: const TextStyle(
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

          // ===== SEARCH =====
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged:
                  (value) => context.read<DoctorCubit>().searchDoctors(value),
              decoration: InputDecoration(
                hintText: strings.search,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ===== LIST =====
          Expanded(
            child: BlocBuilder<DoctorCubit, DoctorState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColor.darkblue),
                  );
                }

                if (state.error != null) {
                  return Center(child: Text(state.error!));
                }

                final doctors = state.doctors;

                if (doctors.isEmpty) {
                  return Center(child: Text(strings.noDoctors));
                }

                return ListView.builder(
                  itemCount: doctors.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return _doctorItem(context, doctor, strings);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _doctorItem(
    BuildContext context,
    DoctorModel doctor,
    AppStrings strings,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => DoctorDetailsPage(
                  doctor: {
                    "id": doctor.id,
                    "name": doctor.name,
                    "location": context.read<DoctorCubit>().cleanAddress(
                      doctor.location,
                    ),
                    "specialization": doctor.specialization,
                    "distance":
                        doctor.distanceKm != null
                            ? "${doctor.distanceKm!.toStringAsFixed(2)} ${strings.km}"
                            : strings.notAvailable,
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
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
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
                  Text(doctor.name, style: theme.textTheme.titleMedium),
                  Text(
                    context.read<DoctorCubit>().cleanAddress(doctor.location),
                    style: theme.textTheme.bodySmall,
                  ),
                  Text("${strings.specialization}: ${doctor.specialization}"),
                  Text("${strings.time}: ${doctor.time}"),
                ],
              ),
            ),

            Column(
              children: [
                const Icon(Icons.location_on, color: Colors.blue),
                Text(
                  doctor.distanceKm != null
                      ? "${doctor.distanceKm!.toStringAsFixed(2)} ${strings.km}"
                      : strings.notAvailable,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
