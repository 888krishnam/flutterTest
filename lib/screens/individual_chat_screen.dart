
import 'package:flutter/material.dart';

// Mock data for messages - replace with actual data later
class ChatMessage {
  final String text;
  final bool isSentByMe;
  final String timestamp;

  ChatMessage({
    required this.text,
    required this.isSentByMe,
    required this.timestamp,
  });
}

class IndividualChatScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String userAvatarUrl;

  const IndividualChatScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.userAvatarUrl,
  });

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mock data - replace with actual data from your backend/state management
  final List<ChatMessage> _messages = [
    ChatMessage(text: 'Hey, how are you?', isSentByMe: false, timestamp: '10:30 AM'),
    ChatMessage(text: 'I am good, thanks! How about you?', isSentByMe: true, timestamp: '10:31 AM'),
    ChatMessage(text: 'Doing great! Just finished a project.', isSentByMe: false, timestamp: '10:32 AM'),
    ChatMessage(text: 'Awesome! What was it about?', isSentByMe: true, timestamp: '10:33 AM'),
    ChatMessage(text: 'It was a Flutter app for social discovery 😉', isSentByMe: false, timestamp: '10:34 AM'),
    ChatMessage(text: 'No way! That sounds cool.', isSentByMe: true, timestamp: '10:35 AM'),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: _messageController.text.trim(),
        isSentByMe: true,
        timestamp: TimeOfDay.now().format(context), // Simple timestamp
      ));
      _messageController.clear();
    });

    // Scroll to the bottom after sending a message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

 @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        leadingWidth: 40, // Adjust to make space for avatar
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.userAvatarUrl),
              radius: 18,
            ),
            const SizedBox(width: 12),
            Text(widget.userName, style: theme.appBarTheme.titleTextStyle),
          ],
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.more_vert, color: theme.appBarTheme.iconTheme?.color),
        //     onPressed: () {
        //       // TODO: Implement more options (e.g., view profile, unmatch)
        //     },
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message, theme);
              },
            ),
          ),
          _buildMessageInputField(theme),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, ThemeData theme) {
    final bool isSentByMe = message.isSentByMe;
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSentByMe ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest, // Differentiate sender/receiver
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
            bottomLeft: isSentByMe ? const Radius.circular(16.0) : const Radius.circular(0.0),
            bottomRight: isSentByMe ? const Radius.circular(0.0) : const Radius.circular(16.0),
          ),
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75), // Max width for bubbles
        child: Column(
          crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(color: isSentByMe ? Colors.white : theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 4.0),
            Text(
              message.timestamp,
              style: TextStyle(
                fontSize: 10.0,
                color: isSentByMe ? Colors.white70 : theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInputField(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor, // Match scaffold background
        border: Border(top: BorderSide(color: theme.dividerColor, width: 0.5)),
      ),
      child: Row(
        children: [
          // IconButton(
          //   icon: Icon(Icons.add_photo_alternate_outlined, color: theme.colorScheme.primary),
          //   onPressed: () {
          //     // TODO: Implement image sending
          //   },
          // ),
          Expanded(
            child: TextField(
              controller: _messageController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[850], // Slightly different from scaffold for visibility
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              ),
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.send, color: theme.colorScheme.primary),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
