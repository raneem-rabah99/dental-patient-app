import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/booking_card_model.dart';

class BookingService {
  final _storage = const FlutterSecureStorage();

  Future<List<BookingCardModel>> getBookings() async {
    final token = await _storage.read(key: "token");
    if (token == null) throw Exception("Token not found");

    final response = await Dio().get(
      "https://13badca320dc.ngrok-free.app/api/customer/bookings",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    final List data = response.data["bookings"] ?? [];

    return data.map((e) => BookingCardModel.fromJson(e)).toList();
  }
}
