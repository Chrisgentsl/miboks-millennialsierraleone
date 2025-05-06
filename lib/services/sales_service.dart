import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/sales_model.dart';
import 'auth_service.dart';

class SalesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  Future<void> createSale(SaleModel sale) async {
    try {
      // First ensure we have a fresh auth token
      await _authService.refreshToken();
      final user = _authService.currentUser;
      if (user == null) {
        throw Exception('Authentication required');
      }

      await _firestore.runTransaction((transaction) async {
        // First, verify all products and their quantities
        for (var item in sale.items) {
          final productRef = _firestore
              .collection('products')
              .doc(item.productId);
          final productDoc = await transaction.get(productRef);

          if (!productDoc.exists) {
            throw Exception('Product ${item.productId} not found');
          }

          final currentQuantity = productDoc.data()?['quantity'] ?? 0;
          if (currentQuantity < item.quantity) {
            throw Exception('Insufficient stock for product ${item.productId}');
          }
        }

        // Create the sale document with user ID
        final saleRef = _firestore.collection('sales').doc();
        final saleData = {
          ...sale.toMap(),
          'userId': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'id': saleRef.id,
        };
        transaction.set(saleRef, saleData);

        // Update product quantities
        for (var item in sale.items) {
          final productRef = _firestore
              .collection('products')
              .doc(item.productId);
          transaction.update(productRef, {
            'quantity': FieldValue.increment(-item.quantity),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      });
    } on FirebaseAuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception(
          'Permission denied: Please ensure you are logged in with the correct account',
        );
      }
      throw Exception('Failed to create sale: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create sale: $e');
    }
  }

  Stream<List<SaleModel>> getSales() {
    final user = _authService.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('sales')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SaleModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  Future<List<SaleModel>> getSalesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final user = _authService.currentUser;
    if (user == null) {
      return [];
    }

    final snapshot =
        await _firestore
            .collection('sales')
            .where('userId', isEqualTo: user.uid)
            .where('timestamp', isGreaterThanOrEqualTo: start)
            .where('timestamp', isLessThanOrEqualTo: end)
            .get();

    return snapshot.docs
        .map((doc) => SaleModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> updateSaleStatus(String saleId, String status) async {
    final user = _authService.currentUser;
    if (user == null) {
      throw Exception('Authentication required');
    }

    try {
      await _firestore.collection('sales').doc(saleId).update({
        'status': status,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update sale status: ${e.toString()}');
    }
  }

  // Get today's sales
  Stream<List<SaleModel>> getTodaySales() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _firestore
        .collection('sales')
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .where('timestamp', isLessThan: endOfDay)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SaleModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Get weekly sales
  Stream<List<SaleModel>> getWeeklySales() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startDate = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );

    return _firestore
        .collection('sales')
        .where('timestamp', isGreaterThanOrEqualTo: startDate)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SaleModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Get monthly sales
  Stream<List<SaleModel>> getMonthlySales() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    return _firestore
        .collection('sales')
        .where('timestamp', isGreaterThanOrEqualTo: startOfMonth)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SaleModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Get due payments
  Stream<List<SaleModel>> getDuePayments() {
    return _firestore
        .collection('sales')
        .where('paymentMethod', isEqualTo: 'Pay Smoll Smoll')
        .where('status', isEqualTo: 'pending')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SaleModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Get payment method statistics
  Stream<Map<String, int>> getPaymentMethodStats() {
    return _firestore.collection('sales').snapshots().map((snapshot) {
      Map<String, int> stats = {
        'Orange Money': 0,
        'Afrimoney': 0,
        'Pay Smoll Smoll': 0,
      };

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final method = data['paymentMethod'] as String;
        stats[method] = (stats[method] ?? 0) + 1;
      }

      return stats;
    });
  }

  double calculateTotalAmount(List<SaleModel> sales) {
    return sales.fold(0, (sum, sale) => sum + sale.totalAmount);
  }
}
