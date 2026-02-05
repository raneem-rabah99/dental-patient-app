class BookingCardModel {
  final int id;
  final String userName;
  final String location;
  final String date;
  final String time;
  final String status;

  BookingCardModel({
    required this.id,
    required this.userName,
    required this.location,
    required this.date,
    required this.time,
    required this.status,
  });

  factory BookingCardModel.fromJson(Map<String, dynamic> json) {
    final user = json["user"] ?? {};

    return BookingCardModel(
      id: json["id"] ?? 0,
      userName: "${user["first_name"] ?? ""} ${user["last_name"] ?? ""}",
      location: user["address"] ?? "Unknown",
      date: json["date"] ?? "",
      time: json["time"] ?? "",
      status: json["status"] ?? "pending",
    );
  }
}
