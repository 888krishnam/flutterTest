import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:frontend/firebase_options.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/main_screen.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:sojo_link/sojo_link.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService();
  // Key for navigating programmatically
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();
  // Subscription to SojoLink dynamic link events
  late final StreamSubscription _linkSub;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    // Handle web initial email-link on page load
    if (kIsWeb) {
      final link = Uri.base.toString();
      _authService.signInWithLink(link).then((cred) {
        if (cred?.user != null && mounted) {
          setState(() => _loggedIn = true);
          // Navigate to main screen
          _navKey.currentState?.pushReplacement(
            MaterialPageRoute(builder: (_) => const MainScreen())
          );
        }
      });
    }
    // Subscribe to SojoLink dynamic links
    _linkSub = SojoLink.instance.onLink.listen((pendingDynamicLink) async {
      final Uri linkUri = pendingDynamicLink.link;
      final cred = await _authService.signInWithLink(linkUri.toString());
      if (cred?.user != null && mounted) {
        setState(() => _loggedIn = true);
        // Navigate to main screen
        _navKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen())
        );
      }
    });
    // Track Firebase auth state changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted) setState(() => _loggedIn = user != null);
    });
  }

  @override
  void dispose() {
    _linkSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navKey,
      title: 'Klyro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
          primary: Colors.purple,
          secondary: Colors.red,
          surface: Colors.purple[900]!, // Dull purple for surfaces that were grey
          onSurface: Colors.white, // Text/icons on dull purple
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white70),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.purple[200]),
          hintStyle: TextStyle(color: Colors.white54),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple[700]!), // Dull purple border
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple, width: 2),
            borderRadius: BorderRadius.circular(8.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.purple[900]!.withOpacity(0.3), // Dull purple fill, slightly transparent
          prefixIconColor: Colors.purple[200],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          )
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
             labelStyle: TextStyle(color: Colors.purple[200]),
             hintStyle: TextStyle(color: Colors.white54),
             enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple[700]!), // Dull purple border
                borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple, width: 2),
                borderRadius: BorderRadius.circular(8.0),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: Colors.purple[900]!.withOpacity(0.3), // Dull purple fill
            prefixIconColor: Colors.purple[200],
          )
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.purple[700]!, // Changed to a duller purple
          showUnselectedLabels: false,
          showSelectedLabels: false,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        cardTheme: CardThemeData( // Corrected to CardThemeData
          color: Colors.purple[900]!.withOpacity(0.5), // Dull purple for cards
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Colors.purple[700]!, width: 0.5), // Optional: subtle border
          ),
        ),
        dividerTheme: DividerThemeData( // Added DividerTheme
          color: Colors.purple[700]!,
          thickness: 0.8,
        ),
      ),
      home: _loggedIn ? const MainScreen() : const LoginScreen(),
    );
  }
}

