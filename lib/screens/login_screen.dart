import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _linkSent = false;
  String? _errorMessage;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your university email';
    }

    // Basic email format validation
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}").hasMatch(value)) {
      return 'Please enter a valid email address format';
    }

    // Only allow .edu.in or .ac.in domains
    final domain = value.split('@').last.toLowerCase();
    if (!domain.endsWith('.edu.in') && !domain.endsWith('.ac.in')) {
      return 'Email must end with .edu.in or .ac.in';
    }

    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await _authService.sendSignInLink(_emailController.text.trim());
      setState(() {
        _linkSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check your email for the sign-in link'))
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error sending link: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                if (_linkSent) ...[
                  const Text('A sign-in link has been sent to your email.'),
                  const SizedBox(height: 24),
                ],
                if (_errorMessage != null) ...[
                  Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  key: const Key('email_field'),
                  controller: _emailController,
                  enabled: !_isLoading && !_linkSent,
                  decoration: InputDecoration(
                    labelText: 'University Email', // Simplified label
                    hintText: 'e.g., yourname@srmist.edu.in', // Added hint text
                    prefixIcon: Icon(Icons.school), // Changed icon to represent university
                  ),
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  autovalidateMode: AutovalidateMode.onUserInteraction, // Added for real-time validation feedback
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  key: const Key('send_link_button'),
                  onPressed: (_isLoading || _linkSent) ? null : _submit,
                  child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Send Sign-In Link'),
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
