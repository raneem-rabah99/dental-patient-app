import 'package:dentaltreatment/core/classes/icons_classes.dart';
import 'package:dentaltreatment/core/localization/app_strings.dart';
import 'package:dentaltreatment/features/home/data/models/tooth_detection.dart';
import 'package:dentaltreatment/features/home/presentation/managers/language_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/pages/ai_page.dart';
import 'package:dentaltreatment/features/home/presentation/pages/teeth_section.dart';
import 'package:dentaltreatment/features/home/presentation/widgets/cleantoothimage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DentalChartPage extends StatelessWidget {
  final List<ToothDetection> problems;

  const DentalChartPage({super.key, required this.problems});

  // ================= LOGIC =================

  Color getColorForDisease(String disease) {
    final d = disease.toLowerCase();
    if (d.contains('periapical')) return Colors.green;
    if (d.contains('impacted')) return Colors.purple;
    if (d.contains('caries')) return Colors.orange;
    if (d.contains('deep')) return Colors.red;
    return Colors.grey;
  }

  int severity(String disease) {
    final d = disease.toLowerCase();
    if (d.contains('periapical')) return 4;
    if (d.contains('impacted')) return 3;
    if (d.contains('caries')) return 2;
    return 1;
  }

  // ================= ISSUES =================

  List<_Issue> get sortedIssues {
    final list =
        problems
            .map(
              (p) => _Issue(tooth: p.tooth, disease: p.disease, photo: p.photo),
            )
            .toList();

    list.sort((a, b) => severity(b.disease).compareTo(severity(a.disease)));
    return list;
  }

  // ================= UI =================

  void showDetails(BuildContext context, _Issue issue) {
    final color = getColorForDisease(issue.disease);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Tooth ${issue.tooth}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.warning, color: color),
                    const SizedBox(width: 6),
                    Text(
                      issue.disease,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (issue.photo != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 1.2,
                      child: Image.network(
                        issue.photo!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.broken_image, size: 48),
                            ),
                      ),
                    ),
                  ),
                if (issue.photo == null)
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        "No panorama image available",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildIssueCard(BuildContext context, _Issue issue, int index) {
    final color = getColorForDisease(issue.disease);

    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 260),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 250 + index * 70),
          builder:
              (context, v, child) => Opacity(
                opacity: v,
                child: Transform.translate(
                  offset: Offset(0, 12 * (1 - v)),
                  child: child,
                ),
              ),
          child: GestureDetector(
            onTap: () => showDetails(context, issue),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withOpacity(0.35)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),

                  /// 🦷 Tooth icon
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CleanToothImage(
                      path: 'assets/icons/icon_teeth/teeth_${issue.tooth}.jpg',
                      size: 40,
                      isProblem: true,
                      overlayColor: const Color.fromARGB(255, 207, 207, 207),
                    ),
                  ),

                  const SizedBox(width: 20),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tooth ${issue.tooth}",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        issue.disease,
                        style: TextStyle(
                          fontSize: 9,
                          color: color,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 20),

                  /// 🖼️ Panorama crop
                  if (issue.photo != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        issue.photo!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.broken_image, size: 18),
                            ),
                      ),
                    ),

                  if (issue.photo != null) const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isArabic = context.watch<LanguageCubit>().isArabic;
    final strings = AppStrings(isArabic);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0FA),
      appBar: AppBar(
        title: Text(strings.aiTreatment),
        centerTitle: true,
        leading: IconButton(
          icon:
              isArabic
                  ? Iconarowright.arrow(context)
                  : Iconarrowleft.arrow(context),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AiPage()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              // ✅ TeethSection المستقلة
              isMobile
                  ? FittedBox(
                    fit: BoxFit.scaleDown,
                    child: TeethSection(problems: problems),
                  )
                  : TeethSection(problems: problems),

              const SizedBox(height: 24),

              ...List.generate(
                sortedIssues.length,
                (i) => buildIssueCard(context, sortedIssues[i], i),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= MODEL =================

class _Issue {
  final int tooth;
  final String disease;
  final String? photo;

  _Issue({required this.tooth, required this.disease, this.photo});
}
