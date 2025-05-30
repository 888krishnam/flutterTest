import 'package:flutter/material.dart';
import 'package:test_flutter/widgets/profile_card_widget.dart'; // Import the profile card
import 'package:flutter_card_swiper/flutter_card_swiper.dart'; // Added for card swiping
import 'package:test_flutter/screens/settings_screen.dart'; // Import SettingsScreen

// Mock data for profiles - replace with actual data fetching later
final List<UserProfile> mockProfiles = [
  UserProfile(name: "Alice", age: 22, imageAssetPaths: ["https://picsum.photos/seed/alice/400/600"], university: "SRMIST", bio: "Loves photography and travel."),
  UserProfile(name: "Bob", age: 24, imageAssetPaths: ["https://picsum.photos/seed/bob/400/600"], university: "SRMIST", bio: "Loves hiking and coding!"),
  UserProfile(name: "Charlie", age: 21, imageAssetPaths: ["https://picsum.photos/seed/charlie/400/600"], university: "SRMIST", bio: "Aspiring musician and artist."),
  UserProfile(name: "Diana", age: 23, imageAssetPaths: ["https://picsum.photos/seed/diana/400/600"], university: "SRMIST", bio: "Coffee enthusiast and bookworm."),
  UserProfile(name: "Edward", age: 25, imageAssetPaths: ["https://picsum.photos/seed/edward/400/600"], university: "SRMIST", bio: "Tech geek and gamer."),
  UserProfile(name: "Fiona", age: 20, imageAssetPaths: ["https://picsum.photos/seed/fiona/400/600"], university: "SRMIST", bio: "Foodie and movie buff."),
  UserProfile(name: "George", age: 22, imageAssetPaths: ["https://picsum.photos/seed/george/400/600"], university: "SRMIST", bio: "Sports fanatic and gym goer."),

];
// Note: Using picsum.photos for placeholder network images.
// Later, these URLs will come from your backend (e.g., Firebase Storage).


class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  final CardSwiperController _swiperController = CardSwiperController();
  // int _currentIndex = 0; // No longer needed as CardSwiper manages current index

  // Callback when a card is swiped
  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    debugPrint(
      'User swiped card $previousIndex to ${direction.name}. Current card is $currentIndex',
    );
    // TODO: Handle like/dislike action based on direction
    // e.g., if (direction == CardSwiperDirection.right) { /* handle like */ }
    // TODO: Send swipe data to backend
    return true; // Return true to allow the swipe
  }

  // Callback when all cards have been swiped
  void _onEnd() {
    debugPrint("End of cards reached");
    // Optionally, show a message or fetch more profiles
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No more profiles for now!")),
    );
  }


  void _undoSwipe() {
    _swiperController.undo();
     debugPrint("Undo swipe");
  }

  void _like() {
    _swiperController.swipeRight();
    debugPrint("Liked profile");
  }

  void _dislike() {
    _swiperController.swipeLeft();
    debugPrint("Disliked profile");
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Optional: Removes back button if not needed
        title: Text('Klyro', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border), // Icon for Liked Profiles
            tooltip: 'Sent Likes',
            onPressed: () {
              // TODO: Navigate to Sent Likes screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to Sent Likes (to be implemented)')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Messages',
            onPressed: () {
              // TODO: Navigate to Matches/Chat list screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to Messages (to be implemented)')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: mockProfiles.isEmpty
          ? Center(
              child: Text(
                "No profiles available right now.", // Updated message
                style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: CardSwiper(
                    controller: _swiperController,
                    cardsCount: mockProfiles.length,
                    onSwipe: _onSwipe,
                    onUndo: _onUndo,
                    onEnd: _onEnd, // Callback for when all cards are swiped
                    numberOfCardsDisplayed: mockProfiles.length < 3 ? mockProfiles.length : 3, // Show 1, 2, or 3 cards
                    backCardOffset: const Offset(30, 30),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                    cardBuilder: (
                      context,
                      index,
                      horizontalThresholdPercentage,
                      verticalThresholdPercentage,
                    ) {
                      return ProfileCardWidget(userProfile: mockProfiles[index]);
                    },
                    allowedSwipeDirection: AllowedSwipeDirection.symmetric(horizontal: true), // Allow only left/right swipes
                    isLoop: false, // Don't loop cards for now
                  ),
                ),
                // Action Buttons (Like, Dislike, Undo)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        heroTag: 'dislike_button',
                        onPressed: _dislike,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.close, color: theme.colorScheme.error, size: 30), // Use theme error color
                      ),
                      FloatingActionButton.large(
                         heroTag: 'like_button',
                        onPressed: _like,
                        backgroundColor: theme.colorScheme.primary,
                        child: const Icon(Icons.favorite, color: Colors.white, size: 40),
                      ),
                      FloatingActionButton(
                         heroTag: 'undo_button',
                        onPressed: _undoSwipe, // Updated to _undoSwipe
                        backgroundColor: Colors.white,
                        child: Icon(Icons.undo, color: Colors.orangeAccent, size: 30),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  // Dummy _onUndo callback for CardSwiper, actual logic is in _undoSwipe
  bool _onUndo(int? previousIndex, int currentIndex, CardSwiperDirection direction) {
    debugPrint("Undo event: $currentIndex, $direction");
    // This callback is for the swiper's internal undo event.
    // We handle the button press in _undoSwipe.
    return true; // Return true to allow the undo.
  }
}

// Remove the dummy CardSwiperDirection enum as it's provided by the package
// enum CardSwiperDirection { left, right, top, bottom }
