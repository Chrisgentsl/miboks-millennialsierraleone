import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/product_service.dart';
import '../services/sales_service.dart';
import '../models/product_model.dart';
import '../models/sales_model.dart';
import '../screens/payment_method_screen.dart';

class SalesFormWidget extends StatefulWidget {
  const SalesFormWidget({super.key});

  @override
  _SalesFormWidgetState createState() => _SalesFormWidgetState();
}

class _SalesFormWidgetState extends State<SalesFormWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final ProductService _productService = ProductService();
  final SalesService _salesService = SalesService();
  
  List<ProductModel> _products = [];
  TextEditingController _priceController = TextEditingController();
  List<Map<String, dynamic>> _selectedProducts = [];
  bool _isGstEnabled = false;
  bool _isLoading = false;

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
    _productService.getProducts().listen((products) {
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
        'id': product.id,
        'name': product.name,
        'price': product.price,
        'quantity': quantity,
      });
    });
  }

  Future<void> _createSale(String paymentMethod, Map<String, dynamic>? paymentDetails) async {
    try {
      final saleItems = _selectedProducts.map((product) => 
        SaleItem(
          productId: product['id'],
          quantity: product['quantity'],
        )
      ).toList();

      final sale = SaleModel(
        id: '', // This will be set by Firestore
        items: saleItems,
        timestamp: DateTime.now(),
        status: paymentMethod == 'Pay Smoll Smoll' ? 'pending' : 'completed',
        paymentMethod: paymentMethod,
        paymentDetails: paymentDetails,
        totalAmount: _calculateTotal(),
      );

      await _salesService.createSale(sale);
      
      if (mounted) {
        Navigator.of(context).pop(); // Close the form
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sale completed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating sale: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onProceed() async {
    if (_selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one product'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Navigate to payment method screen
    if (mounted) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentMethodScreen(
            totalAmount: _calculateTotal(),
            onPaymentComplete: (paymentMethod, paymentDetails) async {
              await _createSale(paymentMethod, paymentDetails);
            },
          ),
        ),
      );

      setState(() {
        _isLoading = false;
      });

      if (result == true) {
        Navigator.pop(context); // Close the form after successful payment
      }
    }
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
            if (_isLoading)
              const Center(
                child: SpinKitCircle(
                  color: Color(0xFF6621DC),
                  size: 50.0,
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onProceed,
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
    );
  }
}