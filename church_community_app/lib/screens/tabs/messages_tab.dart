import 'package:flutter/material.dart';
import '../../models/message_model.dart';
import '../../services/message_service.dart';
import '../../services/user_service.dart';
import '../../utils/constants.dart';
import '../chat_detail_screen.dart';

class MessagesTab extends StatefulWidget {
  const MessagesTab({Key? key}) : super(key: key);

  @override
  State<MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab> {
  final MessageService _messageService = MessageService();
  final UserService _userService = UserService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    setState(() => _isLoading = true);
    try {
      await _messageService.fetchChats();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatLastMessageTime(DateTime? time) {
    if (time == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      return 'Hier';
    } else {
      return '${time.day}/${time.month}';
    }
  }

  Widget _buildChatAvatar(Chat chat) {
    if (chat.imageUrl != null) {
      return CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(chat.imageUrl!),
      );
    }

    if (chat.isGroup) {
      return CircleAvatar(
        radius: 28,
        backgroundColor: Constants.primaryColor.withOpacity(0.2),
        child: Icon(
          Icons.group,
          size: 32,
          color: Constants.primaryColor,
        ),
      );
    }

    return CircleAvatar(
      radius: 28,
      backgroundColor: Constants.primaryColor.withOpacity(0.2),
      child: Text(
        chat.name[0].toUpperCase(),
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Constants.primaryColor,
        ),
      ),
    );
  }

  Widget _buildChatTile(Chat chat) {
    final isTyping = chat.isTyping && chat.typingUserId != _userService.currentUser!.id;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Constants.defaultPadding,
        vertical: Constants.smallPadding,
      ),
      leading: _buildChatAvatar(chat),
      title: Text(
        chat.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: isTyping
          ? Text(
              'En train d\'écrire...',
              style: TextStyle(
                color: Constants.primaryColor,
                fontStyle: FontStyle.italic,
              ),
            )
          : Text(
              chat.lastMessage ?? 'Aucun message',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Constants.textColor.withOpacity(0.6),
              ),
            ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatLastMessageTime(chat.lastMessageTime),
            style: TextStyle(
              fontSize: 12,
              color: Constants.textColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isTyping ? Constants.primaryColor : Colors.transparent,
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(chat: chat),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement chat search
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Implement new chat/group creation
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadChats,
              child: _messageService.chats.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.message,
                            size: 64,
                            color: Constants.subtitleColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aucune conversation',
                            style: Constants.subtitleStyle,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Commencez une nouvelle conversation',
                            style: TextStyle(
                              color: Constants.textColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        vertical: Constants.smallPadding,
                      ),
                      itemCount: _messageService.chats.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        indent: 80,
                      ),
                      itemBuilder: (context, index) =>
                          _buildChatTile(_messageService.chats[index]),
                    ),
            ),
    );
  }
}
