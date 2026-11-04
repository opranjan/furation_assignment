import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import 'api_exception.dart';
import 'api_interceptor.dart';

/// HTTP client. Screens still read local data; call this once a backend exists.
class ApiService {
  ApiService({Dio? dio, String? baseUrl, TokenReader? readToken})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl ?? AppConstants.apiBaseUrl,
              connectTimeout: AppConstants.apiTimeout,
              receiveTimeout: AppConstants.apiTimeout,
              sendTimeout: AppConstants.apiTimeout,
              headers: {Headers.acceptHeader: Headers.jsonContentType},
            ),
          ) {
    _dio.interceptors.addAll([
      AuthInterceptor(readToken: readToken),
      AppLogInterceptor(),
      ErrorInterceptor(),
    ]);
  }

  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _send(
      () => _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: _options(options, headers: headers),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _send(
      () => _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _options(
          options,
          headers: headers,
          contentType: Headers.jsonContentType,
        ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _send(
      () => _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _options(
          options,
          headers: headers,
          contentType: Headers.jsonContentType,
        ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _send(
      () => _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _options(
          options,
          headers: headers,
          contentType: Headers.jsonContentType,
        ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _send(
      () => _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _options(options, headers: headers),
        cancelToken: cancelToken,
      ),
    );
  }

  /// Sends form fields and files. [method] is POST unless you pass PUT or PATCH.
  Future<Response<T>> multipart<T>(
    String path, {
    String method = 'POST',
    Map<String, dynamic>? fields,
    Map<String, MultipartFile>? files,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _send(
      () => _dio.request<T>(
        path,
        data: _formData(fields: fields, files: files),
        queryParameters: queryParameters,
        options: _options(
          options,
          headers: headers,
          method: method,
          contentType: Headers.multipartFormDataContentType,
        ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  Future<Response<T>> postMultipart<T>(
    String path, {
    Map<String, dynamic>? fields,
    Map<String, MultipartFile>? files,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return multipart<T>(
      path,
      fields: fields,
      files: files,
      queryParameters: queryParameters,
      headers: headers,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> putMultipart<T>(
    String path, {
    Map<String, dynamic>? fields,
    Map<String, MultipartFile>? files,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return multipart<T>(
      path,
      method: 'PUT',
      fields: fields,
      files: files,
      queryParameters: queryParameters,
      headers: headers,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> patchMultipart<T>(
    String path, {
    Map<String, dynamic>? fields,
    Map<String, MultipartFile>? files,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return multipart<T>(
      path,
      method: 'PATCH',
      fields: fields,
      files: files,
      queryParameters: queryParameters,
      headers: headers,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<MultipartFile> fileFromPath(String path, {String? filename}) {
    return MultipartFile.fromFile(path, filename: filename);
  }

  MultipartFile fileFromBytes(List<int> bytes, {required String filename}) {
    return MultipartFile.fromBytes(bytes, filename: filename);
  }

  Future<Response<T>> _send<T>(Future<Response<T>> Function() request) async {
    try {
      return await request();
    } on DioException catch (error) {
      final mapped = error.error;
      if (mapped is ApiException) throw mapped;
      throw ApiException.fromDio(error);
    }
  }

  FormData _formData({
    Map<String, dynamic>? fields,
    Map<String, MultipartFile>? files,
  }) {
    return FormData.fromMap({...?fields, ...?files});
  }

  Options _options(
    Options? options, {
    Map<String, dynamic>? headers,
    String? method,
    String? contentType,
  }) {
    return (options ?? Options()).copyWith(
      method: method,
      contentType: contentType,
      headers: {...?options?.headers, ...?headers},
    );
  }
}
