import 'package:flutter/foundation.dart';
import '../models/app_notification.dart';
import '../repositories/notification_repository.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _repository;
  List<AppNotification> _notifications = [];

  NotificationProvider(this._repository);

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.read).length;

  Future<void> load() async {
    _notifications = await _repository.loadAll();
    notifyListeners();
  }

  Future<void> markAsRead(int id) async {
    await _repository.markAsRead(id);

    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = AppNotification(
        id: _notifications[index].id,
        message: _notifications[index].message,
        createdAt: _notifications[index].createdAt,
        read: true,
      );
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    await _repository.markAllAsRead();
    await load(); 
  }
}