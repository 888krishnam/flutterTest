import 'package:flutter/material.dart';
import 'package:frontend/screens/login_screen.dart'; // For logout
import 'package:frontend/screens/edit_profile_screen.dart'; // Import EditProfileScreen
import 'package:frontend/screens/placeholder_content_screen.dart'; // Import PlaceholderContentScreen

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _showConfirmationDialog(BuildContext context, String title, String content, VoidCallback onConfirm) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Confirm', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) {
    _showConfirmationDialog(
      context,
      'Logout',
      'Are you sure you want to logout?',
      () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
        // TODO: Add any actual logout logic here (e.g., clearing session, tokens)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully logged out.')),
        );
      },
    );
  }

  void _pauseAccount(BuildContext context) {
    _showConfirmationDialog(
      context,
      'Pause Account',
      'Pausing your account will hide your profile from others. You can unpause it anytime. Are you sure?',
      () {
        // TODO: Implement pause account logic with backend
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account paused (feature to be implemented).')),
        );
      },
    );
  }

  void _deleteAccount(BuildContext context) {
    _showConfirmationDialog(
      context,
      'Delete Account',
      'Deleting your account is permanent and cannot be undone. All your data will be removed. Are you sure?',
      () {
        // TODO: Implement delete account logic with backend
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deletion initiated (feature to be implemented).')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.edit, color: theme.colorScheme.primary),
            title: Text('Edit Profile & Preferences', style: TextStyle(color: theme.colorScheme.onSurface)),
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.5)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Account Management', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary)),
          ),
          ListTile(
            leading: Icon(Icons.pause_circle_outline, color: theme.colorScheme.secondary),
            title: Text('Pause Account', style: TextStyle(color: theme.colorScheme.onSurface)),
            onTap: () => _pauseAccount(context),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: theme.colorScheme.error),
            title: Text('Delete Account', style: TextStyle(color: theme.colorScheme.onSurface)),
            onTap: () => _deleteAccount(context),
          ),
          const Divider(),
           ListTile(
            leading: Icon(Icons.logout, color: theme.colorScheme.primary),
            title: Text('Logout', style: TextStyle(color: theme.colorScheme.onSurface)),
            onTap: () => _logout(context),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Support & Legal', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary)),
          ),
          ListTile(
            leading: Icon(Icons.help_outline, color: theme.colorScheme.primary),
            title: Text('Help & Support', style: TextStyle(color: theme.colorScheme.onSurface)),
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.5)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlaceholderContentScreen(title: 'Help & Support')),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.gavel, color: theme.colorScheme.primary),
            title: Text('Terms of Service', style: TextStyle(color: theme.colorScheme.onSurface)),
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.5)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlaceholderContentScreen(title: 'Terms of Service')),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip_outlined, color: theme.colorScheme.primary),
            title: Text('Privacy Policy', style: TextStyle(color: theme.colorScheme.onSurface)),
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.5)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlaceholderContentScreen(title: 'Privacy Policy')),
              );
            },
          ),
        ],
      ),
    );
  }
}
