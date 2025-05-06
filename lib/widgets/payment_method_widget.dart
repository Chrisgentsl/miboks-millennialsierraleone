import 'package:flutter/material.dart';

class PaymentMethodWidget extends StatelessWidget {
  final Function(String) onPaymentMethodSelected;

  const PaymentMethodWidget({
    super.key,
    required this.onPaymentMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Payment Method',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildPaymentMethodCard(
          'Orange Money',
          'assets/images/orange-money-logo.png',
          'Pay with Orange Money',
          context,
        ),
        const SizedBox(height: 12),
        _buildPaymentMethodCard(
          'Pay Smoll Smoll',
          'assets/images/cash.png',
          'Pay in installments',
          context,
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard(
    String method,
    String imageAsset,
    String description,
    BuildContext context,
  ) {
    return InkWell(
      onTap: () => onPaymentMethodSelected(method),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              imageAsset,
              width: 48,
              height: 48,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}