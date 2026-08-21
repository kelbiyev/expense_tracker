import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../core/ui_strings.dart';
import '../models/app_notification.dart';

class NotificationRepository {
  Future<List<AppNotification>> loadAll() async {
    final response = await http.get(ApiConfig.notifications());
    return _parseList(response);
  }

  Future<List<AppNotification>> loadUnread() async {
    final response = await http.get(ApiConfig.notificationsUnread());
    return _parseList(response);
  }

  Future<void> markAsRead(int id) async {
    final response = await http.put(ApiConfig.notificationRead(id));
    if (response.statusCode != 200) {
      throw Exception('${UiStrings.error} ${response.statusCode}');
    }
  }

  Future<void> markAllAsRead() async {
    final response = await http.put(ApiConfig.notificationsReadAll());
    if (response.statusCode != 200) {
      throw Exception('${UiStrings.error} ${response.statusCode}');
    }
  }

  List<AppNotification> _parseList(http.Response response) {
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AppNotification.fromJson(json)).toList();
    } else {
      throw Exception('${UiStrings.loadError} ${response.statusCode}');
    }
  }
}