import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/invoice_form_widget.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ProductModel> _inventoryItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchProducts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Invoices')),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF6621DC),
            labelColor: const Color(0xFF6621DC),
            unselectedLabelColor: Colors.grey,
            tabs: const [Tab(text: 'All Invoices'), Tab(text: 'Create New')],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                StreamBuilder(
                  stream:
                      FirebaseFirestore.instance
                          .collection('invoices')
                          .where('userId', isEqualTo: userId)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final invoices = snapshot.data?.docs ?? [];

                    return ListView.builder(
                      itemCount: invoices.length,
                      itemBuilder: (context, index) {
                        final invoice = invoices[index].data();
                        return ListTile(
                          title: Text(
                            invoice['invoiceNumber'] ?? 'Unnamed Invoice',
                          ),
                          subtitle: Text('Total: ${invoice['total']}'),
                        );
                      },
                    );
                  },
                ),
                SingleChildScrollView(child: InvoiceFormWidget()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddItemBubble() {
    return GestureDetector(
      onTap: () => _showAddProductModal(),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF6621DC), // Updated to primary color
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddProductModal() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController stockController = TextEditingController();

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Add Product',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: stockController,
                    decoration: const InputDecoration(
                      labelText: 'Stock Quantity',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final String name = nameController.text;
                      final double? price = double.tryParse(
                        priceController.text,
                      );
                      final String description = descriptionController.text;
                      final int? stock = int.tryParse(stockController.text);

                      if (name.isNotEmpty &&
                          price != null &&
                          description.isNotEmpty &&
                          stock != null) {
                        try {
                          await FirebaseFirestore.instance
                              .collection('product')
                              .add({
                                'name': name,
                                'price': price,
                                'description': description,
                                'stock': stock,
                                'createdAt': FieldValue.serverTimestamp(),
                              });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Product added successfully!'),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to add product: $e'),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all fields correctly.'),
                          ),
                        );
                      }
                    },
                    child: const Text('Add Product'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _fetchProducts() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('product').get();
      setState(() {
        _inventoryItems =
            snapshot.docs
                .map((doc) => ProductModel.fromFirestore(doc))
                .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching products: $e')));
    }
  }
}

class ProductModel {
  final String name;
  final double price;
  final String description;
  final int stock;

  ProductModel({
    required this.name,
    required this.price,
    required this.description,
    required this.stock,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      stock: data['stock'] ?? 0,
    );
  }
}
