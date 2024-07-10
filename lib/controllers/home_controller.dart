import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:imtapp/models/product_model.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  RxList<Product> productList = RxList<Product>([]);
  RxList<Product> filteredProducts = RxList<Product>([]);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<Product, String> productDocumentIds = {};

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void deleteProduct(Product product) async {
    try {
      String? docId = productDocumentIds[product];
      if (docId != null) {
        // Remove from Firestore
        await _firestore.collection('products').doc(docId).delete();

        // Remove from local list
        productList.remove(product);
        filterSearchResult('');
      } else {
        print('Document ID not found for product');
      }
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  void editProduct(Product product) {}

  void fetchProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      List<Product> products = snapshot.docs.map((doc) {
        Product product = Product(
          name: doc['name'],
          description: doc['description'],
          createDate: doc['createDate'],
          count: doc['count'],
          unit: doc['unit'],
        );
        productDocumentIds[product] = doc.id;
        return product;
      }).toList();
      productList.value = products;
      filteredProducts.value = products;
    } catch (e) {
      print('Error getting products: $e');
    }
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
