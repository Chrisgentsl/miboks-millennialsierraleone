import 'package:flutter/material.dart';

class AfrimoneyWidget extends StatelessWidget {
  final Function(String) onPhoneNumberSubmitted;

  const AfrimoneyWidget({
    super.key,
    required this.onPhoneNumberSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _phoneController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Afrimoney Payment',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Afrimoney Number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone_android, color: Color(0xFF00A859)),
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              onPhoneNumberSubmitted(_phoneController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A859),
              foregroundColor: Colors.white,
            ),
            child: const Text('Proceed'),
          ),
        ),
      ],
    );
  }
}