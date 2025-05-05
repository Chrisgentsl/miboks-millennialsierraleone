import 'package:flutter/material.dart';

class OrangeMoneyWidget extends StatelessWidget {
  final Function(String) onPhoneNumberSubmitted;

  const OrangeMoneyWidget({
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
          'Orange Money Payment',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Orange Money Number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone_android, color: Color(0xFFFF6600)),
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
              backgroundColor: const Color(0xFFFF6600),
              foregroundColor: Colors.white,
            ),
            child: const Text('Proceed'),
          ),
        ),
      ],
    );
  }
}