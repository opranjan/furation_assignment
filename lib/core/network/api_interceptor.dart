import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_exception.dart';

typedef TokenReader = Future<String?> Function();

/// Adds a bearer token when [readToken] returns one.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({this.readToken});

  final TokenReader? readToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final reader = readToken;
    if (reader == null) {
      handler.next(options);
      return;
    }

    reader()
        .then((token) {
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        })
        .catchError((Object error, StackTrace stackTrace) {
          handler.reject(
            DioException(
              requestOptions: options,
              error: error,
              stackTrace: stackTrace,
              type: DioExceptionType.unknown,
            ),
          );
        });
  }
}

/// Prints the method, url, and status while the app is in debug mode.
class AppLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[API] -> ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '[API] <- ${response.statusCode} ${response.requestOptions.uri}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '[API] xx ${err.response?.statusCode ?? err.type.name} ${err.requestOptions.uri}',
      );
    }
    handler.next(err);
  }
}

/// Turns a [DioException] into [ApiException] before it leaves the client.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: ApiException.fromDio(err),
        message: err.message,
      ),
    );
  }
}
