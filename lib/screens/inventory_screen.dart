import 'package:flutter/material.dart';
import '../logo_widget.dart';
import '../widgets/filter_widget.dart';
import '../widgets/product_view_toggle_widget.dart';
import '../widgets/product_list_widget.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool _showAllProducts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: LogoWidget(
            size: 40, // Adjust size for the top-left corner
            animate: true, // Disable animation for static placement
          ),
        ),
        title: const Text(
          'Inventory',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Made the text bold
          ),
        ),
        actions: [],
      ),
      body: Column(
        children: [
          Container(
            height: 1.0,
            color: Colors.black, // Black horizontal line
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Manage your Inventory Items',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey, // Grey color for the text
                ),
              ),
            ),
          ),
          // Search input widget
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search inventory items...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF6621DC)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Color(0xFF6621DC)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  // Search functionality will go here
                },
              ),
            ),
          ),
          // Filter and View Toggle widgets
          Row(
            children: [
              FilterWidget(
                onPressed: () {
                  // Filter functionality will go here
                },
              ),
              const Spacer(),
              ProductViewToggleWidget(
                initialShowAllProducts: _showAllProducts,
                onViewChanged: (showAllProducts) {
                  setState(() {
                    _showAllProducts = showAllProducts;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Product list with toggle between grid and list view
          ProductListWidget(showAllProducts: _showAllProducts),
        ],
      ),
      floatingActionButton: _buildAddItemBubble(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildAddItemBubble() {
    return GestureDetector(
      onTap: () => _showAddProductModal(),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showAddProductModal() {
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Product Name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Add product logic here
                      Navigator.pop(context);
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
}