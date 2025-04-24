import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/login_button2.dart';
import '../widgets/signup_button.dart';
import '../logo_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _showAlert(String message, IconData icon) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const LogoWidget(size: 40, animate: false),
              const SizedBox(width: 8),
              const Text('Alert'),
            ],
          ),
          content: Row(
            children: [
              Icon(icon, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty && password.isEmpty) {
      _showAlert('Please enter your email and password.', Icons.warning);
      return;
    } else if (email.isEmpty) {
      _showAlert('Please enter your email.', Icons.email);
      return;
    } else if (password.isEmpty) {
      _showAlert('Please enter your password.', Icons.lock);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          final accountType = userDoc['accountType'];

          if (accountType == 'supplier') {
            Navigator.pushReplacementNamed(context, '/supplier_screen');
          } else if (accountType == 'vendor') {
            Navigator.pushReplacementNamed(context, '/vendor_screen');
          }
        } else {
          _showAlert('User data not found. Please contact support.', Icons.error);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showAlert('Incorrect email. Please try again.', Icons.email);
      } else if (e.code == 'wrong-password') {
        _showAlert('Incorrect password. Please try again.', Icons.lock);
      } else {
        _showAlert('Error: ${e.message}', Icons.error);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/login.jpeg', // Applied login.jpeg as background
              fit: BoxFit.cover,
            ),
          ),
          // Black overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // Black overlay with opacity
            ),
          ),
          // Moved Signup Button to the top left corner
          Positioned(
            top: 16,
            left: 16,
            child: SignupButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signup_screen');
              },
              text: 'Sign Up',
              width: 120, // Resized width
              height: 40, // Resized height
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const SizedBox(
                      height: 40), // Push the login section further down
                  const SizedBox(
                      height: 40), // Push the login form further down
                  const SizedBox(
                      height: 20), // Push the login form further down
                  Center(
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A1B9A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email/Phone Number',
                      hintText: 'Enter your email or phone number',
                      prefixIcon: Icon(Icons.email), // Added email icon
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30), // Added radius
                        borderSide: BorderSide(
                          color: Color(0xFF6A1B9A), // Purple outline color
                        ),
                      ),
                      filled: true, // Enable background color
                      fillColor: Colors.white, // White background
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock), // Added lock icon
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30), // Added radius
                        borderSide: BorderSide(
                          color: Color(0xFF6A1B9A), // Purple outline color
                        ),
                      ),
                      filled: true, // Enable background color
                      fillColor: Colors.white, // White background
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : LoginButton2(
                            onPressed: _login,
                            text: 'Login',
                            width: 300,
                          ),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Black text for the first part
                        ),
                        children: [
                          TextSpan(
                            text: 'Signup',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  Color(0xFF6A1B9A), // Purple text for 'Signup'
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacementNamed(
                                    context, '/signup_screen');
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
