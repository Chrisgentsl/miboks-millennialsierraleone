import 'package:flutter/material.dart';
import '../widgets/background_image_widget3.dart';
import '../widgets/onboarding_buttons.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundImageWidget(
        child: SafeArea(
          child: Stack(
            children: [
              // Content
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Secure and Offline Friendly',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Access your data offline, with cloud backup for security Use PIN or biometric login for protection.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 45),
                  ],
                ),
              ),
              // Get Started Button
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/get_started');
                      },
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Prev Button
              Positioned(
                bottom: 16,
                left: 24,
                child: PrevArrowButton(
                  onPressed: () {
                    // Navigate back to previous onboarding screen
                    Navigator.pushReplacementNamed(context, '/onboarding_screen2');
                  },
                ),
              ),
              // Next Button
              Positioned(
                bottom: 16,
                left: 100,
                child: NextArrowButton(
                  onPressed: () {
                    // Navigate to get started screen
                    Navigator.pushReplacementNamed(context, '/get_started');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}