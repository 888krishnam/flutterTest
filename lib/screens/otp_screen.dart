import 'package:flutter/material.dart';
import 'package:frontend/screens/profile_creation_screen.dart'; // Import ProfileCreationScreen

class OTPScreen extends StatefulWidget {
  final String email;
  const OTPScreen({super.key, required this.email});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  // OTP validity period (e.g., 10 minutes)
  // Timer _timer;
  // int _start = 600; // 10 minutes in seconds

  // void startTimer() {
  //   const oneSec = Duration(seconds: 1);
  //   _timer = Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (_start == 0) {
  //         setState(() {
  //           timer.cancel();
  //           // Handle OTP expiration
  //         });
  //       } else {
  //         setState(() {
  //           _start--;
  //         });
  //       }
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    // startTimer();
    // TODO: Send OTP to widget.email
    print("OTP Screen for \${widget.email}. Implement OTP sending.");
  }

  @override
  void dispose() {
    _otpController.dispose();
    // _timer.cancel();
    super.dispose();
  }

  String? _validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the OTP';
    }
    if (value.length != 6) { // Assuming OTP is 6 digits
      return 'OTP must be 6 digits';
    }
    if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
      return 'OTP must contain only digits';
    }
    return null;
  }

  void _verifyOtp() {
    if (_formKey.currentState!.validate()) {
      // Process OTP verification
      print('OTP submitted: \${_otpController.text} for email: \${widget.email}');
      // If OTP is correct, navigate to Profile Creation or Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileCreationScreen()),
      );
    }
  }

  void _resendOtp() {
    // Logic to resend OTP
    print('Resend OTP requested for \${widget.email}');
    // setState(() {
    //   _start = 600; // Reset timer
    // });
    // startTimer();
    // TODO: Implement actual OTP resend logic
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
      ),
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
                  'Enter OTP',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  'An OTP has been sent to \${widget.email}. Please enter it below.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _otpController,
                  decoration: InputDecoration(
                    labelText: 'OTP (6 digits)',
                    labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                    hintText: '123456',
                    hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                    prefixIcon: Icon(Icons.password, color: theme.colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surface.withOpacity(0.1),
                  ),
                  style: TextStyle(color: theme.colorScheme.onSurface, letterSpacing: 3),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  validator: _validateOtp,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                     shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: _verifyOtp,
                  child: const Text('Verify OTP'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _resendOtp, // TODO: Add timer logic before enabling resend
                  child: Text(
                    'Resend OTP', // Add timer display e.g., 'Resend OTP in \$_start s'
                    style: TextStyle(color: theme.colorScheme.secondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
