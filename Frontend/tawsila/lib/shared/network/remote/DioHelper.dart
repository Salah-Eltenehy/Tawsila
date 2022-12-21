import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init()
  {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://app-tawsila-api-prod-eastus-001.azurewebsites.net',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    required Map<String, dynamic> query
  }) async
  {
    return await dio.get(
      url,
      queryParameters: query
    );
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
  }) async
  {
    return dio.post(
      url,
      data: data,
    );
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
  }) async
  {
    return dio.put(
      url,
      data: data,
    );
  }
}