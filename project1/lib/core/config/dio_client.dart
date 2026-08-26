import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../services/api_endpoints.dart';
import 'api_exception.dart';

class DioClient {
  DioClient._();

  static final Dio instance = _create();

  static Dio _create() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 6),
        receiveTimeout: const Duration(seconds: 12),
        headers: const {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      ),
    );
    
    if (kDebugMode) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            debugPrint('→ ${options.method} ${options.uri}');
            handler.next(options);
          },
          onResponse: (response, handler) {
            debugPrint('← ${response.statusCode} ${response.requestOptions.uri}');
            handler.next(response);
          },
          onError: (error, handler) {
            debugPrint('✕ ${error.requestOptions.uri}: ${error.message}');
            handler.next(error);
          },
        ),
      );
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: ApiException.fromDio(error),
            ),
          );
        },
      ),
    );

    return dio;
  }
}