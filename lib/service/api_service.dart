import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:imtapp/models/product_model.dart';

class ApiService {
  Future<void> checkAndCreateProductInApi(Product product,
      {String projeName = ""}) async {
    try {
      String apiUrl =
          'https://firestore.googleapis.com/v1/projects/${projeName}/databases/(default)/documents/products/${product.id}';

      final checkResponse = await http.get(Uri.parse(apiUrl));

      if (checkResponse.statusCode == 404) {
        final createResponse = await http.post(
          Uri.parse(
              'https://firestore.googleapis.com/v1/projects/${projeName}/databases/(default)/documents/products'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'fields': {
              'id': {'stringValue': product.id},
              'name': {'stringValue': product.name},
              'description': {'stringValue': product.description},
              'count': {'integerValue': product.count.toString()},
              'createDate': {'stringValue': product.createDate},
              'unit': {'stringValue': product.unit},
              'image': {'stringValue': product.image ?? ''},
              'status': {'booleanValue': true},
            },
          }),
        );

        if (createResponse.statusCode == 200) {
          print('Ürün başarıyla oluşturuldu.');
        } else {
          print(
              'Ürün oluşturulurken hata oluştu. HTTP ${createResponse.statusCode}');
          print(createResponse.body);
        }
      } else if (checkResponse.statusCode == 200) {
        await updateFirestoreDocument(product);
      } else {
        print(
            'Ürün kontrol edilirken hata oluştu. HTTP ${checkResponse.statusCode}');
        print(checkResponse.body);
      }
    } catch (e) {
      print('Hata: $e');
    }
  }

  Future<void> updateFirestoreDocument(Product product) async {
    try {
      String apiUrl =
          'https://firestore.googleapis.com/v1/projects/imtapp17/databases/(default)/documents/products/${product.id}?';

      Map<String, dynamic> documentData = {
        'fields': {
          'id': {'stringValue': product.id},
          'name': {'stringValue': product.name},
          'description': {'stringValue': product.description},
          'count': {'integerValue': product.count.toString()},
          'createDate': {'stringValue': product.createDate},
          'unit': {'stringValue': product.unit},
          'image': {'stringValue': product.image ?? ''},
          'status': {'booleanValue': true},
        }
      };

      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(documentData),
      );

      if (response.statusCode == 200) {
        print('Belge başarıyla güncellendi.');
      } else {
        print('Belge güncellenirken hata oluştu. HTTP ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Hata: $e');
    }
  }
}