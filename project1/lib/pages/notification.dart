import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';

import '../core/constants/ui_strings.dart';

import '../widgets/app_error_view.dart';
import '../widgets/app_empty_view.dart';
import '../widgets/app_notification_tile.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

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
      return AppErrorView(message: provider.errorMessage!, onRetry: provider.load);
    }

    if (provider.notifications.isEmpty) {
      return const AppEmptyView(message: UiStrings.noNotifications);
    }

    return ListView.builder(
      itemCount: provider.notifications.length,
      itemBuilder: (context, index) {
        return AppNotificationTile(notification: provider.notifications[index]);
      },
    );
  }
}