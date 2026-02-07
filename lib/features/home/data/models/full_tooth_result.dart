class FullToothResult {
  final int id;
  final String name; // مثل 2_7
  final int number; // 1–32
  final String descripe;
  final String? photoPanorama;
  final String createdAt;
  final String updatedAt;

  FullToothResult({
    required this.id,
    required this.name,
    required this.number,
    required this.descripe,
    required this.photoPanorama,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FullToothResult.fromApi(Map<String, dynamic> json) {
    return FullToothResult(
      id: json['id'],
      name: json['name'],
      number: json['number'],
      descripe: json['descripe'],
      photoPanorama: json['photo_panorama_generated'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
