import 'package:flutter/material.dart';

enum NotificationType {
  event,
  message,
  announcement,
  prayer,
  reminder,
  other,
}

class ChurchNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;
  final Map<String, dynamic>? data;
  final String? actionRoute;
  final Map<String, dynamic>? actionParams;

  ChurchNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
    this.data,
    this.actionRoute,
    this.actionParams,
  });

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  IconData get typeIcon {
    switch (type) {
      case NotificationType.event:
        return Icons.event;
      case NotificationType.message:
        return Icons.message;
      case NotificationType.announcement:
        return Icons.campaign;
      case NotificationType.prayer:
        return Icons.emoji_people;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.other:
        return Icons.notifications;
    }
  }

  Color get typeColor {
    switch (type) {
      case NotificationType.event:
        return Colors.purple;
      case NotificationType.message:
        return Colors.blue;
      case NotificationType.announcement:
        return Colors.orange;
      case NotificationType.prayer:
        return Colors.green;
      case NotificationType.reminder:
        return Colors.red;
      case NotificationType.other:
        return Colors.grey;
    }
  }

  ChurchNotification copyWith({
    String? title,
    String? body,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? imageUrl,
    Map<String, dynamic>? data,
    String? actionRoute,
    Map<String, dynamic>? actionParams,
  }) {
    return ChurchNotification(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
      data: data ?? this.data,
      actionRoute: actionRoute ?? this.actionRoute,
      actionParams: actionParams ?? this.actionParams,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'imageUrl': imageUrl,
      'data': data,
      'actionRoute': actionRoute,
      'actionParams': actionParams,
    };
  }

  factory ChurchNotification.fromJson(Map<String, dynamic> json) {
    return ChurchNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => NotificationType.other,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      imageUrl: json['imageUrl'],
      data: json['data'],
      actionRoute: json['actionRoute'],
      actionParams: json['actionParams'],
    );
  }

  // Sample notifications for development
  static List<ChurchNotification> sampleNotifications() {
    return [
      ChurchNotification(
        id: '1',
        title: 'Nouveau culte dominical',
        body: 'Le culte de ce dimanche aura pour thème "La grâce de Dieu"',
        type: NotificationType.event,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        actionRoute: '/events/1',
      ),
      ChurchNotification(
        id: '2',
        title: 'Nouveau message',
        body: 'Le pasteur David vous a envoyé un message',
        type: NotificationType.message,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        actionRoute: '/chats/2',
      ),
      ChurchNotification(
        id: '3',
        title: 'Annonce importante',
        body: 'La réunion de prière de ce soir est reportée à 19h30',
        type: NotificationType.announcement,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ChurchNotification(
        id: '4',
        title: 'Intention de prière',
        body: 'Marie demande la prière pour sa famille',
        type: NotificationType.prayer,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}
