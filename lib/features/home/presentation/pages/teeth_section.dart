import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/features/home/data/models/tooth_detection.dart';
import 'package:dentaltreatment/features/home/presentation/widgets/cleantoothimage.dart';
import 'package:flutter/material.dart';

class TeethSection extends StatelessWidget {
  final List<ToothDetection> problems;

  const TeethSection({super.key, required this.problems});

  bool isProblemForTooth(int tooth) {
    return problems.any((p) => p.tooth == tooth);
  }

  String? getDiseaseForTooth(int tooth) {
    for (final p in problems) {
      if (p.tooth == tooth) return p.disease;
    }
    return null;
  }

  Color getColorForDisease(String disease) {
    final d = disease.toLowerCase();
    if (d.contains('periapical')) return Colors.green;
    if (d.contains('impacted')) return Colors.purple;
    if (d.contains('caries')) return Colors.orange;
    if (d.contains('deep')) return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final upper = List.generate(16, (i) => i + 1);
    final lower = List.generate(16, (i) => 32 - i);

    Widget numbersRow(List<int> teeth) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          teeth
              .map(
                (n) => SizedBox(
                  width: 36,
                  child: Center(
                    child: Text(
                      '$n',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColor.darkblue,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
    );

    Widget teethRow(List<int> teeth) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          teeth.map((n) {
            final disease = getDiseaseForTooth(n);
            return SizedBox(
              width: 36,
              child: Tooltip(
                message: disease == null ? "Healthy" : disease,
                child: CleanToothImage(
                  path: 'assets/icons/icon_teeth/teeth_$n.jpg',
                  size: 70,
                  isProblem: isProblemForTooth(n),
                  overlayColor:
                      disease == null ? null : getColorForDisease(disease),
                ),
              ),
            );
          }).toList(),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        numbersRow(upper),
        const SizedBox(height: 4),
        teethRow(upper),
        const SizedBox(height: 20),
        teethRow(lower),
        const SizedBox(height: 4),
        numbersRow(lower),
      ],
    );
  }
}
