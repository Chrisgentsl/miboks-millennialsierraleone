import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String accountType; // 'vendor' or 'supplier'
  final String fullName;
  final String businessName;
  final String address;
  final String phoneNumber;
  final String email;
  final Timestamp createdAt;

  UserModel({
    required this.id,
    required this.accountType,
    required this.fullName,
    required this.businessName,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.createdAt,
  });

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountType': accountType,
      'fullName': fullName,
      'businessName': businessName,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'createdAt': createdAt,
    };
  }

  // Create UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return UserModel(
      id: doc.id,
      accountType: data['accountType'] ?? '',
      fullName: data['fullName'] ?? '',
      businessName: data['businessName'] ?? '',
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      email: data['email'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}