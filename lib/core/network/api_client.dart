import 'package:dio/dio.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio _dio;
  final String baseUrl = 'https://petstore3.swagger.io/api/v3';

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    _dio = Dio();
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.options.headers = {'Content-Type': 'application/json'};
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    String errorMessage = 'An error occurred. Please try again later.';

    if (error.response != null) {
      if (error.response!.data != null && error.response!.data is Map) {
        errorMessage = error.response!.data['message'] ?? errorMessage;
      }
      return Exception('Error ${error.response!.statusCode}: $errorMessage');
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return Exception(
        'Connection timeout. Please check your internet connection.',
      );
    }

    if (error.type == DioExceptionType.unknown &&
        error.error != null &&
        error.error.toString().contains('SocketException')) {
      return Exception('No internet connection. Please check your network.');
    }

    return Exception(errorMessage);
  }
}
