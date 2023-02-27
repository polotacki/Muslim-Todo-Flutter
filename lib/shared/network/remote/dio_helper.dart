import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: 'http://api.aladhan.com/',
      receiveDataWhenStatusError: true,
    ));
  }

  static Future<Response> getData({
    required String url,
    required Map<String, dynamic> query,
  }) async {
    print(query);
    return await dio!.get(
      url,
      queryParameters: query,
    );
  }
}
//v1/timingsByCity?city=Cairo&country=Egypt&method=5
