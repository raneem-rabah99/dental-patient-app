class ToothDetection {
  final int tooth; // 1–32
  final String disease;
  final String? photo;

  // 🆕 تواريخ
  final String? createdAt;
  final String? updatedAt;

  ToothDetection({
    required this.tooth,
    required this.disease,
    this.photo,
    this.createdAt,
    this.updatedAt,
  });

  factory ToothDetection.fromApi(Map<String, dynamic> json) {
    return ToothDetection(
      tooth: json['number'],
      disease: json['descripe'],
      photo: json['photo_panorama_generated'],
      createdAt: json['created_at'], // ✅
      updatedAt: json['updated_at'], // ✅
    );
  }
}
