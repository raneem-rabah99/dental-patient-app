import 'package:dio/dio.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://32c5d278e58a.ngrok-free.app/api",
      connectTimeout: Duration(seconds: 150),
      receiveTimeout: Duration(seconds: 150),
      headers: {"Accept": "application/json"},
    ),
  );
}
