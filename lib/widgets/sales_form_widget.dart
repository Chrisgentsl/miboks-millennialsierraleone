import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';

class SalesFormWidget extends StatefulWidget {
  const SalesFormWidget({super.key});

  @override
  _SalesFormWidgetState createState() => _SalesFormWidgetState();
}

class _SalesFormWidgetState extends State<SalesFormWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  List<ProductModel> _products = [];
  ProductModel? _selectedProduct;
  TextEditingController _priceController = TextEditingController();
  List<Map<String, dynamic>> _selectedProducts = [];
  bool _isGstEnabled = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    _fetchProducts();
  }

  void _fetchProducts() {
    ProductService().getProducts().listen((products) {
      setState(() {
        _products = products;
      });
    });
  }

  double _calculateSubtotal() {
    return _selectedProducts.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  double _calculateGst() {
    return _isGstEnabled ? _calculateSubtotal() * 0.15 : 0;
  }

  double _calculateTotal() {
    return _calculateSubtotal() + _calculateGst();
  }

  void _addProduct(ProductModel product, int quantity) {
    setState(() {
      _selectedProducts.add({
        'name': product.name,
        'price': product.price,
        'quantity': quantity,
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shopping_cart, color: const Color(0xFF6621DC)),
                const SizedBox(width: 8),
                const Text(
                  'Sales Form',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6621DC),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ProductModel>(
              decoration: const InputDecoration(
                labelText: 'Select Product',
                border: OutlineInputBorder(),
              ),
              items: _products.map((product) {
                return DropdownMenuItem(
                  value: product,
                  child: Text(product.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  final quantityController = TextEditingController();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Add ${value.name}'),
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
                                _addProduct(value, quantity);
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
            ),
            const SizedBox(height: 16),
            if (_selectedProducts.isNotEmpty) ...[
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _selectedProducts.length,
                itemBuilder: (context, index) {
                  final item = _selectedProducts[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text('Quantity: ${item['quantity']}'),
                    trailing: Text('SLL ${(item['price'] * item['quantity']).toStringAsFixed(2)}'),
                  );
                },
              ),
              const Divider(),
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
              Text('Subtotal: SLL ${_calculateSubtotal().toStringAsFixed(2)}'),
              Text('GST: SLL ${_calculateGst().toStringAsFixed(2)}'),
              Text(
                'Total: SLL ${_calculateTotal().toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6621DC),
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle form submission
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
                  'Submit',
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