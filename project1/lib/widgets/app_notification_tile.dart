import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/notification_model.dart';
import '../providers/notification_provider.dart';

import '../core/constants/ui_colors.dart';

class AppNotificationTile extends StatelessWidget {
  const AppNotificationTile({super.key, required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        notification.isRead ? Icons.notifications_none : Icons.notifications_active,
        color: notification.isRead ? UiColors.grey : UiColors.primary,
      ),
      title: Text(
        notification.message,
        style: TextStyle(fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold),
      ),
      subtitle: Text(
        '${notification.createdAt.day}/${notification.createdAt.month}/${notification.createdAt.year}',
      ),
      onTap: notification.isRead
          ? null
          : () => context.read<NotificationProvider>().markAsRead(notification.id),
    );
  }
}