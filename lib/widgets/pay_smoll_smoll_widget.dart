import 'package:flutter/material.dart';

class PaySmollSmollWidget extends StatelessWidget {
  final Function(String) onDetailsSubmitted;

  const PaySmollSmollWidget({
    super.key,
    required this.onDetailsSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _detailsController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pay Smoll Smoll Payment',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _detailsController,
          decoration: const InputDecoration(
            labelText: 'Payment Details',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.description, color: Color(0xFF6621DC)),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              onDetailsSubmitted(_detailsController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6621DC),
              foregroundColor: Colors.white,
            ),
            child: const Text('Proceed'),
          ),
        ),
      ],
    );
  }
}