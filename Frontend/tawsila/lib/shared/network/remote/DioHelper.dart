import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init()
  {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://app-tawsila-api-prod-eastus-001.azurewebsites.net/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    // Map<String, dynamic>? query,
    // String lang = 'en',
    // String token = '',
  }) async
  {
    // dio.options.headers =
    // {
    //   'lang':lang,
    //   'Authorization': token,
    //   'Content-Type': 'application/json',
    // };

    return await dio.get(
      url,
      // queryParameters: query??{},
    );
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    // Map<String, dynamic>? query,
    // String lang = 'en',
    // String token = '',
  }) async
  {
    // dio.options.headers =
    // {
    //   'lang':'en',
    //   'Authorization': token,
    //   'Content-Type': 'application/json',
    // };

    return dio.post(
      url,
      data: data,
    );
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    // Map<String, dynamic>? query,
    // String lang = 'en',
    // String token = '',
  }) async
  {
    // dio.options.headers =
    // {
    //   'lang':lang,
    //   'Authorization': token,
    //   'Content-Type': 'application/json',
    // };

    return dio.put(
      url,
      // queryParameters: query??{},
      data: data,
    );
  }
}