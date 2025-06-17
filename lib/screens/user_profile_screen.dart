import 'package:flutter/material.dart';
import './edit_profile_screen.dart'; // Import EditProfileScreen

// This screen will be used for viewing and editing the user's own profile later.
// For now, it's a placeholder.

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // TODO: Load user data for display and editing

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
          ),
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: theme.colorScheme.primary,
                // backgroundImage: NetworkImage('USER_PHOTO_URL_HERE'), // Placeholder
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'User Name', // Placeholder
                style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                'University Name (from email)', // Placeholder
                style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 24),
            _buildProfileDetailItem(context, Icons.cake, 'Age', '22'), // Placeholder
            _buildProfileDetailItem(context, Icons.wc, 'Gender', 'Man'), // Placeholder
            const Divider(color: Colors.white24, height: 32),
            Text(
              'Photos',
              style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            // Placeholder for photo gallery
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3, // Placeholder count
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey[800],
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Icon(Icons.image, color: Colors.white54, size: 40),
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Colors.white24, height: 32),
            Text(
              'Preferences',
              style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            _buildProfileDetailItem(context, Icons.favorite_border, 'Interested In', 'Women'), // Placeholder
            _buildProfileDetailItem(context, Icons.tune, 'Preferred Age Range', '18-25'), // Placeholder
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetailItem(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 16),
          Text(
            '$label: ',
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
