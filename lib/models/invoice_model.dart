import 'package:miboks/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum InvoiceStatus {
  paid,
  unpaid,
  overdue,
}

class InvoiceItem {
  final String productName;
  final String description;
  final int quantity;
  final double price;
  final double amount;

  InvoiceItem({
    required this.productName,
    required this.description,
    required this.quantity,
    required this.price,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'description': description,
      'quantity': quantity,
      'price': price,
      'amount': amount,
    };
  }

  factory InvoiceItem.fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      productName: map['productName'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: map['price'] ?? 0.0,
      amount: map['amount'] ?? 0.0,
    );
  }

  factory InvoiceItem.fromProduct(ProductModel product, int quantity) {
    return InvoiceItem(
      productName: product.name,
      description: product.description,
      quantity: quantity,
      price: product.price,
      amount: product.price * quantity,
    );
  }
}

class InvoiceModel {
  final String? id;
  final String invoiceNumber;
  final String companyName;
  final DateTime invoiceDate;
  final String clientName;
  final String clientEmail;
  final List<InvoiceItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final InvoiceStatus status;
  final DateTime dueDate;
  final String? pdfUrl;
  final String userId;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  InvoiceModel({
    this.id,
    required this.invoiceNumber,
    required this.companyName,
    required this.invoiceDate,
    required this.clientName,
    required this.clientEmail,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.status,
    required this.dueDate,
    required this.userId,
    this.pdfUrl,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) : 
    this.createdAt = createdAt ?? Timestamp.now(),
    this.updatedAt = updatedAt ?? Timestamp.now();

  Map<String, dynamic> toMap() {
    return {
      'invoiceNumber': invoiceNumber,
      'companyName': companyName,
      'invoiceDate': Timestamp.fromDate(invoiceDate),
      'clientName': clientName,
      'clientEmail': clientEmail,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'status': status.name,
      'dueDate': Timestamp.fromDate(dueDate),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'pdfUrl': pdfUrl,
      'userId': userId,
    };
  }

  factory InvoiceModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    List<InvoiceItem> items = [];
    if (data['items'] != null) {
      items = (data['items'] as List).map((item) => InvoiceItem.fromMap(item)).toList();
    }

    return InvoiceModel(
      id: doc.id,
      invoiceNumber: data['invoiceNumber'] ?? '',
      companyName: data['companyName'] ?? '',
      invoiceDate: (data['invoiceDate'] as Timestamp).toDate(),
      clientName: data['clientName'] ?? '',
      clientEmail: data['clientEmail'] ?? '',
      items: items,
      subtotal: (data['subtotal'] ?? 0).toDouble(),
      tax: (data['tax'] ?? 0).toDouble(),
      total: (data['total'] ?? 0).toDouble(),
      status: InvoiceStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => InvoiceStatus.unpaid,
      ),
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      pdfUrl: data['pdfUrl'],
      userId: data['userId'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  InvoiceModel copyWith({
    String? id,
    String? invoiceNumber,
    String? companyName,
    DateTime? invoiceDate,
    String? clientName,
    String? clientEmail,
    List<InvoiceItem>? items,
    double? subtotal,
    double? tax,
    double? total,
    InvoiceStatus? status,
    DateTime? dueDate,
    String? pdfUrl,
    String? userId,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      companyName: companyName ?? this.companyName,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      clientName: clientName ?? this.clientName,
      clientEmail: clientEmail ?? this.clientEmail,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? Timestamp.now(),
    );
  }

  bool get isOverdue => DateTime.now().isAfter(dueDate) && status == InvoiceStatus.unpaid;
}