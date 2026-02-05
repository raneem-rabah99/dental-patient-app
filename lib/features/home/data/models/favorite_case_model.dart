class FavoriteCaseModel {
  final String? photoBefore;
  final String? photoAfter;
  final String? firstName;
  final String? lastName;
  final double? averageRate;

  FavoriteCaseModel({
    this.photoBefore,
    this.photoAfter,
    this.firstName,
    this.lastName,
    this.averageRate,
  });

  factory FavoriteCaseModel.fromJson(Map<String, dynamic> json) {
    return FavoriteCaseModel(
      photoBefore: json["photo_before"],
      photoAfter: json["photo_after"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      averageRate: double.tryParse(json["average_rate"].toString()) ?? 0.0,
    );
  }
}
