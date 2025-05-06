import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  bool _isSubmitting = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length != 9) {
      return 'Phone number must be 9 digits';
    }
    return null;
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // In a real app, you would integrate with Orange Money API here
      await Future.delayed(const Duration(seconds: 2)); // Simulated API call
      widget.onPhoneNumberSubmitted(_phoneController.text);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Pay SLL ${widget.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '076123456',
                  prefixText: '+232 ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                validator: _validatePhone,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitPayment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFFFF6600), // Orange Money color
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Pay Now',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'You will receive an Orange Money prompt on your phone to complete the payment.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}