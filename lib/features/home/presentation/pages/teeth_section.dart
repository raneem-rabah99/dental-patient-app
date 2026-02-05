import 'package:flutter/material.dart';
import 'exact_dental_chart.dart';

class TeethPage extends StatelessWidget {
  const TeethPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEAF7),
      appBar: AppBar(title: const Text("Dental Chart"), centerTitle: true),
      body: const DentalChartPage(),
    );
  }
}
