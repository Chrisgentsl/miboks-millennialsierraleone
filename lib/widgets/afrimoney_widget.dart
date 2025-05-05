import 'package:flutter/material.dart';

class AfrimoneyWidget extends StatelessWidget {
  final Function(String, String) onDetailsSubmitted;

  const AfrimoneyWidget({
    super.key,
    required this.onDetailsSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
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
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Customer Name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person, color: Color(0xFF6621DC)),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.number,
          maxLength: 8,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone, color: Color(0xFF6621DC)),
            prefixText: '+232 ',
            counterText: '',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a phone number';
            }
            if (value.length != 8) {
              return 'Phone number must be 8 digits';
            }
            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
              return 'Phone number must contain only digits';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}