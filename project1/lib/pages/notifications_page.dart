import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/notification_model.dart';
import '../providers/notification_provider.dart';

import '../core/constants/ui_colors.dart';
import '../core/constants/ui_strings.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

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
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, NotificationProvider provider) {
    if (provider.isLoading && provider.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(provider.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: provider.load, child: const Text(UiStrings.retry)),
            ],
          ),
        ),
      );
    }

    return provider.notifications.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(UiStrings.noNotifications, style: TextStyle(color: UiColors.grey)),
            ),
          )
        : ListView.builder(
            itemCount: provider.notifications.length,
            itemBuilder: (context, index) {
              return _NotificationTile(notification: provider.notifications[index]);
            },
          );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  const _NotificationTile({required this.notification});

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