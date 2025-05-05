import 'package:flutter/material.dart';
import '../widgets/payment_method_widget.dart';
import '../widgets/orange_money_widget.dart';
import '../widgets/afrimoney_widget.dart';
import '../widgets/pay_smoll_smoll_widget.dart';

class PaymentMethodScreen extends StatefulWidget {
  final double totalAmount;

  const PaymentMethodScreen({
    super.key,
    required this.totalAmount,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedPaymentMethod = 'Orange Money';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handlePayment(String customerName, String phoneNumber, [Map<String, dynamic>? paymentDetails]) {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle payment based on selected method and payment details
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Processing $_selectedPaymentMethod payment...')),
      );
      Navigator.pop(context); // Return to previous screen after processing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment Method',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6621DC),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PaymentMethodWidget(
                  onPaymentMethodSelected: (method) {
                    setState(() {
                      _selectedPaymentMethod = method;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildPaymentMethodDetails(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Handle form submission
                        _handlePayment('', ''); // Will be replaced with actual values
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6621DC),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Proceed',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodDetails() {
    switch (_selectedPaymentMethod) {
      case 'Orange Money':
        return OrangeMoneyWidget(
          onDetailsSubmitted: (name, phone) => _handlePayment(name, phone),
        );
      case 'Afrimoney':
        return AfrimoneyWidget(
          onDetailsSubmitted: (name, phone) => _handlePayment(name, phone),
        );
      case 'Pay Smoll Smoll':
        return PaySmollSmollWidget(
          totalAmount: widget.totalAmount,
          onDetailsSubmitted: (name, phone, details) => _handlePayment(name, phone, details),
        );
      default:
        return const Center(
          child: Text('Please select a payment method'),
        );
    }
  }
}