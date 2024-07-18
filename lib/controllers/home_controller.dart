import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:imtapp/firebase/auth.dart';
import 'package:imtapp/models/product_model.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  RxList<Product> productList = RxList<Product>([]);
  RxList<Product> filteredProducts = RxList<Product>([]);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<Product, String> productDocumentIds = {};

  HomeController() {
    Auth().authStateChanges.listen((User? user) {
      if (user == null) {
        clearProducts();
      } else {
        fetchProducts();
      }
    });
  }

  Future<Product> fetchLatestProduct(String productId) async {
    User? currentUser = Auth().currentUser;
    if (currentUser == null) {
      throw Exception("No user is currently signed in");
    }
    String uid = currentUser.uid;

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

    if (userData.containsKey('products')) {
      List<dynamic> userProducts = userData['products'];

      for (var productData in userProducts) {
        if (productData['id'] == productId) {
          return Product(
            id: productData['id'],
            name: productData['name'],
            description: productData['description'],
            createDate: productData['createDate'],
            count: productData['count'],
            unit: productData['unit'],
            status: productData['status'],
            image: productData['image'],
          );
        }
      }
    }
    throw Exception("Product not found");
  }

  void clearProducts() {
    productList.clear();
    filteredProducts.clear();
    productDocumentIds.clear();
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void deleteProduct(Product product) async {
    User? currentUser = Auth().currentUser;
    if (currentUser == null) {
      return;
    }
    String uid = currentUser.uid;

    DocumentReference userDocRef = _firestore.collection('users').doc(uid);
    DocumentSnapshot userDoc = await userDocRef.get();

    List<dynamic> userProducts =
        (userDoc.data() as Map<String, dynamic>)['products'];
    userProducts.removeWhere((prod) =>
        prod['name'] == product.name &&
        prod['description'] == product.description &&
        prod['createDate'] == product.createDate &&
        prod['count'] == product.count &&
        prod['unit'] == product.unit &&
        prod['image'] == product.image);

    await userDocRef.update({'products': userProducts});

    productList.remove(product);
    filterSearchResult('');
  }

  void editProduct(Product product) {
    // Implement your edit logic here
  }

  void fetchProducts() async {
    User? currentUser = Auth().currentUser;
    if (currentUser == null) {
      print('No user is currently signed in');
      return;
    }
    String uid = currentUser.uid;

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();

    List<Product> products = [];
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

    if (userData.containsKey('products')) {
      List<dynamic> userProducts = userData['products'];

      for (var productData in userProducts) {
        Product product = Product(
          id: productData['id'],
          name: productData['name'],
          description: productData['description'],
          createDate: productData['createDate'],
          count: productData['count'],
          unit: productData['unit'],
          image: productData['image'],
        );
        productDocumentIds[product] = userDoc.id;
        products.add(product);
      }
    }

    productList.value = products;
    filteredProducts.value = products;
  }

  Future<void> create(
    final String userId,
    final String name,
    final String description,
    final DateTime createDate,
    final int count,
    final String unit,
    final File? image, // Add this parameter
  ) async {
    String formattedCreateDate =
        "${createDate.day}/${createDate.month}/${createDate.year}";

    String newProductId = _firestore
        .collection("users")
        .doc(userId)
        .collection("products")
        .doc()
        .id;

    String imageUrl = ''; // Default empty URL

    if (image != null) {
      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child('$newProductId.jpg');
      await storageRef.putFile(image);

      // Get the URL of the uploaded image
      imageUrl = await storageRef.getDownloadURL();
    }

    final newProduct = {
      "id": newProductId,
      "name": name,
      "description": description,
      "count": count,
      "createDate": formattedCreateDate,
      "unit": unit,
      "status": true,
      "image": imageUrl, // Save the image URL
    };

    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await _firestore.collection("users").doc(userId).get();

    List<dynamic>? currentProducts =
        userDoc.data()?["products"] as List<dynamic>?;
    currentProducts ??= [];

    currentProducts.add(newProduct);

    await _firestore
        .collection("users")
        .doc(userId)
        .update({"products": currentProducts});

    filterSearchResult('');
    fetchProducts();
  }

  Future<void> updateStatus(Product product, bool status) async {
    String? userId = Auth().currentUser?.uid;

    if (userId == null) {
      print("User not authenticated");
      return;
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection("users").doc(userId).get();

      List<dynamic>? currentProducts =
          userDoc.data()?["products"] as List<dynamic>? ?? [];
      int index = currentProducts.indexWhere((p) => p["id"] == product.id);

      if (index != -1) {
        currentProducts[index]["status"] = !currentProducts[index]["status"];

        await _firestore
            .collection("users")
            .doc(userId)
            .update({"products": currentProducts});
      } else {
        print("Product not found");
      }
    } catch (e) {
      print("Error updating product status: $e");
    }
  }

  void filterSearchResult(String query) {
    if (query.isNotEmpty) {
      List<Product> filteredList = [];
      for (var product in productList) {
        if (product.name.toLowerCase().contains(query.toLowerCase())) {
          filteredList.add(product);
        }
      }
      filteredProducts.value = filteredList;
    } else {
      filteredProducts.value = productList;
    }
  }

  Map<String, List<Product>> groupProductsByDate() {
    Map<String, List<Product>> groupedProducts = {};

    for (var product in filteredProducts) {
      DateTime dateTime = DateFormat('dd/MM/yyyy').parse(product.createDate);
      String dateKey = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
      if (!groupedProducts.containsKey(dateKey)) {
        groupedProducts[dateKey] = [];
      }
      groupedProducts[dateKey]!.add(product);
    }

    return groupedProducts;
  }

  // Yeni fonksiyon: Verileri bir koleksiyondan okuyarak başka bir koleksiyona yazma
  Future<void> transferData(String sourceUserId, String targetUserId) async {
    try {
      // Kaynak koleksiyondan verileri al
      DocumentSnapshot<Map<String, dynamic>> sourceDoc =
          await _firestore.collection('users').doc(sourceUserId).get();

      List<dynamic>? sourceProducts =
          sourceDoc.data()?['products'] as List<dynamic>? ?? [];

      // Hedef koleksiyona verileri yaz
      for (var productData in sourceProducts) {
        String newProductId = _firestore
            .collection('users')
            .doc(targetUserId)
            .collection('products')
            .doc()
            .id;

        final newProduct = {
          'id': newProductId,
          'name': productData['name'],
          'description': productData['description'],
          'count': productData['count'],
          'createDate': productData['createDate'],
          'unit': productData['unit'],
          'status': productData['status'] ?? true,
        };

        await _firestore
            .collection('users')
            .doc(targetUserId)
            .collection('products')
            .doc(newProductId)
            .set(newProduct);
      }
      print('Veriler başarıyla aktarıldı.');
    } catch (e) {
      print('Veri aktarımı sırasında hata: $e');
    }
  }
}
