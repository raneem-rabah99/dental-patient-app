import 'package:flutter/material.dart';
import 'package:dentaltreatment/features/home/data/models/tooth_detection.dart';
import 'package:dentaltreatment/features/home/presentation/widgets/cleantoothimage.dart';

class TeethSection extends StatelessWidget {
  final List<ToothDetection> problems;
  final void Function(int tooth, String disease)? onToothTap; // اختياري

  const TeethSection({super.key, required this.problems, this.onToothTap});

  // هل هذا السن فيه مشكلة؟
  bool isProblemForTooth(int tooth) {
    return problems.any((p) => p.tooth == tooth);
  }

  // جلب المرض إن وجد
  String? getDisease(int tooth) {
    for (final p in problems) {
      if (p.tooth == tooth) return p.disease;
    }
    return null;
  }

  // لون حسب المرض
  Color getColor(String disease) {
    final d = disease.toLowerCase();
    if (d.contains('periapical')) return Colors.green;
    if (d.contains('impacted')) return Colors.purple;
    if (d.contains('caries')) return Colors.orange;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final upper = List.generate(16, (i) => i + 1);
    final lower = List.generate(16, (i) => 32 - i);

    Widget buildRow(List<int> teeth) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            teeth.map((n) {
              final disease = getDisease(n);

              return SizedBox(
                width: 36,
                child: GestureDetector(
                  onTap:
                      disease == null || onToothTap == null
                          ? null
                          : () => onToothTap!(n, disease),
                  child: CleanToothImage(
                    path: 'assets/icons/icon_teeth/teeth_$n.jpg',
                    size: 70,
                    isProblem: isProblemForTooth(n),
                    overlayColor: disease == null ? null : getColor(disease),
                  ),
                ),
              );
            }).toList(),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [buildRow(upper), const SizedBox(height: 20), buildRow(lower)],
    );
  }
}
