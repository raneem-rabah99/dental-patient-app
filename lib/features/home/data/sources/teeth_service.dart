import 'package:dentaltreatment/features/home/data/models/teeth_response.dart';
import 'package:dentaltreatment/features/home/data/models/tooth_detection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/full_tooth_result.dart';

class TeethService {
  final Dio dio;
  final FlutterSecureStorage storage;

  TeethService(this.dio, this.storage);

  // ✅ موجود – لا نلمسه
  Future<List<ToothDetection>> getTeeth() async {
    final token = await storage.read(key: 'token');

    final response = await dio.get(
      '/customer/teeth',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data;

    if (data['status'] == true) {
      final List teeth = data['data']['teeth'];
      return teeth.map((e) => ToothDetection.fromApi(e)).toList();
    } else {
      throw Exception(data['message']);
    }
  }

  // 🆕 جديد – للـ Show Full Result فقط
  Future<List<FullToothResult>> getFullTeeth() async {
    final token = await storage.read(key: 'token');

    final response = await dio.get(
      '/customer/teeth',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data;

    if (data['status'] == true) {
      final List teeth = data['data']['teeth'];
      return teeth.map((e) => FullToothResult.fromApi(e)).toList();
    } else {
      throw Exception(data['message']);
    }
  }

  Future<TeethApiResult> getFullTeethResult() async {
    final token = await storage.read(key: 'token');

    final response = await dio.get(
      '/customer/teeth',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data;

    if (data['status'] == true) {
      return TeethApiResult.fromApi(data['data']);
    } else {
      throw Exception(data['message']);
    }
  }
}
