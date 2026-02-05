class BookingCardModel {
  final int? id; // NOT REQUIRED
  final String userName;
  final String location;
  final String date;
  final String time;
  final String? status; // NOT REQUIRED

  BookingCardModel({
    this.id, // not required
    required this.userName,
    required this.location,
    required this.date,
    required this.time,
    this.status, // not required
  });

  factory BookingCardModel.fromJson(Map<String, dynamic> json) {
    final user = json["user"] ?? {};

    return BookingCardModel(
      id: json["id"], // can be null
      userName: "${user["first_name"] ?? ""} ${user["last_name"] ?? ""}",
      location: user["address"] ?? "Unknown",
      date: json["date"] ?? "",
      time: json["time"] ?? "",
      status: json["status"], // can be null
    );
  }
}
