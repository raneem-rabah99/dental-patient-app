class BookingStatusModel {
  final int id;
  final String doctorName;
  final String doctorAddress;
  final String date;
  final String time;
  final String status;

  BookingStatusModel({
    required this.id,
    required this.doctorName,
    required this.doctorAddress,
    required this.date,
    required this.time,
    required this.status,
  });

  factory BookingStatusModel.fromJson(Map<String, dynamic> json) {
    return BookingStatusModel(
      id: json["id"] ?? 0,
      doctorName: json["doctor_name"] ?? "",
      doctorAddress: json["doctor_address"] ?? "",
      date: json["date"] ?? "",
      time: json["time"] ?? "",
      status: json["status"] ?? "",
    );
  }
}
