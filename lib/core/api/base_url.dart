import 'package:dio/dio.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://46.224.222.138/api",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      validateStatus: (status) {
        // Allow Dio to return the response even if it's 400
        return status != null && status < 500;
      },
    ),
  );
}
