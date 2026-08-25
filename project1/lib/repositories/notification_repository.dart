import 'package:dio/dio.dart';
import '../core/api_config.dart';
import '../core/dio_client.dart';
import '../core/constants/ui_strings.dart';
import '../models/app_notification.dart';

class NotificationRepository {
  final Dio _dio = DioClient.instance;

  Future<List<AppNotification>> loadAll() async {
    final response = await _get(ApiConfig.notifications());
    return _parseList(response);
  }

  Future<List<AppNotification>> loadUnread() async {
    final response = await _get(ApiConfig.notificationsUnread());
    return _parseList(response);
  }

  Future<void> markAsRead(int id) async {
    try {
      await _dio.put(ApiConfig.notificationRead(id));
    } on DioException catch (e) {
      throw Exception('${UiStrings.error} ${e.response?.statusCode ?? e.message}');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _dio.put(ApiConfig.notificationsReadAll());
    } on DioException catch (e) {
      throw Exception('${UiStrings.error} ${e.response?.statusCode ?? e.message}');
    }
  }

  Future<Response> _get(String path) async {
    try {
      return await _dio.get(path);
    } on DioException catch (e) {
      throw Exception('${UiStrings.loadError} ${e.response?.statusCode ?? e.message}');
    }
  }

  List<AppNotification> _parseList(Response response) {
    final List<dynamic> data = response.data;
    return data.map((json) => AppNotification.fromJson(json)).toList();
  }
}