import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class MessageService extends ChangeNotifier {
  // Singleton pattern
  static final MessageService _instance = MessageService._internal();
  factory MessageService() => _instance;
  MessageService._internal();

  final UserService _userService = UserService();
  List<Chat> _chats = [];
  Map<String, List<Message>> _messages = {};
  bool _isLoading = false;

  // Getters
  List<Chat> get chats => _chats;
  bool get isLoading => _isLoading;

  List<Message> getMessages(String chatId) => _messages[chatId] ?? [];

  // Initialize with sample data for development
  void initializeWithSampleData() {
    _chats = Chat.sampleChats();
    _messages = {
      '1': Message.sampleMessages(),
    };
    notifyListeners();
  }

  // Chat Operations
  Future<void> fetchChats() async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      _chats = Chat.sampleChats();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error fetching chats: $e');
      rethrow;
    }
  }

  Future<Chat?> createChat({
    required String name,
    required List<String> participantIds,
    bool isGroup = false,
    String? imageUrl,
  }) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      final chat = Chat(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        participantIds: participantIds,
        isGroup: isGroup,
        imageUrl: imageUrl,
      );

      _chats.add(chat);
      notifyListeners();
      return chat;
    } catch (e) {
      debugPrint('Error creating chat: $e');
      return null;
    }
  }

  Future<bool> updateChat(Chat chat) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _chats.indexWhere((c) => c.id == chat.id);
      if (index != -1) {
        _chats[index] = chat;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating chat: $e');
      return false;
    }
  }

  Future<bool> deleteChat(String chatId) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      _chats.removeWhere((chat) => chat.id == chatId);
      _messages.remove(chatId);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting chat: $e');
      return false;
    }
  }

  // Message Operations
  Future<void> fetchMessages(String chatId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1));
      if (chatId == '1') {
        _messages[chatId] = Message.sampleMessages();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error fetching messages: $e');
      rethrow;
    }
  }

  Future<Message?> sendMessage({
    required String chatId,
    required String content,
    MessageType type = MessageType.text,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      if (_userService.currentUser == null) return null;

      final message = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: _userService.currentUser!.id,
        chatId: chatId,
        content: content,
        type: type,
        timestamp: DateTime.now(),
        status: MessageStatus.sending,
        metadata: metadata,
      );

      // Add message to local state immediately
      if (!_messages.containsKey(chatId)) {
        _messages[chatId] = [];
      }
      _messages[chatId]!.add(message);
      notifyListeners();

      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Update message status
      final index = _messages[chatId]!.indexWhere((m) => m.id == message.id);
      if (index != -1) {
        _messages[chatId]![index] = message.copyWith(
          status: MessageStatus.sent,
        );
      }

      // Update chat's last message
      final chatIndex = _chats.indexWhere((c) => c.id == chatId);
      if (chatIndex != -1) {
        _chats[chatIndex] = _chats[chatIndex].copyWith(
          lastMessage: content,
          lastMessageTime: DateTime.now(),
        );
      }

      notifyListeners();
      return message;
    } catch (e) {
      debugPrint('Error sending message: $e');
      return null;
    }
  }

  Future<bool> deleteMessage(String chatId, String messageId) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      if (_messages.containsKey(chatId)) {
        _messages[chatId]!.removeWhere((message) => message.id == messageId);
        notifyListeners();
      }
      return true;
    } catch (e) {
      debugPrint('Error deleting message: $e');
      return false;
    }
  }

  // Typing Indicators
  Future<void> setTypingStatus(String chatId, bool isTyping) async {
    try {
      if (_userService.currentUser == null) return;

      // TODO: Implement actual API call
      final index = _chats.indexWhere((c) => c.id == chatId);
      if (index != -1) {
        _chats[index] = _chats[index].copyWith(
          isTyping: isTyping,
          typingUserId: isTyping ? _userService.currentUser!.id : null,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error setting typing status: $e');
    }
  }

  // Read Status
  Future<void> markMessageAsRead(String chatId, String messageId) async {
    try {
      if (_userService.currentUser == null) return;

      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      if (_messages.containsKey(chatId)) {
        final index = _messages[chatId]!.indexWhere((m) => m.id == messageId);
        if (index != -1) {
          final message = _messages[chatId]![index];
          if (!message.readBy.contains(_userService.currentUser!.id)) {
            _messages[chatId]![index] = message.copyWith(
              status: MessageStatus.read,
              readBy: [...message.readBy, _userService.currentUser!.id],
            );
            notifyListeners();
          }
        }
      }
    } catch (e) {
      debugPrint('Error marking message as read: $e');
    }
  }

  Future<void> markChatAsRead(String chatId) async {
    try {
      if (_userService.currentUser == null) return;

      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      if (_messages.containsKey(chatId)) {
        final userId = _userService.currentUser!.id;
        _messages[chatId] = _messages[chatId]!.map((message) {
          if (!message.readBy.contains(userId)) {
            return message.copyWith(
              status: MessageStatus.read,
              readBy: [...message.readBy, userId],
            );
          }
          return message;
        }).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error marking chat as read: $e');
    }
  }
}
