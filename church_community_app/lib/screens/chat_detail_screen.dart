import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/message_service.dart';
import '../services/user_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_text_field.dart';

class ChatDetailScreen extends StatefulWidget {
  final Chat chat;

  const ChatDetailScreen({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final MessageService _messageService = MessageService();
  final UserService _userService = UserService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageService.setTypingStatus(widget.chat.id, false);
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);
    try {
      await _messageService.fetchMessages(widget.chat.id);
      _scrollToBottom();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Constants.shortAnimationDuration,
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _handleSend() async {
    final content = _messageController.text.trim();
    if (content.isEmpty || _isSending) return;

    _messageController.clear();
    setState(() => _isSending = true);

    try {
      final message = await _messageService.sendMessage(
        chatId: widget.chat.id,
        content: content,
      );

      if (message != null) {
        _scrollToBottom();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de l\'envoi du message'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  Widget _buildMessageBubble(Message message) {
    final isCurrentUser = message.senderId == _userService.currentUser!.id;
    final bubbleColor = isCurrentUser
        ? Constants.primaryColor
        : Theme.of(context).cardColor;
    final textColor = isCurrentUser
        ? Colors.white
        : Theme.of(context).textTheme.bodyLarge!.color;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.defaultPadding,
        vertical: Constants.smallPadding / 2,
      ),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser && widget.chat.isGroup) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Constants.primaryColor.withOpacity(0.2),
              child: const Icon(
                Icons.person,
                size: 20,
                color: Constants.primaryColor,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.defaultPadding,
                vertical: Constants.smallPadding,
              ),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isCurrentUser ? 16 : 4),
                  bottomRight: Radius.circular(isCurrentUser ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isCurrentUser && widget.chat.isGroup)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        'User Name', // TODO: Get user name from UserService
                        style: TextStyle(
                          color: textColor?.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Text(
                    message.content,
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
            ),
          ),
          if (isCurrentUser) ...[
            const SizedBox(width: 8),
            Icon(
              message.isRead
                  ? Icons.done_all
                  : message.isDelivered
                      ? Icons.done_all
                      : message.isSent
                          ? Icons.done
                          : message.isSending
                              ? Icons.access_time
                              : Icons.error,
              size: 16,
              color: message.isRead
                  ? Constants.primaryColor
                  : Constants.subtitleColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateSeparator(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Constants.smallPadding),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Constants.defaultPadding,
            ),
            child: Text(
              date,
              style: TextStyle(
                color: Constants.textColor.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = _messageService.getMessages(widget.chat.id);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.chat.name),
            if (widget.chat.isTyping)
              Text(
                'En train d\'écrire...',
                style: TextStyle(
                  fontSize: 12,
                  color: Constants.primaryColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show chat options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : messages.isEmpty
                    ? Center(
                        child: Text(
                          'Aucun message',
                          style: Constants.subtitleStyle,
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(top: Constants.defaultPadding),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final showDate = index == 0 ||
                              messages[index - 1].timestamp.day !=
                                  message.timestamp.day;

                          return Column(
                            children: [
                              if (showDate)
                                _buildDateSeparator(message.formattedTime),
                              _buildMessageBubble(message),
                            ],
                          );
                        },
                      ),
          ),
          Container(
            padding: const EdgeInsets.all(Constants.defaultPadding),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () {
                      // TODO: Implement file attachment
                    },
                  ),
                  Expanded(
                    child: CustomTextField(
                      controller: _messageController,
                      hintText: 'Votre message...',
                      maxLines: 5,
                      minLines: 1,
                      textInputAction: TextInputAction.newline,
                      onChanged: (value) {
                        _messageService.setTypingStatus(
                          widget.chat.id,
                          value.isNotEmpty,
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isSending ? Icons.hourglass_empty : Icons.send,
                      color: Constants.primaryColor,
                    ),
                    onPressed: _isSending ? null : _handleSend,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
