import 'package:flutter/material.dart';
import '../widgets/background_image_widget.dart';
import '../widgets/onboarding_buttons.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    print('OnboardingScreen1 build method called');
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
                      'Generate and Send Invoices',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Create and send invoices via Whatsapp, SMS, or email in just a few taps ',
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
                bottom: 17,
                right: 16,
                child: SkipButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login_screen');
                  },
                ),
              ),
              // Next Button
              Positioned(
                bottom: 17,
                left: 24,
                child: NextArrowButton(
                  onPressed: () {
                    // Navigate to next onboarding screen or home
                    Navigator.pushReplacementNamed(
                        context, '/onboarding_screen2');
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
