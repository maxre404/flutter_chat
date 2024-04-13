import 'package:dio/dio.dart';
import 'package:flutter_chat/http/Api.dart';

class ApiService {
  final Dio _dio = Dio();
  ApiService() {
    _dio.options.baseUrl = baseApi; // 设置baseUrl
  }
  // 封装GET请求
  Future<dynamic> get(String url) async {
    try {
      Response response = await _dio.get(url);
      return response.data;
    } catch (error) {
      print('GET request error: $error');
      throw error;
    }
  }

  // 封装POST请求
  Future<dynamic> post(String url, dynamic data) async {
    try {
      Response response = await _dio.post(url, data: data);
      return response.data;
    } catch (error) {
      print('POST request error: $error');
      throw error;
    }
  }

  // 更多封装方法，如PUT、DELETE等

}
