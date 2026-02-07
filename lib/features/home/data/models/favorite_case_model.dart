class FavoriteCaseModel {
  final String? photoBefore;
  final String? photoAfter;
  final String? firstName;
  final String? lastName;
  final double? averageRate;

  // ✅ NEW FIELDS
  final String? location;
  final String? specialization;
  final String? distance;
  final String? availableTime;

  FavoriteCaseModel({
    this.photoBefore,
    this.photoAfter,
    this.firstName,
    this.lastName,
    this.averageRate,
    this.location,
    this.specialization,
    this.distance,
    this.availableTime,
  });

  factory FavoriteCaseModel.fromJson(Map<String, dynamic> json) {
    return FavoriteCaseModel(
      photoBefore: json["photo_before"],
      photoAfter: json["photo_after"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      averageRate: double.tryParse(json["average_rate"].toString()) ?? 0.0,

      // ✅ NEW FIELDS
      location: json["location"] ?? "Unknown",
      specialization: json["specialization"] ?? "Dental Specialist",
      distance: json["distance"] ?? "2 km",
      availableTime: json["available_time"] ?? "9:00 AM - 5:00 PM",
    );
  }
}
