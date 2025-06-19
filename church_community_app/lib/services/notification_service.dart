import 'dart:async';
import '../models/notification_model.dart';

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // In-memory storage
  final List<ChurchNotification> _notifications = ChurchNotification.getSampleNotifications();
  
  // Stream controller for notifications
  final _notificationsController = StreamController<List<ChurchNotification>>.broadcast();

  // Get stream of notifications
  Stream<List<ChurchNotification>> get notificationsStream => _notificationsController.stream;

  // Get all notifications
  List<ChurchNotification> getAllNotifications() {
    return List.unmodifiable(_notifications);
  }

  // Get unread notifications
  List<ChurchNotification> getUnreadNotifications() {
    return _notifications.where((notification) => !notification.isRead).toList();
  }

  // Get notifications by type
  List<ChurchNotification> getNotificationsByType(NotificationType type) {
    return _notifications.where((notification) => notification.type == type).toList();
  }

  // Add new notification
  void addNotification(ChurchNotification notification) {
    _notifications.insert(0, notification);
    _notifyListeners();
  }

  // Mark notification as read
  void markAsRead(String id) {
    final index = _notifications.indexWhere((notification) => notification.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _notifyListeners();
    }
  }

  // Mark all notifications as read
  void markAllAsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    _notifyListeners();
  }

  // Delete notification
  void deleteNotification(String id) {
    _notifications.removeWhere((notification) => notification.id == id);
    _notifyListeners();
  }

  // Delete all notifications
  void deleteAllNotifications() {
    _notifications.clear();
    _notifyListeners();
  }

  // Get notification count
  int getUnreadCount() {
    return _notifications.where((notification) => !notification.isRead).length;
  }

  // Search notifications
  List<ChurchNotification> searchNotifications(String query) {
    query = query.toLowerCase();
    return _notifications.where((notification) {
      return notification.title.toLowerCase().contains(query) ||
             notification.message.toLowerCase().contains(query);
    }).toList();
  }

  // Get notifications by date range
  List<ChurchNotification> getNotificationsByDateRange(DateTime start, DateTime end) {
    return _notifications
        .where((notification) => 
            notification.timestamp.isAfter(start.subtract(const Duration(days: 1))) && 
            notification.timestamp.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }

  // Group notifications by date
  Map<DateTime, List<ChurchNotification>> getNotificationsGroupedByDate() {
    final groupedNotifications = <DateTime, List<ChurchNotification>>{};
    
    for (var notification in _notifications) {
      final date = DateTime(
        notification.timestamp.year,
        notification.timestamp.month,
        notification.timestamp.day,
      );
      
      if (!groupedNotifications.containsKey(date)) {
        groupedNotifications[date] = [];
      }
      
      groupedNotifications[date]!.add(notification);
    }
    
    return groupedNotifications;
  }

  // Notify listeners of changes
  void _notifyListeners() {
    _notificationsController.add(List.unmodifiable(_notifications));
  }

  // Dispose
  void dispose() {
    _notificationsController.close();
  }

  // Create a new notification
  ChurchNotification createNotification({
    required String title,
    required String message,
    required NotificationType type,
    String? relatedId,
  }) {
    final notification = ChurchNotification(
      id: DateTime.now().toString(),
      title: title,
      message: message,
      timestamp: DateTime.now(),
      type: type,
      relatedId: relatedId,
      isRead: false,
    );
    
    addNotification(notification);
    return notification;
  }

  // Handle notification tap
  void handleNotificationTap(ChurchNotification notification) {
    markAsRead(notification.id);
    // Additional handling based on notification type can be added here
  }
}
