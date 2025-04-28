import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/invoice_model.dart';

class InvoiceFormWidget extends StatefulWidget {
  const InvoiceFormWidget({super.key});

  @override
  _InvoiceFormWidgetState createState() => _InvoiceFormWidgetState();
}

class _InvoiceFormWidgetState extends State<InvoiceFormWidget> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _billToController = TextEditingController();
  final TextEditingController _clientEmailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  late String _invoiceNumber;
  DateTime? _selectedDate;
  bool _isGstEnabled = false;
  final List<Map<String, dynamic>> _items = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _generateInvoiceNumber();
  }

  void _generateInvoiceNumber() {
    final random = Random();
    _invoiceNumber =
        'INV-${random.nextInt(900000) + 100000}'; // Generates a 6-digit random number
  }

  double _calculateSubtotal() {
    return _items.fold(0, (sum, item) => sum + item['amount']);
  }

  double _calculateGst() {
    return _isGstEnabled ? _calculateSubtotal() * 0.15 : 0;
  }

  double _calculateTotal() {
    return _calculateSubtotal() + _calculateGst();
  }

  void _addItem() {
    final description = _descriptionController.text;
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final amount = quantity * price;

    if (description.isNotEmpty && quantity > 0 && price > 0) {
      setState(() {
        _items.add({
          'description': description,
          'quantity': quantity,
          'price': price,
          'amount': amount,
        });
        _descriptionController.clear();
        _quantityController.clear();
        _priceController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all item fields correctly.')),
      );
    }
  }

  void _createInvoice() async {
    if (_formKey.currentState!.validate()) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated. Please log in.')),
        );
        return;
      }

      if (_items.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one item to the invoice.')),
        );
        return;
      }

      final invoice = InvoiceModel(
        invoiceNumber: _invoiceNumber,
        companyName: _companyNameController.text,
        invoiceDate: _selectedDate ?? DateTime.now(),
        clientName: _billToController.text,
        clientEmail: _clientEmailController.text,
        items: _items.map((item) => InvoiceItem.fromMap(item)).toList(),
        subtotal: _calculateSubtotal(),
        tax: _calculateGst(),
        total: _calculateTotal(),
        status: InvoiceStatus.unpaid,
        dueDate: _selectedDate?.add(const Duration(days: 30)) ?? DateTime.now().add(const Duration(days: 30)),
        userId: userId,
      );

      try {
        await FirebaseFirestore.instance.collection('invoices').add(invoice.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invoice created successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create invoice: $e')),
        );
      }
    }
  }

  Widget _buildItemInputRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Quantity',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Price',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Color(0xFF6621DC)),
          onPressed: _addItem,
        ),
      ],
    );
  }

  Widget _buildItemList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4,
          child: ListTile(
            title: Text(
              item['description'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Quantity: ${item['quantity']} x Price: ${item['price']}',
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: Text(
              'Amount: ${item['amount'].toStringAsFixed(2)}',
              style: const TextStyle(
                  color: Color(0xFF6621DC), fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? const Color(0xFF6621DC) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Invoice',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6621DC),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _companyNameController,
              decoration: InputDecoration(
                labelText: 'Company/Business Name',
                hintText: 'Enter company or business name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _invoiceNumber,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Invoice #',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'Enter date (e.g., YYYY-MM-DD)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              readOnly: true,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                    _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _billToController,
              decoration: InputDecoration(
                labelText: 'Bill To',
                hintText: 'Enter client name or company',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _clientEmailController,
              decoration: InputDecoration(
                labelText: 'Client Email',
                hintText: 'Enter client email address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dueDateController,
              decoration: InputDecoration(
                labelText: 'Due Date',
                hintText: 'Select due date',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              readOnly: true,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                    _dueDateController.text = DateFormat('yyyy-MM-dd').format(picked);
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6621DC),
              ),
            ),
            const SizedBox(height: 8),
            _buildItemInputRow(),
            const SizedBox(height: 16),
            _buildItemList(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Enable GST (15%)',
                  style: TextStyle(fontSize: 16),
                ),
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
            _buildSummaryRow(
                'Subtotal:', _calculateSubtotal().toStringAsFixed(2)),
            _buildSummaryRow('GST:', _calculateGst().toStringAsFixed(2)),
            _buildSummaryRow('Total:', _calculateTotal().toStringAsFixed(2),
                isBold: true),
            const Divider(color: Colors.grey),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _createInvoice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6621DC),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Create Invoice',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductModel {
  final String id;
  final String name;
  final double price;

  ProductModel({required this.id, required this.name, required this.price});

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
    );
  }
}
