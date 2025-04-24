import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

import 'screens/get_started_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen1.dart';
import 'screens/onboarding_screen2.dart';
import 'screens/onboarding_screen3.dart';
import 'screens/signup_screen.dart';
import 'screens/supplier_screen.dart';
import 'screens/vendor_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY']!,
      authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN']!,
      projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
      messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
      appId: dotenv.env['FIREBASE_APP_ID']!,
      measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'],
    ),
  );
  runApp(const SplashScreenApp());
}

class SplashScreenApp extends StatelessWidget {
  const SplashScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen1(),
        '/onboarding_screen1': (context) => const OnboardingScreen1(),
        '/onboarding_screen2': (context) => const OnboardingScreen2(),
        '/onboarding_screen3': (context) => const OnboardingScreen3(),
        '/get_started': (context) => const GetStartedScreen(),
        '/login_screen': (context) => const LoginScreen(),
        '/signup_screen': (context) => const SignupScreen(),
        '/vendor_screen': (context) => const VendorScreen(),
        '/supplier_screen': (context) => const SupplierScreen(),
      },
    );
  }
}

// Main app class that uses our SplashScreen from screens directory
