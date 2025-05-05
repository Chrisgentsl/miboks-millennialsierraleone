import 'package:flutter/material.dart';

class PaySmollSmollWidget extends StatefulWidget {
  final Function(String, String, Map<String, dynamic>) onDetailsSubmitted;
  final double totalAmount;

  const PaySmollSmollWidget({
    super.key,
    required this.onDetailsSubmitted,
    required this.totalAmount,
  });

  @override
  State<PaySmollSmollWidget> createState() => _PaySmollSmollWidgetState();
}

class _PaySmollSmollWidgetState extends State<PaySmollSmollWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _installmentAmountController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  
  String _selectedPaymentType = 'Monthly';
  int _numberOfInstallments = 1;
  double _installmentAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateInstallment();
  }

  void _calculateInstallment() {
    int duration = int.tryParse(_durationController.text) ?? 1;
    if (duration < 1) duration = 1;
    
    setState(() {
      _numberOfInstallments = duration;
      _installmentAmount = widget.totalAmount / duration;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Customer Name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person, color: Color(0xFF6621DC)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter customer name';
            }
            return null;
          },
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
            return null;
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Total Amount: SLL ${widget.totalAmount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Monthly'),
                value: 'Monthly',
                groupValue: _selectedPaymentType,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentType = value!;
                    _calculateInstallment();
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Daily'),
                value: 'Daily',
                groupValue: _selectedPaymentType,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentType = value!;
                    _calculateInstallment();
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _durationController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: _selectedPaymentType == 'Monthly' 
              ? 'Number of Months' 
              : 'Number of Days',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF6621DC)),
          ),
          onChanged: (_) => _calculateInstallment(),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _installmentAmountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: _selectedPaymentType == 'Monthly' 
              ? 'Amount per Month' 
              : 'Amount per Day',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.money, color: Color(0xFF6621DC)),
          ),
          onChanged: (value) {
            double amount = double.tryParse(value) ?? 0.0;
            if (amount > 0) {
              setState(() {
                _installmentAmount = amount;
                _numberOfInstallments = (widget.totalAmount / amount).ceil();
              });
            }
          },
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Summary',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Payment Type: $_selectedPaymentType',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Number of Installments: $_numberOfInstallments',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '${_selectedPaymentType == 'Monthly' ? 'Monthly' : 'Daily'} Amount: SLL ${_installmentAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Total Amount: SLL ${widget.totalAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _installmentAmountController.dispose();
    _durationController.dispose();
    super.dispose();
  }
}