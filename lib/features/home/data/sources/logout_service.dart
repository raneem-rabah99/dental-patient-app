import 'package:dentaltreatment/core/api/base_url.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class LogoutService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> logout() async {
    final token = await storage.read(key: "token");

    await ApiClient.dio.post(
      "/logout",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    // Remove token locally
    await storage.delete(key: "token");
  }
}
