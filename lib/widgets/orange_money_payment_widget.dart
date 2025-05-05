import 'package:flutter/material.dart';

class OrangeMoneyPaymentWidget extends StatefulWidget {
  final double amount;
  final Function(String) onPhoneNumberSubmitted;

  const OrangeMoneyPaymentWidget({
    super.key,
    required this.amount,
    required this.onPhoneNumberSubmitted,
  });

  @override
  State<OrangeMoneyPaymentWidget> createState() => _OrangeMoneyPaymentWidgetState();
}

class _OrangeMoneyPaymentWidgetState extends State<OrangeMoneyPaymentWidget> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^\d{8,9}$').hasMatch(value)) {
      return 'Enter a valid Sierra Leone phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFF6600), width: 1),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/orange-money-logo.png',
                  height: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.account_balance_wallet,
                      size: 40,
                      color: Color(0xFFFF6600),
                    );
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  'Orange Money Payment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Amount to Pay: SLL ${widget.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Orange Money Number',
                hintText: 'Enter your Orange Money number',
                prefixIcon: Icon(Icons.phone_android, color: Color(0xFFFF6600)),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF6600)),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: _validatePhoneNumber,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onPhoneNumberSubmitted(_phoneController.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6600),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Proceed with Payment',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You will receive a prompt on your phone to complete the payment',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}