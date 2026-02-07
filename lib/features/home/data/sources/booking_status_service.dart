import 'package:dentaltreatment/core/api/base_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dentaltreatment/features/home/data/models/booking_status_model.dart';

class BookingStatusService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<BookingStatusModel>> loadByStatus(String status) async {
    try {
      // 🔐 Get token
      final token = await _storage.read(key: "token");
      if (token == null) throw Exception("User not authenticated!");

      // 🔥 API call
      final response = await ApiClient.dio.post(
        "/customer/bookings",
        data: {"status": status},
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      // 🔄 Parse response
      if (response.statusCode == 200 && response.data["status"] == true) {
        final List dataList = response.data["data"];
        return dataList.map((e) => BookingStatusModel.fromJson(e)).toList();
      } else {
        throw Exception(response.data["message"] ?? "Failed to load bookings.");
      }
    } catch (e) {
      throw Exception("Error loading bookings: $e");
    }
  }
}
