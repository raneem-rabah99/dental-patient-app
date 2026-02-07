import 'package:dentaltreatment/core/classes/icons_classes.dart';
import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/core/localization/app_strings.dart';
import 'package:dentaltreatment/features/home/data/models/result_t.dart';
import 'package:dentaltreatment/features/home/data/models/teeth_response.dart';
import 'package:dentaltreatment/features/home/data/models/tooth_detection.dart';
import 'package:dentaltreatment/features/home/data/sources/teeth_service.dart';
import 'package:dentaltreatment/features/home/presentation/managers/language_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/pages/ai_page.dart';
import 'package:dentaltreatment/features/home/presentation/pages/teeth_section.dart';
import 'package:dentaltreatment/features/home/presentation/widgets/cleantoothimage.dart';
import 'package:dentaltreatment/core/api/base_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ShowResult extends StatefulWidget {
  const ShowResult({super.key});

  @override
  State<ShowResult> createState() => _ShowResultState();
}

class _ShowResultState extends State<ShowResult> {
  late TeethService _service;
  late Future<TeethApiResult> _fullResultFuture;

  @override
  void initState() {
    super.initState();
    _service = TeethService(ApiClient.dio, const FlutterSecureStorage());
    _fullResultFuture = _service.getFullTeethResult();

    _loadOrthoResult();
  }

  Future<void> _loadOrthoResult() async {
    final storage = const FlutterSecureStorage();
    final json = await storage.read(key: 'ortho_result');

    if (json != null) {
      OrthoCache.result = OrthoResult.fromJson(json);
    }
  }

  String formatApiDate(String? iso) {
    if (iso == null) return '';
    final d = DateTime.parse(iso).toLocal();
    return "${d.year}-${_two(d.month)}-${_two(d.day)} ${_two(d.hour)}:${_two(d.minute)}";
  }

  String _two(int n) => n.toString().padLeft(2, '0');
  void _showOrthodonticResult() {
    final result = OrthoCache.result;

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No orthodontic result available")),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),

              const Text(
                "Orthodontic Diagnosis Result",
                style: TextStyle(
                  fontFamily: 'Gabarito',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              _orthoRow("Upper", result.upper),
              _orthoRow("Lower", result.lower),

              const Divider(height: 30),

              _orthoRow("Final Result", result.finalResult, bold: true),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _orthoRow(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(context.watch<LanguageCubit>().isArabic);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return FutureBuilder<TeethApiResult>(
      future: _fullResultFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        if (!snapshot.hasData || snapshot.data!.teeth.isEmpty) {
          return _OriginalCard(strings);
        }

        final result = snapshot.data!;
        final teethDetections =
            result.teeth
                .map(
                  (e) => ToothDetection(
                    tooth: e.number,
                    disease: e.descripe,
                    photo: e.photoPanorama,
                    createdAt: e.createdAt,
                    updatedAt: e.updatedAt,
                  ),
                )
                .toList();

        final createdAt = result.teeth.first.createdAt;
        final updatedAt = result.teeth.first.updatedAt;

        return Column(
          children: [
            const SizedBox(height: 8),

            const Text(
              "Latest Scan Result",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 8),

            if (createdAt != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "🕒 Created: ${formatApiDate(createdAt)}",
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
              ),

            const SizedBox(height: 10),

            isMobile
                ? FittedBox(
                  fit: BoxFit.scaleDown,
                  child: TeethSection(problems: teethDetections),
                )
                : TeethSection(problems: teethDetections),

            const SizedBox(height: 10),

            if (updatedAt != null)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "🕒 Updated: ${formatApiDate(updatedAt)}",
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.darkblue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _showFullResult(context, result),
              child: const Text(
                "Show Full Result",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.lightblue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _showOrthodonticResult,
              child: const Text(
                "Show Orthodontic Result",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ===============================
  // 🧾 FULL RESULT Bottom Sheet
  // ===============================
  void _showFullResult(BuildContext context, TeethApiResult result) {
    final teethDetections =
        result.teeth
            .map(
              (e) => ToothDetection(
                tooth: e.number,
                disease: e.descripe,
                photo: e.photoPanorama,
                createdAt: e.createdAt,
                updatedAt: e.updatedAt,
              ),
            )
            .toList();
    final isMobile = MediaQuery.of(context).size.width < 600;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SizedBox(
              height: 80,
              child: Center(
                child: Text(
                  'Latest Scan Result',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColor.darkblue,
                  ),
                ),
              ),
            ),
            // 🖼️ Panorama Image (photo)
            if (result.panoramaPhoto != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  result.panoramaPhoto!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 20),
            isMobile
                ? FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 100, 100, 100),
                      ),

                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TeethSection(problems: teethDetections),
                  ),
                )
                : TeethSection(problems: teethDetections),
            const SizedBox(height: 20),
            ...result.teeth.map((t) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: SizedBox(
                    width: 40,
                    height: 40,
                    child: CleanToothImage(
                      path: 'assets/icons/icon_teeth/teeth_${t.number}.jpg',
                      size: 40,
                      isProblem: true,
                      overlayColor: const Color.fromARGB(255, 207, 207, 207),
                    ),
                  ),
                  title: Text(
                    "Tooth ${t.number}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(t.descripe),
                  trailing:
                      t.photoPanorama != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              t.photoPanorama!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                          : null,
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}

// ===============================
// 🟦 UI الأصلي (بدون تغيير)
// ===============================
class _OriginalCard extends StatelessWidget {
  final AppStrings strings;
  const _OriginalCard(this.strings);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          width: 360,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color.fromARGB(255, 43, 121, 255).withOpacity(0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(
                  255,
                  188,
                  188,
                  188,
                ).withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icondental.dentalshow,
              const SizedBox(height: 12),

              Text(
                strings.showResultTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Gabarito',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColor.darkblue,
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  strings.showResultDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Gabarito',
                    fontSize: 13,
                    height: 1.6,
                    color: AppColor.lightblue,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                strings.showResultDesc,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Gabarito',
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 22),

              // ⭐ Navigation Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.darkblue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  shadowColor: Colors.blueAccent,
                  elevation: 6,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AiPage()),
                  );
                },
                child: Text(
                  strings.startAiTreatment,
                  style: const TextStyle(
                    fontFamily: 'Gabarito',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
