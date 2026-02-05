import 'package:dentaltreatment/core/api/base_url.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/customer_info_model.dart';

class CustomerInfoService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> uploadInfo(CustomerInfoModel model) async {
    try {
      final token = await _secureStorage.read(key: 'token');

      if (token != null && token.isNotEmpty) {
        ApiClient.dio.options.headers["Authorization"] = "Bearer $token";
      }

      final formData = FormData.fromMap({
        "birthdate": model.birthdate,
        if (model.patientRecordFile != null)
          "patient_record": await MultipartFile.fromFile(
            model.patientRecordFile!.path,
            filename: model.patientRecordFile!.path.split('/').last,
          )
        else if (model.patientRecordText != null)
          "patient_record_text": model.patientRecordText,
      });

      final response = await ApiClient.dio.post(
        "/customer/info",
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Unexpected server response: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception("Unauthenticated. Please log in again.");
      }
      throw Exception(e.response?.data['message'] ?? "Failed to update info");
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
