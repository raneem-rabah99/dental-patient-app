import 'package:dentaltreatment/core/api/base_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/doctor_model.dart';

class DoctorService {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<List<DoctorModel>> fetchDoctors() async {
    final token = await secureStorage.read(key: 'token');

    final response = await ApiClient.dio.get(
      "/customer/doctors",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final data = response.data;

    if (response.statusCode == 200 && data["status"] == true) {
      final List doctors = data["data"];
      return doctors.map((d) => DoctorModel.fromJson(d)).toList();
    } else {
      throw Exception(data["message"] ?? "Failed to fetch doctors");
    }
  }
}
