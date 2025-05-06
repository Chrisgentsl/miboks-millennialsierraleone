import 'package:cloud_firestore/cloud_firestore.dart';

class SaleModel {
  final String id;
  final List<SaleItem> items;
  final DateTime timestamp;
  final String status;
  final String? paymentMethod;
  final Map<String, dynamic>? paymentDetails;
  final double totalAmount;

  SaleModel({
    required this.id,
    required this.items,
    required this.timestamp,
    required this.status,
    this.paymentMethod,
    this.paymentDetails,
    required this.totalAmount,
  });

  factory SaleModel.fromMap(Map<String, dynamic> data, String id) {
    return SaleModel(
      id: id,
      items:
          (data['items'] as List<dynamic>)
              .map((item) => SaleItem.fromMap(item))
              .toList(),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
      paymentMethod: data['paymentMethod'],
      paymentDetails: data['paymentDetails'],
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
      'timestamp': timestamp,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentDetails': paymentDetails,
      'totalAmount': totalAmount,
    };
  }

  SaleModel copyWith({
    String? id,
    List<SaleItem>? items,
    DateTime? timestamp,
    String? status,
    String? paymentMethod,
    Map<String, dynamic>? paymentDetails,
    double? totalAmount,
  }) {
    return SaleModel(
      id: id ?? this.id,
      items: items ?? this.items,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}

class SaleItem {
  final String productId;
  final int quantity;

  SaleItem({required this.productId, required this.quantity});

  factory SaleItem.fromMap(Map<String, dynamic> data) {
    return SaleItem(productId: data['productId'], quantity: data['quantity']);
  }

  Map<String, dynamic> toMap() {
    return {'productId': productId, 'quantity': quantity};
  }
}
