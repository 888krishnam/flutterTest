import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/firebase_options.dart';
import 'package:frontend/screens/main_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const MainScreen(),
      // We will need to handle the navigation flow: LoginScreen -> MainScreen
      // For now, to see the BottomNavigationBar, we set MainScreen as home.
      // Later, LoginScreen will navigate to MainScreen upon successful login.
    );
  }
}
