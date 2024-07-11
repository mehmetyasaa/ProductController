import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imtapp/firebase/auth.dart';
import 'package:imtapp/models/product_model.dart';

class ProductsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> create(
    final String userId,
    final String name,
    final String description,
    final DateTime createDate,
    final int count,
    final String unit,
  ) async {
    String formattedCreateDate =
        "${createDate.day}/${createDate.month}/${createDate.year}";
    try {
      final newProduct = {
        "name": name,
        "description": description,
        "count": count,
        "createDate": formattedCreateDate,
        "unit": unit,
      };

      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _db.collection("users").doc(userId).get();

      if (userDoc.exists) {
        List<dynamic>? currentProducts =
            userDoc.data()?["products"] as List<dynamic>?;
        if (currentProducts == null) {
          currentProducts = [];
        }

        currentProducts.add(newProduct);

        await _db
            .collection("users")
            .doc(userId)
            .update({"products": currentProducts});
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print("Error creating product: $e");
    }
  }
}
