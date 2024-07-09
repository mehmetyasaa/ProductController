import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> create(
    final String name,
    final String description,
    final DateTime createDate,
    final int count,
    final String unit,
  ) async {
    try {
      await _firestore.collection('products').add({
        'name': name,
        'description': description,
        'createDate':
            createDate.toIso8601String(), // Convert DateTime to String
        'count': count,
        'unit': unit,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error creating product: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      return snapshot.docs.map((doc) {
        return {
          'name': doc['name'],
          'description': doc['description'],
          'createDate': doc['createDate'],
          'count': doc['count'],
          'unit': doc['unit'],
        };
      }).toList();
    } catch (e) {
      print('Error getting products: $e');
      throw e;
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('products').doc(id).update(data);
    } catch (e) {
      print('Error updating products: $e');
      throw e;
    }
  }

  Future<void> delete(String id) async {
    try {
      await _firestore.collection('products').doc(id).delete();
    } catch (e) {
      print('Error deleting products: $e');
      throw e;
    }
  }
}
