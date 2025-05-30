import 'package:flutter/material.dart';

// Mock data model for a user profile
class UserProfile {
  final String name;
  final int age;
  final List<String> imageAssetPaths; // Now expects list of image URLs
  final String university;
  final String bio;

  UserProfile({
    required this.name,
    required this.age,
    required this.imageAssetPaths,
    required this.university,
    this.bio = "No bio yet.",
  });
}

class ProfileCardWidget extends StatelessWidget {
  final UserProfile userProfile;

  const ProfileCardWidget({
    super.key,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: Colors.grey[850],
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          children: [
            // Background Image (first photo)
            if (userProfile.imageAssetPaths.isNotEmpty)
              Positioned.fill(
                child: Image.network( // Changed from Image.asset to Image.network
                  userProfile.imageAssetPaths[0], // Display the first image URL
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                        color: theme.colorScheme.primary,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.broken_image, size: 50, color: Colors.white54)),
                ),
              ),
            if (userProfile.imageAssetPaths.isEmpty)
              Container(
                color: Colors.grey[700],
                child: const Center(child: Icon(Icons.person, size: 100, color: Colors.white24)),
              ),

            // Gradient overlay for text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent, Colors.black.withOpacity(0.8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Profile Information
            Positioned(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${userProfile.name}, ${userProfile.age}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        const Shadow(blurRadius: 2.0, color: Colors.black54, offset: Offset(1,1)),
                      ]
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    userProfile.university,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                       shadows: [
                        const Shadow(blurRadius: 1.0, color: Colors.black45, offset: Offset(1,1)),
                      ]
                    ),
                  ),
                  // Optional: Add a short bio or other info here
                  // if (userProfile.bio.isNotEmpty) ...[
                  //   const SizedBox(height: 4.0),
                  //   Text(
                  //     userProfile.bio,
                  //     style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.8)),
                  //     maxLines: 2,
                  //     overflow: TextOverflow.ellipsis,
                  //   ),
                  // ],
                ],
              ),
            ),
            // TODO: Add tap to view full profile details later
          ],
        ),
      ),
    );
  }
}
