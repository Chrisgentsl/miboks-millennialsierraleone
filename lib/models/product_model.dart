import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String? id; // Optional for new products
  final String name;
  final String sku;
  final int quantity;
  final double price;
  final String description;
  final String category;
  final int lowStockThreshold;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  ProductModel({
    this.id,
    required this.name,
    required this.sku,
    required this.quantity,
    required this.price,
    required this.description,
    required this.category,
    this.lowStockThreshold = 10,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) : 
    this.createdAt = createdAt ?? Timestamp.now(),
    this.updatedAt = updatedAt ?? Timestamp.now();

  // Convert ProductModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sku': sku,
      'quantity': quantity,
      'price': price,
      'description': description,
      'category': category,
      'lowStockThreshold': lowStockThreshold,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Create ProductModel from Firestore document
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      sku: data['sku'] ?? '',
      quantity: data['quantity'] ?? 0,
      price: (data['price'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      lowStockThreshold: data['lowStockThreshold'] ?? 10,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  // Create a copy of the product with updated fields
  ProductModel copyWith({
    String? id,
    String? name,
    String? sku,
    int? quantity,
    double? price,
    String? description,
    String? category,
    int? lowStockThreshold,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? Timestamp.now(),
    );
  }

  // Check if product is low on stock
  bool get isLowStock => quantity <= lowStockThreshold;
}