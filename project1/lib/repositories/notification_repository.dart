import 'package:dio/dio.dart';
import '../services/api_endpoints.dart';
import '../core/config/dio_client.dart';
import '../core/constants/ui_strings.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final Dio _dio = DioClient.instance;

  Future<List<NotificationModel>> loadAll() async {
    final response = await _get(ApiEndpoints.notifications);
    return _parseList(response);
  }

  Future<List<NotificationModel>> loadUnread() async {
    final response = await _get(ApiEndpoints.notificationsUnread);
    return _parseList(response);
  }

  Future<void> markAsRead(int id) async {
    try {
      await _dio.put(ApiEndpoints.notificationRead(id));
    } on DioException catch (e) {
      throw Exception('${UiStrings.error} ${e.response?.statusCode ?? e.message}');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _dio.put(ApiEndpoints.notificationsReadAll);
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

  List<NotificationModel> _parseList(Response response) {
    final data = response.data as List? ?? const [];
    return data.map((json) => NotificationModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}