import 'package:flutter/material.dart';
import '../components/logo.dart';
import '../components/input_field.dart';
import '../components/black_button.dart';
import '../components/labeled_checkbox.dart';
import 'signup_screen.dart';
import 'main_screen.dart';
import 'app_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validation
    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please enter email and password.');
      return;
    }

    // Check if user exists
    final user = loginUser(email, password);

    if (user == null) {
      // Check if email is registered at all
      final emailExists = registeredUsers.any((u) => u['email'] == email);
      setState(() {
        _errorMessage = emailExists
            ? 'Incorrect password. Please try again.'
            : 'No account found. Please create an account first.';
      });
      return;
    }

    // Login successful
    setState(() => _errorMessage = null);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainScreen(
          userEmail: user['email'] ?? '',
          userName: user['name'] ?? '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EEE8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Center(child: AppLogoWidget()),
              const SizedBox(height: 24),
              const Center(
                child: Text('Welcome back',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text('Sign in to your account',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ),
              const SizedBox(height: 32),
              InputField(
                label: 'Email',
                hint: 'Enter your email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              InputField(
                label: 'Password',
                hint: 'Enter your password',
                controller: _passwordController,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),

              // Error message
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(children: [
                    Icon(Icons.error_outline, color: Colors.red.shade600, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(_errorMessage!,
                          style: TextStyle(
                              fontSize: 13, color: Colors.red.shade700)),
                    ),
                  ]),
                ),
              ],

              const SizedBox(height: 16),
              LabeledCheckbox(
                value: _rememberMe,
                label: 'Remember for 30 days',
                onChanged: (val) => setState(() => _rememberMe = val ?? false),
              ),
              const SizedBox(height: 28),
              BlackButton(
                label: 'Log in',
                trailingIcon: Icons.arrow_forward,
                onPressed: _login,
              ),
              const SizedBox(height: 28),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupScreen())),
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      children: const [
                        TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
