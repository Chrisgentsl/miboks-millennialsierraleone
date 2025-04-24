import 'package:flutter/material.dart';
import '../widgets/background_image_widget2.dart';
import '../widgets/onboarding_buttons.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

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
                      'Track Sales and Manage Inventory',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Automatically track sales, expenses, and inventory.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 45),
                  ],
                ),
              ),
              // Skip Button
              Positioned(
                bottom: 16,
                right: 16,
                child: SkipButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login_screen');
                  },
                ),
              ),
              // Prev Button
              Positioned(
                bottom: 16,
                left: 24,
                child: PrevArrowButton(
                  onPressed: () {
                    // Navigate back to previous onboarding screen
                    Navigator.pushReplacementNamed(context, '/onboarding_screen1');
                  },
                ),
              ),
              // Next Button
              Positioned(
                bottom: 16,
                left: 100,
                child: NextArrowButton(
                  onPressed: () {
                    // Navigate to next onboarding screen
                    Navigator.pushReplacementNamed(context, '/onboarding_screen3');
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