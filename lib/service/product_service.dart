import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imtapp/models/product_model.dart';

class ProductsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Product> create(
    final String name,
    final String description,
    final DateTime createDate,
    final int count,
    final String unit,
  ) async {
    String formattedCreateDate =
        "${createDate.day}/${createDate.month}/${createDate.year}";
    try {
      DocumentReference docRef = await _firestore.collection('products').add({
        'name': name,
        'description': description,
        'createDate': formattedCreateDate,
        'count': count,
        'unit': unit,
        'createdAt': FieldValue.serverTimestamp(),
      });

      DocumentSnapshot doc = await docRef.get();
      return Product(
        name: name,
        description: description,
        createDate: formattedCreateDate,
        count: count,
        unit: unit,
      );
    } catch (e) {
      print('Error creating product: $e');
      throw e;
    }
  }
}
