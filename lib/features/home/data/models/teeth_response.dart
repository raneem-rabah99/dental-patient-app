import 'package:dentaltreatment/features/home/data/models/full_tooth_result.dart';

class TeethApiResult {
  final String? panoramaPhoto;
  final List<FullToothResult> teeth;

  TeethApiResult({required this.panoramaPhoto, required this.teeth});

  factory TeethApiResult.fromApi(Map<String, dynamic> json) {
    return TeethApiResult(
      panoramaPhoto: json['photo'],
      teeth:
          (json['teeth'] as List)
              .map((e) => FullToothResult.fromApi(e))
              .toList(),
    );
  }
}
