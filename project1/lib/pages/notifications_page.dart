import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_notification.dart';
import '../providers/notification_provider.dart';

import '../core/constants/ui_colors.dart';
import '../core/constants/ui_strings.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final notifications = provider.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text(UiStrings.notifications),
        actions: [
          if (provider.unreadCount > 0)
            TextButton(
              onPressed: () => context.read<NotificationProvider>().markAllAsRead(),
              child: const Text(UiStrings.markAllRead),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(UiStrings.noNotifications, style: TextStyle(color: UiColors.grey)),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _NotificationTile(notification: notifications[index]);
              },
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        notification.read ? Icons.notifications_none : Icons.notifications_active,
        color: notification.read ? UiColors.grey : UiColors.primary,
      ),
      title: Text(
        notification.message,
        style: TextStyle(fontWeight: notification.read ? FontWeight.normal : FontWeight.bold),
      ),
      subtitle: Text(
        '${notification.createdAt.day}/${notification.createdAt.month}/${notification.createdAt.year}',
      ),
      onTap: notification.read
          ? null
          : () => context.read<NotificationProvider>().markAsRead(notification.id),
    );
  }
}