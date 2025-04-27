import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/invoice_model.dart';

class InvoiceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _invoicesCollection = 
      FirebaseFirestore.instance.collection('invoices');

  // Get all invoices
  Stream<List<InvoiceModel>> getInvoices() {
    return _invoicesCollection
        .orderBy('invoiceDate', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => InvoiceModel.fromFirestore(doc))
              .toList();
        });
  }

  // Get invoices by status
  Stream<List<InvoiceModel>> getInvoicesByStatus(InvoiceStatus status) {
    return _firestore
        .collection('invoices')
        .where('status', isEqualTo: status.name)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => InvoiceModel.fromFirestore(doc))
              .toList();
        });
  }

  // Get overdue invoices
  Stream<List<InvoiceModel>> getOverdueInvoices() {
    final now = DateTime.now();
    return _firestore
        .collection('invoices')
        .where('status', isEqualTo: InvoiceStatus.unpaid.name)
        .where('dueDate', isLessThan: Timestamp.fromDate(now))
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => InvoiceModel.fromFirestore(doc))
              .toList();
        });
  }

  // Add a new invoice
  Future<String> addInvoice(InvoiceModel invoice) async {
    try {
      // Check if Firebase Auth is initialized
      final auth = FirebaseFirestore.instance.app.options.projectId;
      if (auth == null) {
        throw Exception('Authentication required. Please log in to add invoices.');
      }
      
      DocumentReference docRef = await _invoicesCollection.add(invoice.toMap());
      return docRef.id;
    } catch (e) {
      debugPrint('Error adding invoice: $e');
      
      // Provide user-friendly error messages
      if (e.toString().contains('permission-denied')) {
        throw Exception('Permission denied. Please make sure you are logged in with the correct account.');
      } else if (e.toString().contains('unauthenticated')) {
        throw Exception('Authentication required. Please log in again.');
      } else {
        throw Exception('Failed to add invoice: ${e.toString()}');
      }
    }
  }

  // Update an existing invoice
  Future<void> updateInvoice(InvoiceModel invoice) async {
    try {
      // Check if Firebase Auth is initialized
      final auth = FirebaseFirestore.instance.app.options.projectId;
      if (auth == null) {
        throw Exception('Authentication required. Please log in to update invoices.');
      }
      
      if (invoice.id == null) {
        throw Exception('Invoice ID is required for updates');
      }
      
      await _invoicesCollection.doc(invoice.id).update(invoice.toMap());
    } catch (e) {
      debugPrint('Error updating invoice: $e');
      
      // Provide user-friendly error messages
      if (e.toString().contains('permission-denied')) {
        throw Exception('Permission denied. Please make sure you are logged in with the correct account.');
      } else if (e.toString().contains('unauthenticated')) {
        throw Exception('Authentication required. Please log in again.');
      } else {
        throw Exception('Failed to update invoice: ${e.toString()}');
      }
    }
  }

  // Delete an invoice
  Future<void> deleteInvoice(String invoiceId) async {
    try {
      // Check if Firebase Auth is initialized
      final auth = FirebaseFirestore.instance.app.options.projectId;
      if (auth == null) {
        throw Exception('Authentication required. Please log in to delete invoices.');
      }
      
      await _invoicesCollection.doc(invoiceId).delete();
    } catch (e) {
      debugPrint('Error deleting invoice: $e');
      
      // Provide user-friendly error messages
      if (e.toString().contains('permission-denied')) {
        throw Exception('Permission denied. Please make sure you are logged in with the correct account.');
      } else if (e.toString().contains('unauthenticated')) {
        throw Exception('Authentication required. Please log in again.');
      } else {
        throw Exception('Failed to delete invoice: ${e.toString()}');
      }
    }
  }

  // Update invoice status
  Future<void> updateInvoiceStatus(String invoiceId, InvoiceStatus status) async {
    try {
      // Check if Firebase Auth is initialized
      final auth = FirebaseFirestore.instance.app.options.projectId;
      if (auth == null) {
        throw Exception('Authentication required. Please log in to update invoice status.');
      }
      
      await _invoicesCollection.doc(invoiceId).update({
        'status': status.name,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      debugPrint('Error updating invoice status: $e');
      
      // Provide user-friendly error messages
      if (e.toString().contains('permission-denied')) {
        throw Exception('Permission denied. Please make sure you are logged in with the correct account.');
      } else if (e.toString().contains('unauthenticated')) {
        throw Exception('Authentication required. Please log in again.');
      } else {
        throw Exception('Failed to update invoice status: ${e.toString()}');
      }
    }
  }
}