import 'package:flutter/material.dart';
import '../widgets/payment_method_widget.dart';
import '../widgets/orange_money_payment_widget.dart';
import '../widgets/pay_smoll_smoll_widget.dart';

class PaymentMethodScreen extends StatefulWidget {
  final double totalAmount;
  final Function(String, Map<String, dynamic>?) onPaymentComplete;

  const PaymentMethodScreen({
    super.key,
    required this.totalAmount,
    required this.onPaymentComplete,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedPaymentMethod = '';

  Widget _buildPaymentWidget() {
    switch (_selectedPaymentMethod) {
      case 'Orange Money':
        return OrangeMoneyPaymentWidget(
          amount: widget.totalAmount,
          onPhoneNumberSubmitted: (name, phoneNumber) {
            widget.onPaymentComplete('Orange Money', {
              'customerName': name,
              'phoneNumber': phoneNumber,
              'amount': widget.totalAmount,
            });
          },
        );
      case 'Pay Smoll Smoll':
        return PaySmollSmollWidget(
          totalAmount: widget.totalAmount,
          onDetailsSubmitted: (name, phone, details) {
            widget.onPaymentComplete('Pay Smoll Smoll', {
              'customerName': name,
              'phoneNumber': phone,
              ...details,
            });
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            PaymentMethodWidget(
              onPaymentMethodSelected: (method) {
                setState(() {
                  _selectedPaymentMethod = method;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildPaymentWidget(),
          ],
        ),
      ),
    );
  }
}
