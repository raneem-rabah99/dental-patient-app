import 'dart:io';
import 'package:dentaltreatment/core/classes/icons_classes.dart';
import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/core/localization/app_strings.dart';
import 'package:dentaltreatment/features/home/data/models/detection_result.dart';
import 'package:dentaltreatment/features/home/data/models/result_t.dart';
import 'package:dentaltreatment/features/home/data/models/tooth_detection.dart';
import 'package:dentaltreatment/features/home/data/sources/teeth_detect_service.dart';
import 'package:dentaltreatment/features/home/presentation/pages/exact_dental_chart.dart';
import 'package:dentaltreatment/features/home/presentation/pages/home_page.dart';
import 'package:dentaltreatment/features/home/presentation/pages/upload_panorama_section.dart';
import 'package:dentaltreatment/features/home/presentation/managers/language_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AiPage extends StatefulWidget {
  const AiPage({super.key});

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  File? selectedImage;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LanguageCubit>().isArabic;
    final strings = AppStrings(isArabic);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Directionality(
          textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
          child: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: IconButton(
                  icon:
                      isArabic
                          ? Iconarowright.arrow(context)
                          : Iconarrowleft.arrow(context),
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
              strings.aiTreatment,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            centerTitle: true,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ⭐ Top Card (UNCHANGED)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4C8CFF), Color(0xFF8FC3FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.aiScanTitle,
                        style: const TextStyle(
                          fontFamily: 'Gabarito',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        strings.aiScanDesc,
                        style: const TextStyle(
                          fontFamily: 'Gabarito',
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 90,
                    width: 90,
                    child: Image.asset(
                      'assets/images/medical-check.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            UploadPanoramaSection(
              onImageSelected: (File image) {
                setState(() {
                  selectedImage = image;
                });
              },
            ),

            const SizedBox(height: 40),
            Row(
              children: [
                // 🦷 Detect Teeth
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.darkblue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 6,
                  ),
                  onPressed:
                      isLoading
                          ? null
                          : () async {
                            if (selectedImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please upload an image first"),
                                ),
                              );
                              return;
                            }

                            setState(() => isLoading = true);

                            try {
                              final service = DioService();
                              final List<DetectionResult> results =
                                  await service.detectTeeth(selectedImage!);

                              if (!mounted) return;
                              final List<ToothDetection> problems =
                                  results.map((e) {
                                    final parts = e.label.split('_');

                                    final quadrant = int.parse(parts[0]);
                                    final tooth = int.parse(parts[1]);
                                    final disease = parts.sublist(2).join(' ');
                                    final flutterTooth =
                                        (quadrant - 1) * 8 + tooth;

                                    return ToothDetection(
                                      tooth: flutterTooth,
                                      disease: disease,
                                      photo:
                                          e.photoPanoramaGenerated, // ✅ الصورة
                                    );
                                  }).toList();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          DentalChartPage(problems: problems),
                                ),
                              );
                            } finally {
                              if (mounted) {
                                setState(() => isLoading = false);
                              }
                            }
                          },
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                            strings.submit,
                            style: const TextStyle(
                              fontFamily: 'Gabarito',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                ),
                const SizedBox(width: 16),

                // 🧠 Orthodontic Diagnosis
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 60, 161, 80),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                    ),
                    onPressed:
                        isLoading
                            ? null
                            : () async {
                              if (selectedImage == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(strings.OrthodonticDiagnosis),
                                  ),
                                );
                                return;
                              }

                              setState(() => isLoading = true);

                              try {
                                final service = DioService();
                                final result = await service.diagnoseOrtho(
                                  selectedImage!,
                                );

                                final storage = const FlutterSecureStorage();

                                await storage.write(
                                  key: 'ortho_result',
                                  value:
                                      OrthoResult(
                                        upper: result["upper"],
                                        lower: result["lower"],
                                        finalResult: result["final"],
                                      ).toJson(),
                                );

                                if (!mounted) return;

                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => AlertDialog(
                                        title: Text(
                                          strings.OrthodonticDiagnosis,
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // ✅ Panorama Image (NEW – UI NOT CHANGED)
                                            if (result["panorama_photo"] !=
                                                null)
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  result["panorama_photo"],
                                                  height: 180,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (
                                                    context,
                                                    child,
                                                    progress,
                                                  ) {
                                                    if (progress == null)
                                                      return child;
                                                    return const Padding(
                                                      padding: EdgeInsets.all(
                                                        20,
                                                      ),
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  },
                                                  errorBuilder:
                                                      (_, __, ___) =>
                                                          const Icon(
                                                            Icons.broken_image,
                                                            size: 80,
                                                          ),
                                                ),
                                              ),

                                            const SizedBox(height: 12),

                                            _row("Upper :", result["upper"]),
                                            _row("Lower :", result["lower"]),
                                            const Divider(),
                                            _row(
                                              "Final Result:",
                                              result["final"],
                                              bold: true,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: Text(
                                              strings.Close,
                                              style: TextStyle(
                                                color: const Color.fromARGB(
                                                  255,
                                                  60,
                                                  161,
                                                  80,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );
                              } finally {
                                if (mounted) {
                                  setState(() => isLoading = false);
                                }
                              }
                            },
                    child: Text(
                      strings.OrthodonticDiagnosis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ===============================
// Helper Row Widget (UNCHANGED)
// ===============================
Widget _row(String title, String value, {bool bold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

class OrthoCache {
  static OrthoResult? result;
}
