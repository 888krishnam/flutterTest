import 'package:flutter/material.dart';
import 'package:test_flutter/screens/otp_screen.dart'; // Import OTPScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  // TODO: Populate this list with all specific university domains Klyro will support.
  final List<String> _acceptedUniversityDomains = [
    'srmist.edu.in',
    'vit.ac.in',
    'bitspilani.ac.in', // Example with hyphen
    'iitd.ac.in',
    'iitb.ac.in',
    'tifr.res.in',
    'someotheruni.edu.in' // Add more domains as needed
  ];

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your university email';
    }

    // Basic email format validation
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}").hasMatch(value)) {
      return 'Please enter a valid email address format';
    }

    // Extract domain from email
    final String emailDomain = value.split('@').last.toLowerCase();

    // Check against the list of accepted university domains
    if (!_acceptedUniversityDomains.contains(emailDomain)) {
      return 'Sorry, Klyro is not yet available for your institution.'; // More user-friendly message
    }

    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      print('Email submitted: \${_emailController.text}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(email: _emailController.text),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Klyro',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Login or Sign Up',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'University Email', // Simplified label
                    hintText: 'e.g., yourname@srmist.edu.in', // Added hint text
                    prefixIcon: Icon(Icons.school), // Changed icon to represent university
                  ),
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Continue with Email'),
                ),
                const SizedBox(height: 16),
                Text(
                  'By continuing, you agree to our Terms of Service and Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
