
import 'package:flutter/material.dart';
import 'package:frontend/screens/individual_chat_screen.dart'; // To be created

// Mock data for chat conversations - replace with actual data later
class ChatConversation {
  final String userId;
  final String name;
  final String lastMessage;
  final String timestamp;
  final String avatarUrl; // Placeholder for profile picture

  ChatConversation({
    required this.userId,
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    required this.avatarUrl,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Mock data - replace with actual data from your backend/state management
  final List<ChatConversation> _conversations = [
    ChatConversation(
      userId: '1',
      name: 'Alice Wonderland',
      lastMessage: 'Hey, how are you?',
      timestamp: '10:30 AM',
      avatarUrl: 'https://picsum.photos/seed/alice/200/200',
    ),
    ChatConversation(
      userId: '2',
      name: 'Bob The Builder',
      lastMessage: 'Sounds good! See you then.',
      timestamp: 'Yesterday',
      avatarUrl: 'https://picsum.photos/seed/bob/200/200',
    ),
    ChatConversation(
      userId: '3',
      name: 'Charlie Brown',
      lastMessage: 'Can you send me the file?',
      timestamp: 'Mon',
      avatarUrl: 'https://picsum.photos/seed/charlie/200/200',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: _conversations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.message_outlined, size: 80, color: Colors.grey[600]),
                  const SizedBox(height: 16),
                  Text(
                    'No Matches Yet',
                    style: theme.textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Keep swiping to find your Klyro connection!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                final conversation = _conversations[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(conversation.avatarUrl),
                    radius: 25,
                  ),
                  title: Text(
                    conversation.name,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    conversation.lastMessage,
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    conversation.timestamp,
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndividualChatScreen(
                          userId: conversation.userId,
                          userName: conversation.name,
                          userAvatarUrl: conversation.avatarUrl,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
