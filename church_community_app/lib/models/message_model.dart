import 'package:flutter/material.dart';

enum MessageType {
  text,
  image,
  file,
  audio,
  video,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

class Message {
  final String id;
  final String senderId;
  final String chatId;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final MessageStatus status;
  final List<String> readBy;
  final Map<String, dynamic>? metadata;

  Message({
    required this.id,
    required this.senderId,
    required this.chatId,
    required this.content,
    required this.type,
    required this.timestamp,
    this.status = MessageStatus.sent,
    List<String>? readBy,
    this.metadata,
  }) : readBy = readBy ?? [];

  bool get isRead => status == MessageStatus.read;
  bool get isDelivered => status == MessageStatus.delivered;
  bool get isSent => status == MessageStatus.sent;
  bool get isSending => status == MessageStatus.sending;
  bool get isFailed => status == MessageStatus.failed;

  String get formattedTime {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    if (messageDate == today) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      return 'Hier';
    } else if (now.difference(timestamp).inDays < 7) {
      final weekdays = [
        'Lundi',
        'Mardi',
        'Mercredi',
        'Jeudi',
        'Vendredi',
        'Samedi',
        'Dimanche'
      ];
      return weekdays[timestamp.weekday - 1];
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  Message copyWith({
    String? id,
    String? senderId,
    String? chatId,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    MessageStatus? status,
    List<String>? readBy,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      chatId: chatId ?? this.chatId,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      readBy: readBy ?? List.from(this.readBy),
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'chatId': chatId,
      'content': content,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'status': status.toString(),
      'readBy': readBy,
      'metadata': metadata,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['senderId'],
      chatId: json['chatId'],
      content: json['content'],
      type: MessageType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => MessageType.text,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      status: MessageStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      readBy: List<String>.from(json['readBy'] ?? []),
      metadata: json['metadata'],
    );
  }

  // Sample messages for development
  static List<Message> sampleMessages() {
    return [
      Message(
        id: '1',
        senderId: '2',
        chatId: '1',
        content: 'Bonjour ! Comment allez-vous ?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      ),
      Message(
        id: '2',
        senderId: '1',
        chatId: '1',
        content: 'Très bien, merci ! Et vous ?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      ),
      Message(
        id: '3',
        senderId: '2',
        chatId: '1',
        content: 'Je vais bien aussi. Serez-vous présent au culte dimanche ?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Message(
        id: '4',
        senderId: '1',
        chatId: '1',
        content: 'Oui, bien sûr ! À dimanche !',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
  }
}

class Chat {
  final String id;
  final String name;
  final String? imageUrl;
  final List<String> participantIds;
  final bool isGroup;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final bool isTyping;
  final String? typingUserId;

  Chat({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.participantIds,
    this.isGroup = false,
    this.lastMessage,
    this.lastMessageTime,
    this.isTyping = false,
    this.typingUserId,
  });

  Chat copyWith({
    String? name,
    String? imageUrl,
    List<String>? participantIds,
    bool? isGroup,
    String? lastMessage,
    DateTime? lastMessageTime,
    bool? isTyping,
    String? typingUserId,
  }) {
    return Chat(
      id: id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      participantIds: participantIds ?? List.from(this.participantIds),
      isGroup: isGroup ?? this.isGroup,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      isTyping: isTyping ?? this.isTyping,
      typingUserId: typingUserId ?? this.typingUserId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'participantIds': participantIds,
      'isGroup': isGroup,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'isTyping': isTyping,
      'typingUserId': typingUserId,
    };
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      participantIds: List<String>.from(json['participantIds']),
      isGroup: json['isGroup'] ?? false,
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.parse(json['lastMessageTime'])
          : null,
      isTyping: json['isTyping'] ?? false,
      typingUserId: json['typingUserId'],
    );
  }

  // Sample chats for development
  static List<Chat> sampleChats() {
    return [
      Chat(
        id: '1',
        name: 'Groupe des jeunes',
        imageUrl: null,
        participantIds: ['1', '2', '3', '4'],
        isGroup: true,
        lastMessage: 'À dimanche !',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      Chat(
        id: '2',
        name: 'Pasteur David',
        imageUrl: null,
        participantIds: ['1', '5'],
        isGroup: false,
        lastMessage: 'Merci pour votre message',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }
}
