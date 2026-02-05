import 'package:dentaltreatment/core/api/base_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dentaltreatment/features/home/data/models/favorite_case_model.dart';

class FavoriteCaseService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<FavoriteCaseModel>> getFavoriteCases() async {
    try {
      String? token = await _storage.read(key: "token");

      final response = await ApiClient.dio.get(
        "/customer/favorite-cases",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.data["status"] == true) {
        List data = response.data["data"];
        return data.map((e) => FavoriteCaseModel.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      print("FavoriteCaseService ERROR: $e");
      return [];
    }
  }
}
