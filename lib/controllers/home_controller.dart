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
    try {
      String? docId = productDocumentIds[product];
      if (docId != null) {
        await _firestore.collection('products').doc(docId).delete();

        productList.remove(product);
        filterSearchResult('');
      } else {
        print('Document ID not found for product');
      }
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  void editProduct(Product product) {
    // Implement your edit logic here
  }

  void fetchProducts() async {
    try {
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
    } catch (e) {
      print('Error getting products: $e');
    }
    filterSearchResult('');
  }

  void addProduct(Product product) {
    productList.add(product);
    filterSearchResult('');
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
    fetchProducts();
  }

  Map<String, List<Product>> groupProductsByDate() {
    Map<String, List<Product>> groupedProducts = {};

    for (var product in filteredProducts) {
      try {
        DateTime dateTime = DateFormat('dd/MM/yyyy').parse(product.createDate);
        String dateKey = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
        if (!groupedProducts.containsKey(dateKey)) {
          groupedProducts[dateKey] = [];
        }
        groupedProducts[dateKey]!.add(product);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }

    return groupedProducts;
  }
}
