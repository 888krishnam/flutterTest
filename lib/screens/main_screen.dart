import 'package:flutter/material.dart';
import 'package:frontend/screens/chat_screen.dart';
import 'package:frontend/screens/sent_likes_screen.dart';
import 'package:frontend/screens/swipe_screen.dart'; // Assuming you have this
import 'package:frontend/screens/user_profile_screen.dart'; // Or settings_screen

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Default to Swipe screen

  // Add your primary screens here
  static const List<Widget> _widgetOptions = <Widget>[
    SwipeScreen(), // Your main swiping screen
    SentLikesScreen(), // This will be the "Liked Profiles" screen
    ChatScreen(),
    UserProfileScreen(), // Or SettingsScreen, or a dedicated Profile tab screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.swipe_outlined),
            activeIcon: Icon(Icons.swipe),
            label: '', // Added empty label
            // backgroundColor: theme.bottomNavigationBarTheme.backgroundColor ?? theme.colorScheme.surface, // Kept removed
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: '', // Added empty label
            // backgroundColor: theme.bottomNavigationBarTheme.backgroundColor ?? theme.colorScheme.surface, // Kept removed
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: '', // Added empty label
            // backgroundColor: theme.bottomNavigationBarTheme.backgroundColor ?? theme.colorScheme.surface, // Kept removed
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '', // Added empty label
            // backgroundColor: theme.bottomNavigationBarTheme.backgroundColor ?? theme.colorScheme.surface, // Kept removed
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false, // Kept false
        showSelectedLabels: false, // Kept false
        backgroundColor: theme.scaffoldBackgroundColor, // Kept as is
      ),
    );
  }
}
