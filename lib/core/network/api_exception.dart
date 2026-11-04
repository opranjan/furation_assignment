import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException({required this.message, this.statusCode, this.data});

  final String message;
  final int? statusCode;
  final Object? data;

  factory ApiException.fromDio(DioException error) {
    final data = error.response?.data;
    return ApiException(
      message: _message(error, data),
      statusCode: error.response?.statusCode,
      data: data,
    );
  }

  static String _message(DioException error, Object? data) {
    if (data is Map) {
      final value = data['message'] ?? data['error'];
      if (value is String && value.isNotEmpty) return value;
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => 'The request timed out.',
      DioExceptionType.connectionError => 'No internet connection.',
      DioExceptionType.cancel => 'The request was cancelled.',
      DioExceptionType.badCertificate =>
        'The server certificate is not trusted.',
      _ =>
        error.message?.trim().isNotEmpty == true
            ? error.message!
            : 'Something went wrong.',
    };
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
