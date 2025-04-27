import 'package:flutter/material.dart';
import 'product_item_widget.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';

class ProductListWidget extends StatelessWidget {
  final bool showAllProducts;

  const ProductListWidget({super.key, required this.showAllProducts});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProductModel>>(
      stream: ProductService().getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final products = snapshot.data ?? [];

        return Expanded(
          child:
              showAllProducts
                  ? ListView.builder(
                    padding: const EdgeInsets.only(top: 8.0),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductItemWidget(
                        name: product.name,
                        category: product.category,
                        quantity: product.quantity,
                        showDetailedView: true,
                      );
                    },
                  )
                  : GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductItemWidget(
                        name: product.name,
                        category: product.category,
                        quantity: product.quantity,
                        showDetailedView: false,
                      );
                    },
                  ),
        );
      },
    );
  }
}
