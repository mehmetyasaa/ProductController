import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:imtapp/models/product_model.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  RxList<Product> productList = RxList<Product>([]);
  RxList<Product> filteredProducts = RxList<Product>([]);

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void deleteProduct(Product product) {}

  void editProduct(Product product) {}

  void fetchProducts() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('products').get();
      List<Product> products = snapshot.docs.map((doc) {
        return Product(
          name: doc['name'],
          description: doc['description'],
          createDate: doc['createDate'],
          count: doc['count'],
          unit: doc['unit'],
        );
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
