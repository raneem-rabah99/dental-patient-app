import 'package:dentaltreatment/features/home/presentation/widgets/cleantoothimage.dart';
import 'package:flutter/material.dart';
// import where CleanToothImage is defined:

class DentalChartPage extends StatelessWidget {
  const DentalChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final upper = List.generate(16, (i) => i + 1); // 1..16
    final lower = List.generate(16, (i) => 32 - i); // 32..17

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0FA),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: FittedBox(
              fit: BoxFit.contain, // makes sure nothing overflows
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 26,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _DentalChart(upper: upper, lower: lower),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DentalChart extends StatelessWidget {
  final List<int> upper;
  final List<int> lower;

  const _DentalChart({required this.upper, required this.lower});

  // 🔽 control size & spacing here
  final double toothWidth = 20;
  final double toothHeight = 70;
  final double spacing = 20;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ---------------- TOP NUMBERS ----------------
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              upper.map((n) {
                return SizedBox(
                  width: toothWidth * 1.8,
                  child: Center(
                    child: Text(
                      '$n',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),

        const SizedBox(height: 4),

        // ---------------- TOP TEETH ----------------
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              upper.map((n) {
                return SizedBox(
                  width: toothWidth * 1.8,
                  child: Center(
                    child: CleanToothImage(
                      path: 'assets/icons/icon_teeth/teeth_$n.jpg',
                      size: toothHeight,
                    ),
                  ),
                );
              }).toList(),
        ),

        const SizedBox(height: 20),

        // ---------------- BOTTOM TEETH ----------------
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              lower.map((n) {
                return SizedBox(
                  width: toothWidth * 1.8,
                  child: Center(
                    child: CleanToothImage(
                      path: 'assets/icons/icon_teeth/teeth_$n.jpg',
                      size: toothHeight,
                    ),
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 4),

        // ---------------- BOTTOM NUMBERS ----------------
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              lower.map((n) {
                return SizedBox(
                  width: toothWidth * 1.8,
                  child: Center(
                    child: Text(
                      '$n',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
