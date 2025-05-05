import 'package:flutter/material.dart';
import '../widgets/payment_method_widget.dart';
import '../widgets/orange_money_widget.dart';
import '../widgets/afrimoney_widget.dart';
import '../widgets/pay_smoll_smoll_widget.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedPaymentMethod = 'Orange Money';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Method',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6621DC),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            Expanded(
              child: _buildPaymentMethodDetails(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodDetails() {
    switch (_selectedPaymentMethod) {
      case 'Orange Money':
        return OrangeMoneyWidget(
          onPhoneNumberSubmitted: (phoneNumber) {
            // Handle Orange Money payment
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Orange Money payment initiated for $phoneNumber')),
            );
          },
        );
      case 'Afrimoney':
        return AfrimoneyWidget(
          onPhoneNumberSubmitted: (phoneNumber) {
            // Handle Afrimoney payment
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Afrimoney payment initiated for $phoneNumber')),
            );
          },
        );
      case 'Pay Smoll Smoll':
        return PaySmollSmollWidget(
          onDetailsSubmitted: (details) {
            // Handle Pay Smoll Smoll payment
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Pay Smoll Smoll payment initiated with details: $details')),
            );
          },
        );
      default:
        return const Center(
          child: Text('Please select a payment method'),
        );
    }
  }
}