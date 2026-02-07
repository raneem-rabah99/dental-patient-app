class DetectionResult {
  final String label;
  final String? photoPanoramaGenerated;

  DetectionResult({required this.label, this.photoPanoramaGenerated});

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(
      label: json["label"].toString(),
      photoPanoramaGenerated: json["photo_panorama_generated"],
    );
  }
}
