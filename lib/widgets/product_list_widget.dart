import 'package:flutter/material.dart';
import 'product_item_widget.dart';

class ProductListWidget extends StatelessWidget {
  final bool showAllProducts;

  const ProductListWidget({
    super.key,
    required this.showAllProducts,
  });

  @override
  Widget build(BuildContext context) {
    // This would typically come from a data source
    final demoProducts = [
      {'name': 'Laptop', 'category': 'Electronics', 'quantity': 25},
      {'name': 'Smartphone', 'category': 'Electronics', 'quantity': 8},
      {'name': 'Desk Chair', 'category': 'Furniture', 'quantity': 15},
      {'name': 'Notebook', 'category': 'Stationery', 'quantity': 50},
      {'name': 'Headphones', 'category': 'Electronics', 'quantity': 12},
    ];

    return Expanded(
      child: showAllProducts
          ? ListView.builder(
              padding: const EdgeInsets.only(top: 8.0),
              itemCount: demoProducts.length,
              itemBuilder: (context, index) {
                final product = demoProducts[index];
                return ProductItemWidget(
                  name: product['name'] as String,
                  category: product['category'] as String,
                  quantity: product['quantity'] as int,
                  showDetailedView: true,
                );
              },
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: demoProducts.length,
              itemBuilder: (context, index) {
                final product = demoProducts[index];
                return ProductItemWidget(
                  name: product['name'] as String,
                  category: product['category'] as String,
                  quantity: product['quantity'] as int,
                  showDetailedView: false,
                );
              },
            ),
    );
  }
}