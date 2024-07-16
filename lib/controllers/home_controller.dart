import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        prod['unit'] == product.unit);

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
  ) async {
    String formattedCreateDate =
        "${createDate.day}/${createDate.month}/${createDate.year}";

    String newProductId = _firestore
        .collection("users")
        .doc(userId)
        .collection("products")
        .doc()
        .id;

    final newProduct = {
      "id": newProductId, // Include the generated id
      "name": name,
      "description": description,
      "count": count,
      "createDate": formattedCreateDate,
      "unit": unit,
      "status": true,
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
}
