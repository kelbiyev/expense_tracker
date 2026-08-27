import 'package:dio/dio.dart';

import '../core/config/dio_client.dart';
import '../models/notification_model.dart';
import 'api_endpoints.dart';

class NotificationService {
  final Dio _dio;

  NotificationService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  Future<List<NotificationModel>> getAll() async {
    final response = await _dio.get(ApiEndpoints.notifications);
    return _parseList(response);
  }

  Future<List<NotificationModel>> getUnread() async {
    final response = await _dio.get(ApiEndpoints.notificationsUnread);
    return _parseList(response);
  }

  Future<void> markAsRead(int id) async {
    await _dio.put(ApiEndpoints.notificationRead(id));
  }

  Future<void> markAllAsRead() async {
    await _dio.put(ApiEndpoints.notificationsReadAll);
  }

  List<NotificationModel> _parseList(Response response) {
    final data = response.data as List? ?? const [];
    return data.map((json) => NotificationModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}