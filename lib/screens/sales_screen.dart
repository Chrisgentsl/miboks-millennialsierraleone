import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../logo_widget.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final List<Map<String, dynamic>> _selectedItems = [];
  String _paymentMethod = 'Orange Money';
  bool _isGstEnabled = false;

  double _calculateSubtotal() {
    return _selectedItems.fold(0, (sum, item) => sum + item['amount']);
  }

  double _calculateGst() {
    return _isGstEnabled ? _calculateSubtotal() * 0.15 : 0;
  }

  double _calculateTotal() {
    return _calculateSubtotal() + _calculateGst();
  }

  void _addItem(Map<String, dynamic> item) {
    setState(() {
      _selectedItems.add(item);
    });
  }

  void _submitSale() async {
    if (_formKey.currentState!.validate()) {
      final sale = {
        'customerName': _customerNameController.text,
        'phoneNumber': _phoneNumberController.text,
        'address': _addressController.text,
        'items': _selectedItems,
        'paymentMethod': _paymentMethod,
        'gst': _isGstEnabled ? 15 : 0,
        'total': _calculateTotal(),
        'createdAt': Timestamp.now(),
      };

      try {
        await FirebaseFirestore.instance.collection('sales').add(sale);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sale added successfully!')),
        );
        setState(() {
          _selectedItems.clear();
          _customerNameController.clear();
          _phoneNumberController.clear();
          _addressController.clear();
          _isGstEnabled = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add sale: $e')),
        );
      }
    }
  }

  void _showAddSaleForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _customerNameController,
                      decoration: const InputDecoration(
                        labelText: 'Customer Name',
                        border: OutlineInputBorder(),
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
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('products').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        final products = snapshot.data?.docs ?? [];

                        return DropdownButtonFormField<Map<String, dynamic>>(
                          decoration: const InputDecoration(
                            labelText: 'Select Product',
                            border: OutlineInputBorder(),
                          ),
                          items: products.map((doc) {
                            final product = doc.data() as Map<String, dynamic>;
                            return DropdownMenuItem(
                              value: product,
                              child: Text(product['name'] ?? 'Unnamed Product'),
                            );
                          }).toList(),
                          onChanged: (selectedProduct) {
                            if (selectedProduct != null) {
                              final quantityController = TextEditingController();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Add Quantity for ${selectedProduct['name']}'),
                                    content: TextFormField(
                                      controller: quantityController,
                                      decoration: const InputDecoration(
                                        labelText: 'Quantity',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          final quantity = int.tryParse(quantityController.text) ?? 0;
                                          if (quantity > 0) {
                                            _addItem({
                                              'name': selectedProduct['name'],
                                              'price': selectedProduct['price'],
                                              'quantity': quantity,
                                              'amount': selectedProduct['price'] * quantity,
                                            });
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text('Add'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Enable GST (15%)'),
                        Switch(
                          value: _isGstEnabled,
                          onChanged: (value) {
                            setState(() {
                              _isGstEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Subtotal: ${_calculateSubtotal().toStringAsFixed(2)}'),
                    Text('GST: ${_calculateGst().toStringAsFixed(2)}'),
                    Text('Total: ${_calculateTotal().toStringAsFixed(2)}'),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _paymentMethod,
                      decoration: const InputDecoration(
                        labelText: 'Payment Method',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Orange Money', child: Text('Orange Money')),
                        DropdownMenuItem(value: 'Africell Money', child: Text('Africell Money')),
                        DropdownMenuItem(value: 'Credit', child: Text('Credit')),
                        DropdownMenuItem(value: 'Pay Smoll Smoll', child: Text('Pay Smoll Smoll')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitSale,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A1B9A),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50), // Full width button
                      ),
                      child: MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            // Change color on hover
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            // Revert color on hover exit
                          });
                        },
                        child: const Text('Submit Sale'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddItemBubble() {
    return GestureDetector(
      onTap: _showAddSaleForm,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF6621DC),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: LogoWidget(
            size: 40,
            animate: false,
          ),
        ),
        title: const Text('Sales'),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: _buildAddItemBubble(),
          ),
        ],
      ),
    );
  }
}