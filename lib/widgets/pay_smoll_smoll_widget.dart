import 'package:flutter/material.dart';

class PaySmollSmollWidget extends StatefulWidget {
  final double totalAmount;
  final Function(String, String, Map<String, dynamic>) onDetailsSubmitted;

  const PaySmollSmollWidget({
    super.key,
    required this.totalAmount,
    required this.onDetailsSubmitted,
  });

  @override
  State<PaySmollSmollWidget> createState() => _PaySmollSmollWidgetState();
}

class _PaySmollSmollWidgetState extends State<PaySmollSmollWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  int _selectedInstallments = 3;
  bool _isSubmitting = false;

  final List<int> _installmentOptions = [2, 3, 4, 6];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  double get _installmentAmount {
    return widget.totalAmount / _selectedInstallments;
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final paymentDetails = {
        'totalInstallments': _selectedInstallments,
        'installmentAmount': _installmentAmount,
        'remainingAmount': widget.totalAmount,
        'paidInstallments': 0,
        'nextPaymentDue':
            DateTime.now().add(const Duration(days: 30)).toIso8601String(),
      };

      widget.onDetailsSubmitted(
        _nameController.text,
        _phoneController.text,
        paymentDetails,
      );
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
              Text(
                'Pay SLL ${widget.totalAmount.toStringAsFixed(2)} in installments',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Customer Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '076123456',
                  prefixText: '+232 ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  if (value.length != 9) {
                    return 'Phone number must be 9 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Number of Installments',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedInstallments,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items:
                    _installmentOptions.map((months) {
                      return DropdownMenuItem(
                        value: months,
                        child: Text('$months months'),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedInstallments = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Monthly Payment:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'SLL ${_installmentAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6621DC),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitPayment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF6621DC),
                  ),
                  child:
                      _isSubmitting
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Text(
                            'Confirm Payment Plan',
                            style: TextStyle(fontSize: 16),
                          ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'By confirming, you agree to pay the installments on time. Late payments may affect your credit score.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
