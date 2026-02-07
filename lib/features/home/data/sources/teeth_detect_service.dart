import 'dart:io';
import 'package:dentaltreatment/core/api/base_url.dart';
import 'package:dentaltreatment/features/home/data/models/detection_result.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioService {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  // ============================
  // 🦷 AI Detect Teeth
  // ============================
  Future<List<DetectionResult>> detectTeeth(File image) async {
    final token = await secureStorage.read(key: 'token');

    final formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
    });

    final response = await ApiClient.dio.post(
      "/ai/detect-teeth",
      data: formData,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final data = response.data;

    if (response.statusCode == 200 && data["status"] == true) {
      final List teeth = data["data"]["teeth"];

      return teeth.map<DetectionResult>((t) {
        final name = t["name"]; // "1_8"
        final condition = t["condition"]; // "Caries"
        final photo = t["photo_panorama_generated"]; // 👈 الصورة من API

        return DetectionResult(
          label: "${name}_$condition", // "1_8_Caries"
          photoPanoramaGenerated: photo, // ✅ مهم جداً
        );
      }).toList();
    } else {
      throw Exception(data["message"] ?? "AI detection failed");
    }
  }

  // ============================
  // 🧠 Orthodontic Diagnosis
  // ============================
  Future<Map<String, dynamic>> diagnoseOrtho(File image) async {
    final token = await secureStorage.read(key: 'token');

    final formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
    });

    final response = await ApiClient.dio.post(
      "/diagnose-orthodontics", // ✅ CORRECT ENDPOINT
      data: formData,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final data = response.data;

    if (response.statusCode == 200 && data["status"] == true) {
      return Map<String, dynamic>.from(data["data"]);
      // ✅ contains panorama_photo
    } else {
      throw Exception(data["message"] ?? "Orthodontic diagnosis failed");
    }
  }
}
