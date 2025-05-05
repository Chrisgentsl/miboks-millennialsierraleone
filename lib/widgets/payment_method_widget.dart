import 'package:flutter/material.dart';

class PaymentMethodWidget extends StatefulWidget {
  final Function(String) onPaymentMethodSelected;

  const PaymentMethodWidget({
    super.key,
    required this.onPaymentMethodSelected,
  });

  @override
  State<PaymentMethodWidget> createState() => _PaymentMethodWidgetState();
}

class _PaymentMethodWidgetState extends State<PaymentMethodWidget> {
  String _selectedPaymentMethod = 'Orange Money';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Payment Method',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          RadioListTile<String>(
            title: const Text('Orange Money'),
            value: 'Orange Money',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
                widget.onPaymentMethodSelected(value);
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Afrimoney'),
            value: 'Afrimoney',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
                widget.onPaymentMethodSelected(value);
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Pay Smoll Smoll'),
            value: 'Pay Smoll Smoll',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
                widget.onPaymentMethodSelected(value);
              });
            },
          ),
        ],
      ),
    );
  }
}