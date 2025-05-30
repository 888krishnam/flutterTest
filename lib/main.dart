import 'package:flutter/material.dart';
import 'package:test_flutter/screens/login_screen.dart'; // Import the login screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klyro',
      debugShowCheckedModeBanner: false, // Add this line
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
          primary: Colors.purple,
          secondary: Colors.red,
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
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
          headlineSmall: TextStyle(color: Colors.white), // Added for profile creation screen
          titleMedium: TextStyle(color: Colors.white70), // Added for profile creation screen
          titleLarge: TextStyle(color: Colors.white), // Added for user profile screen
          bodySmall: TextStyle(color: Colors.white70), // Added for login screen fine print
        ),
        inputDecorationTheme: InputDecorationTheme( // Added for consistent text field styling
          labelStyle: TextStyle(color: Colors.purple[200]),
          hintStyle: TextStyle(color: Colors.white54),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white38),
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
          fillColor: Colors.grey[850],
          prefixIconColor: Colors.purple[200],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData( // Added for consistent button styling
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.red, // Using secondary color for text buttons
          )
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
             labelStyle: TextStyle(color: Colors.purple[200]),
             hintStyle: TextStyle(color: Colors.white54),
             enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white38),
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
            fillColor: Colors.grey[850],
            prefixIconColor: Colors.purple[200],
          )
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(), // Set LoginScreen as the home
      // We will remove MyHomePage or repurpose it later.
      // home: const MyHomePage(title: 'Klyro Home Page'), 
    );
  }
}

// ... MyHomePage and _MyHomePageState can be removed or commented out for now ...
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
