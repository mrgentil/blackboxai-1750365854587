import 'package:flutter/material.dart';
import '../../models/notification_model.dart';
import '../../services/notification_service.dart';
import '../../utils/constants.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({Key? key}) : super(key: key);

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  final NotificationService _notificationService = NotificationService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      await _notificationService.fetchNotifications();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleMarkAllAsRead() async {
    final success = await _notificationService.markAllAsRead();
    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Toutes les notifications ont été marquées comme lues'),
          backgroundColor: Constants.successColor,
        ),
      );
    }
  }

  Future<void> _handleDelete(ChurchNotification notification) async {
    final success = await _notificationService.deleteNotification(notification.id);
    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification supprimée'),
          backgroundColor: Constants.successColor,
        ),
      );
    }
  }

  void _handleNotificationTap(ChurchNotification notification) {
    _notificationService.markAsRead(notification.id);
    if (notification.actionRoute != null) {
      // TODO: Implement navigation based on actionRoute and actionParams
      debugPrint('Navigate to: ${notification.actionRoute}');
    }
  }

  Widget _buildNotificationTile(ChurchNotification notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Constants.defaultPadding),
        color: Constants.errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) => _handleDelete(notification),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Constants.defaultPadding,
          vertical: Constants.smallPadding,
        ),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: notification.typeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            notification.typeIcon,
            color: notification.typeColor,
            size: 24,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Constants.textColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              notification.formattedTime,
              style: TextStyle(
                fontSize: 12,
                color: Constants.textColor.withOpacity(0.6),
              ),
            ),
          ],
        ),
        trailing: notification.isRead
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: notification.typeColor,
                ),
              ),
        onTap: () => _handleNotificationTap(notification),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifications = _notificationService.notifications;
    final hasUnread = notifications.any((n) => !n.isRead);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (hasUnread)
            TextButton(
              onPressed: _handleMarkAllAsRead,
              child: Text(
                'Tout marquer comme lu',
                style: TextStyle(
                  color: Constants.primaryColor,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadNotifications,
              child: notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off,
                            size: 64,
                            color: Constants.subtitleColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aucune notification',
                            style: Constants.subtitleStyle,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        vertical: Constants.smallPadding,
                      ),
                      itemCount: notifications.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        indent: 88,
                      ),
                      itemBuilder: (context, index) =>
                          _buildNotificationTile(notifications[index]),
                    ),
            ),
    );
  }
}
