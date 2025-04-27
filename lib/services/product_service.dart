import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _productsCollection = 
      FirebaseFirestore.instance.collection('products');

  // Get all products
  Stream<List<ProductModel>> getProducts() {
    return _productsCollection
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ProductModel.fromFirestore(doc))
              .toList();
        });
  }

  // Get low stock products
  Stream<List<ProductModel>> getLowStockProducts() {
    return _firestore
        .collection('products')
        .snapshots()
        .map((snapshot) {
          List<ProductModel> products = snapshot.docs
              .map((doc) => ProductModel.fromFirestore(doc))
              .toList();
          
          return products.where((product) => product.isLowStock).toList();
        });
  }

  // Add a new product
  Future<String> addProduct(ProductModel product) async {
    try {
      DocumentReference docRef = await _productsCollection.add(product.toMap());
      return docRef.id;
    } catch (e) {
      debugPrint('Error adding product: $e');
      if (e.toString().contains('permission-denied')) {
        throw Exception('Permission denied. Please make sure you are logged in with the correct account.');
      } else {
        throw Exception('Failed to add product: ${e.toString()}');
      }
    }
  }

  // Update an existing product
  Future<void> updateProduct(ProductModel product) async {
    try {
      await _productsCollection.doc(product.id).update(product.toMap());
    } catch (e) {
      debugPrint('Error updating product: $e');
      if (e.toString().contains('permission-denied')) {
        throw Exception('Permission denied. Please make sure you are logged in with the correct account.');
      } else {
        throw Exception('Failed to update product: ${e.toString()}');
      }
    }
  }

  // Delete a product
  Future<void> deleteProduct(String productId) async {
    try {
      await _productsCollection.doc(productId).delete();
    } catch (e) {
      debugPrint('Error deleting product: $e');
      if (e.toString().contains('permission-denied')) {
        throw Exception('Permission denied. Please make sure you are logged in with the correct account.');
      } else {
        throw Exception('Failed to delete product: ${e.toString()}');
      }
    }
  }

  // Search products by name
  Stream<List<ProductModel>> searchProducts(String query) {
    // Convert query to lowercase for case-insensitive search
    String searchQuery = query.toLowerCase();
    
    return _productsCollection
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ProductModel.fromFirestore(doc))
              .where((product) => 
                  product.name.toLowerCase().contains(searchQuery) ||
                  product.sku.toLowerCase().contains(searchQuery) ||
                  product.category.toLowerCase().contains(searchQuery))
              .toList();
        });
  }

  // Filter products by category
  Stream<List<ProductModel>> filterProductsByCategory(String category) {
    return _productsCollection
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ProductModel.fromFirestore(doc))
              .toList();
        });
  }

  // Get all unique product categories
  Stream<List<String>> getCategories() {
    return _productsCollection.snapshots().map((snapshot) {
      final categories = snapshot.docs
          .map((doc) => doc['category'] as String?)
          .where((category) => category != null)
          .cast<String>() // Cast to non-nullable String
          .toSet()
          .toList();
      categories.sort();
      return categories;
    });
  }

  // Export inventory to CSV format
  Future<String> exportInventoryToCSV() async {
    try {
      // Check if user is authenticated
      final currentUser = FirebaseFirestore.instance.app.options.projectId;
      if (currentUser == null) {
        throw Exception('User not authenticated. Please log in again.');
      }

      // Use security rules compliant query
      QuerySnapshot snapshot = await _productsCollection
          .get(const GetOptions(serverTimestampBehavior: ServerTimestampBehavior.estimate));
      
      List<ProductModel> products = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
      
      // Create CSV header
      String csv = 'Name,SKU,Quantity,Price,Description,Category,Low Stock Threshold\n';
      
      // Add product data
      for (var product in products) {
        csv += '"${product.name}","${product.sku}",${product.quantity},${product.price},"${product.description}","${product.category}",${product.lowStockThreshold}\n';
      }
      
      return csv;
    } catch (e) {
      if (e.toString().contains('permission-denied')) {
        debugPrint('Error exporting inventory: Permission denied. Check your access rights.');
        throw Exception('Permission denied. You do not have sufficient access rights to export inventory.');
      } else {
        debugPrint('Error exporting inventory: $e');
        throw Exception('Failed to export inventory: ${e.toString()}');
      }
    }
  }

  // Import inventory from CSV format
  Future<void> importInventoryFromCSV(String csvData) async {
    try {
      // Check if Firebase Auth is initialized and user is logged in
      final auth = FirebaseFirestore.instance.app.options.projectId;
      if (auth == null) {
        throw Exception('Authentication required. Please log in to import inventory.');
      }
      
      // Skip header row
      List<String> rows = csvData.split('\n');
      if (rows.length <= 1) return;
      
      // Process each row starting from index 1 (skipping header)
      for (int i = 1; i < rows.length; i++) {
        if (rows[i].trim().isEmpty) continue;
        
        // Parse CSV row
        List<String> fields = _parseCSVRow(rows[i]);
        if (fields.length < 7) continue;
        
        // Create product model
        ProductModel product = ProductModel(
          name: fields[0],
          sku: fields[1],
          quantity: int.tryParse(fields[2]) ?? 0,
          price: double.tryParse(fields[3]) ?? 0.0,
          description: fields[4],
          category: fields[5],
          lowStockThreshold: int.tryParse(fields[6]) ?? 10,
        );
        
        // Check if product with same SKU exists
        QuerySnapshot existingProducts = await _productsCollection
            .where('sku', isEqualTo: product.sku)
            .get();
        
        if (existingProducts.docs.isNotEmpty) {
          // Update existing product
          String productId = existingProducts.docs.first.id;
          await _productsCollection.doc(productId).update(product.toMap());
        } else {
          // Add new product
          await _productsCollection.add(product.toMap());
        }
      }
    } catch (e) {
      debugPrint('Error importing inventory: $e');
      
      // Provide more user-friendly error messages
      if (e.toString().contains('permission-denied')) {
        throw Exception('Permission denied. Please make sure you are logged in with the correct account.');
      } else if (e.toString().contains('unauthenticated')) {
        throw Exception('Authentication required. Please log in again.');
      } else {
        throw Exception('Failed to import inventory: ${e.toString()}');
      }
    }
  }
  
  // Helper method to parse CSV row handling quoted fields
  List<String> _parseCSVRow(String row) {
    List<String> fields = [];
    bool inQuotes = false;
    String currentField = '';
    
    for (int i = 0; i < row.length; i++) {
      String char = row[i];
      
      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        fields.add(currentField);
        currentField = '';
      } else {
        currentField += char;
      }
    }
    
    // Add the last field
    fields.add(currentField);
    
    return fields;
  }
}