import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeMessageWidget extends StatefulWidget {
  const WelcomeMessageWidget({super.key});

  @override
  State<WelcomeMessageWidget> createState() => _WelcomeMessageWidgetState();
}

class _WelcomeMessageWidgetState extends State<WelcomeMessageWidget> {
  String businessName = '';

  @override
  void initState() {
    super.initState();
    _fetchBusinessName();
  }

  Future<void> _fetchBusinessName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          setState(() {
            businessName = doc['businessName'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Error fetching business name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          businessName.isNotEmpty
              ? 'Welcome to MiBoks, $businessName!'
              : 'Welcome to MiBoks!',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}