import 'package:flutter/material.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBzNzjzZJ95sAgNJeVUd6mn49uPhlqeZ9s",
      authDomain: "mibok-bf25c.firebaseapp.com",
      projectId: "mibok-bf25c",
      storageBucket: "mibok-bf25c.firebasestorage.app",
      messagingSenderId: "89215333842",
      appId: "1:89215333842:web:b56fa4671be2dabc78440b",
      measurementId: "G-RTSMLNJYD1",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Boks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/onboarding',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen1(),
        '/onboarding_screen1': (context) => const OnboardingScreen1(),
        '/onboarding_screen2': (context) => const OnboardingScreen2(),
        '/onboarding_screen3': (context) => const OnboardingScreen3(),
        '/get_started': (context) => const GetStartedScreen(),
        '/home': (context) => const HomeScreen(),
        '/login_screen': (context) => const LoginScreen(),
        '/signup_screen': (context) => const SignupScreen(),
        '/vendor_screen': (context) => const VendorScreen(),
        '/supplier_screen': (context) => const SupplierScreen(),
      },
    );
  }
}

// Main app class that uses our SplashScreen from screens directory

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Boks'),
      ),
      body: const Center(
        child: Text('Welcome to Mi Boks!'),
      ),
    );
  }
}
