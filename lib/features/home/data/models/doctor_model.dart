class DoctorModel {
  final int id;
  final String name;
  final String specialization;
  final String location;
  final String time;
  final String? photo;
  final double? distanceKm;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.location,
    required this.time,
    this.photo,
    this.distanceKm,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    final user = json["user"];

    String fullName =
        "${user["first_name"]} ${user["father_name"]} ${user["last_name"]}";

    String openTime = json["open_time"] ?? "09:00";
    String closeTime = json["close_time"] ?? "17:00";

    return DoctorModel(
      id: json["id"],
      name: fullName,
      specialization: json["specialization"] ?? "Unknown",
      location: user["address"] ?? "Unknown",
      time: "$openTime - $closeTime",
      photo: user["photo"],
      distanceKm:
          json["distance_km"] != null ? json["distance_km"].toDouble() : null,
    );
  }
}
