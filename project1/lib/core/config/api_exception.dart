import 'package:dio/dio.dart';

import '../constants/ui_strings.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  factory ApiException.fromDio(DioException e) {

    if (e.type == DioExceptionType.connectionTimeout ||// server responsu timed out
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const ApiException(UiStrings.connectionTimeout);
    }

    if (e.type == DioExceptionType.connectionError) {//no internet erroru
      return const ApiException(UiStrings.noInternet);
    }

    if (e.type == DioExceptionType.cancel) {//request ləğv edildi
      return const ApiException(UiStrings.cancelled);
    }

    
    if (e.type == DioExceptionType.badResponse) {//serverin cavabı amma error code ilə
      final code = e.response?.statusCode;
      return ApiException(_messageForStatus(code), statusCode: code);
    }

    // 5) Остальные случаи
    return const ApiException(UiStrings.unexpected);
  }

  static String _messageForStatus(int? code) {
    if (code == 400) return UiStrings.badRequest;
    if (code == 404) return UiStrings.notFound;
    if (code == 422) return UiStrings.validationError;
    if (code != null && code >= 500) return UiStrings.serverError;
    return UiStrings.generic;
  }

  @override
  String toString() => message;
}