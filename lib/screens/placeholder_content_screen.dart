import 'package:flutter/material.dart';

class PlaceholderContentScreen extends StatelessWidget {
  final String title;
  final String? content; // Optional content

  const PlaceholderContentScreen({
    super.key,
    required this.title,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            content ?? 'Content for "$title" will be available here soon.',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
