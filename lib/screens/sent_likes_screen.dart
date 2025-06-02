import 'package:flutter/material.dart';

// Mock data for liked profiles - replace with actual data later
class LikedUserProfile {
  final String userId;
  final String name;
  final int age;
  final String university;
  final String imageUrl;
  final DateTime likedTimestamp;

  LikedUserProfile({
    required this.userId,
    required this.name,
    required this.age,
    required this.university,
    required this.imageUrl,
    required this.likedTimestamp,
  });
}

class SentLikesScreen extends StatefulWidget {
  const SentLikesScreen({super.key});

  @override
  State<SentLikesScreen> createState() => _SentLikesScreenState();
}

class _SentLikesScreenState extends State<SentLikesScreen> {
  // Mock data - replace with actual data from your backend/state management
  final List<LikedUserProfile> _sentLikes = [
    LikedUserProfile(
      userId: 'user123',
      name: 'Sarah J.',
      age: 21,
      university: 'SRMIST',
      imageUrl: 'https://picsum.photos/seed/sarah/300/300',
      likedTimestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    LikedUserProfile(
      userId: 'user456',
      name: 'Mike L.',
      age: 23,
      university: 'VIT Chennai',
      imageUrl: 'https://picsum.photos/seed/mike/300/300',
      likedTimestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    LikedUserProfile(
      userId: 'user789',
      name: 'Emily K.',
      age: 20,
      university: 'IIT Madras',
      imageUrl: 'https://picsum.photos/seed/emily/300/300',
      likedTimestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
     LikedUserProfile(
      userId: 'user101',
      name: 'David P.',
      age: 22,
      university: 'SRMIST',
      imageUrl: 'https://picsum.photos/seed/david/300/300',
      likedTimestamp: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  // TODO: Implement logic to remove a like (undo/unswipe)
  void _removeLike(String userId) {
    setState(() {
      _sentLikes.removeWhere((profile) => profile.userId == userId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Like removed (placeholder action)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Profiles'), // Renamed from 'Sent Likes'
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: _sentLikes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey[600]),
                  const SizedBox(height: 16),
                  Text(
                    'No Likes Sent Yet',
                    style: theme.textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Profiles you like will appear here.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two profiles per row
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 0.75, // Adjust for desired card proportions
              ),
              itemCount: _sentLikes.length,
              itemBuilder: (context, index) {
                final profile = _sentLikes[index];
                return Card(
                  color: Colors.grey[850], // Card background color
                  clipBehavior: Clip.antiAlias, // For rounded corners on image
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      // TODO: Implement navigation to a detailed profile view if needed
                      // Or, perhaps a modal with more details and an unswipe option.
                      print('Tapped on ${profile.name}');
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.network(
                            profile.imageUrl,
                            fit: BoxFit.cover,
                            // Optional: Add a loading builder for better UX
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => 
                              Center(child: Icon(Icons.broken_image, color: Colors.grey[600], size: 40)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${profile.name}, ${profile.age}',
                                style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                profile.university,
                                style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Optional: Add an unswipe button directly on the card
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
                        //   child: TextButton.icon(
                        //     icon: Icon(Icons.undo, color: theme.colorScheme.secondary, size: 18),
                        //     label: Text('Unswipe', style: TextStyle(color: theme.colorScheme.secondary, fontSize: 12)),
                        //     onPressed: () => _removeLike(profile.userId),
                        //     style: TextButton.styleFrom(
                        //       padding: EdgeInsets.zero,
                        //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
