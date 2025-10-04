import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../features/auth/data/datasource/auth_local.dart';
import '../../injection/injection.dart';

class DioClient {
  final Dio _dio;
  final AuthLocal _authLocal;

  DioClient({
    required Dio dio,
    required AuthLocal authLocal,
  })  : _dio = dio,
        _authLocal = authLocal {
    // Global interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _authLocal.getAuthToken();
          if (token != null) {
            log('📡 Adding Authorization header');
            options.headers['Authorization'] = 'Bearer $token';
          }
          log('➡️ Request: [${options.method}] ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('✅ Response [${response.statusCode}]: ${response.requestOptions.uri}');
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          log('❌ Dio Error: ${e.message} [${e.response?.statusCode}]');

          if (e.response?.statusCode == 401) {
            log('⚠️ Unauthorized! Consider refreshing token here.');
          }

          // Optional: handle network timeout
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout) {
            log('⏱ Request timed out');
          }

          return handler.next(e);
        },
      ),
    );

    // Default Dio configuration
    _dio.options
      ..baseUrl = 'https://your-api-base-url.com' // replace with your API
      ..connectTimeout = const Duration(seconds: 15)
      ..receiveTimeout = const Duration(seconds: 15)
      ..headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
  }

  // ----------------------
  // HTTP METHODS
  // ----------------------

  Future<Response> get({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.get(url, queryParameters: queryParameters);

  Future<Response> post({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.post(url, data: data, queryParameters: queryParameters);

  Future<Response> put({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.put(url, data: data, queryParameters: queryParameters);

  Future<Response> delete({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.delete(url, queryParameters: queryParameters);
}
