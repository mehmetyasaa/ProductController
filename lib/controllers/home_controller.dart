import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:imtapp/firebase/auth.dart';
import 'package:imtapp/models/product_model.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  RxList<Product> productList = RxList<Product>([]);
  RxList<Product> filteredProducts = RxList<Product>([]);
  RxList<String> sentProjects = RxList<String>([]);
  RxString selectedProject = 'imtapp16'.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<Product, String> productDocumentIds = {};
  final Dio _dio = Dio();
  final String projectName = 'imtapp16';

  HomeController() {
    Auth().authStateChanges.listen((User? user) {
      if (user == null) {
        clearProducts();
      } else {
        fetchSentProjects();
        fetchProducts(); // Fetch products after fetching projects
      }
    });
  }

  void updateSelectedProject(String project) {
    selectedProject.value = project;
    addProjectToSentProjects(project);
    fetchProducts();
  }

  void clearProducts() {
    productList.clear();
    filteredProducts.clear();
    productDocumentIds.clear();
    sentProjects.clear();
  }

  @override
  void onInit() {
    super.onInit();
    fetchSentProjects(); // Fetch projects first
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
  Future<Product> fetchLatestProduct(String productId) async {
    User? currentUser = Auth().currentUser;
    if (currentUser == null) {
      throw Exception('No user is currently signed in');
    }
    String uid = currentUser.uid;

    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection("users").doc(uid).get();

      if (userDoc.exists) {
        List<dynamic>? userProducts =
            userDoc.data()?["products"] as List<dynamic>? ?? [];

        for (var productData in userProducts) {
          if (productData["id"] == productId) {
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
    } catch (e) {
      print('Error fetching latest product: $e');
      throw Exception('Failed to fetch the latest product');
    }

    throw Exception('Product not found');
  }

  Future<void> fetchProducts() async {
    User? currentUser = Auth().currentUser;
    if (currentUser == null) {
      print('No user is currently signed in');
      return;
    }
    String uid = currentUser.uid;
    String defaultProjectName = "imtapp16";

    String projectName = selectedProject.value.isNotEmpty
        ? selectedProject.value
        : defaultProjectName;
    if (projectName == defaultProjectName) {
      try {
        String apiUrl =
            'https://firestore.googleapis.com/v1/projects/$projectName/databases/(default)/documents/users/$uid';

        final response = await _dio.get(apiUrl);

        if (response.statusCode == 200) {
          Map<String, dynamic>? userData = response.data['fields'];

          if (userData == null) {
            print('User data is null');
            return;
          }

          List<Product> products = [];

          if (userData.containsKey('products')) {
            List<dynamic>? userProducts =
                userData['products']['arrayValue']['values'];

            if (userProducts != null) {
              for (var productData in userProducts) {
                if (productData == null || productData['mapValue'] == null) {
                  print('Product data or map value is null');
                  continue;
                }
                Product product = Product(
                  id: productData['mapValue']['fields']['id']['stringValue'],
                  name: productData['mapValue']['fields']['name']
                      ['stringValue'],
                  description: productData['mapValue']['fields']['description']
                      ['stringValue'],
                  createDate: productData['mapValue']['fields']['createDate']
                      ['stringValue'],
                  count: int.parse(productData['mapValue']['fields']['count']
                      ['integerValue']),
                  unit: productData['mapValue']['fields']['unit']
                      ['stringValue'],
                  status: productData['mapValue']['fields']['status']
                      ['booleanValue'],
                  image: productData['mapValue']['fields']['image']
                      ['stringValue'],
                );
                products.add(product);
              }
            } else {
              print('User products is null');
            }
          }

          productList.value = products;
          filteredProducts.value = products;
        } else {
          print('Failed to fetch products. HTTP ${response.statusCode}');
          print(response.data);
        }
      } catch (e) {
        print('Error fetching products: $e');
      }
    } else {
      try {
        String apiUrl =
            'https://firestore.googleapis.com/v1/projects/$projectName/databases/(default)/documents/products/';

        final response = await _dio.get(apiUrl);

        if (response.statusCode == 200) {
          List<dynamic> documents = response.data['documents'];

          if (documents == null) {
            print('User data is null');
            return;
          }

          List<Product> products = [];

          for (var doc in documents) {
            Map<String, dynamic> productData = doc['fields'];

            Product product = Product(
              id: productData['id']['stringValue'],
              name: productData['name']['stringValue'],
              description: productData['description']['stringValue'],
              createDate: productData['createDate']['stringValue'],
              count: int.parse(productData['count']['integerValue']),
              unit: productData['unit']['stringValue'],
              status: productData['status']['booleanValue'],
              image: productData['image']['stringValue'],
            );
            products.add(product);
          }

          productList.value = products;
          filteredProducts.value = products;
        } else {
          print('Failed to fetch products. HTTP ${response.statusCode}');
          print(response.data);
        }
      } catch (e) {
        print('Error fetching products: $e');
      }
    }
  }

  Future<void> create(
    final String userId,
    final String name,
    final String description,
    final DateTime createDate,
    final int count,
    final String unit,
    final File? image,
  ) async {
    String formattedCreateDate =
        "${createDate.day}/${createDate.month}/${createDate.year}";

    String newProductId = _firestore
        .collection("users")
        .doc(userId)
        .collection("products")
        .doc()
        .id;

    String imageUrl = '';

    if (image != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child('$newProductId.jpg');
      await storageRef.putFile(image);

      imageUrl = await storageRef.getDownloadURL();
    } else {
      imageUrl = "assets/image/imtLogo.png";
    }

    final newProduct = {
      "id": newProductId,
      "name": name,
      "description": description,
      "count": count,
      "createDate": formattedCreateDate,
      "unit": unit,
      "status": true,
      "image": imageUrl,
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
    fetchProducts();
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

  Future<void> transferData(String sourceUserId, String targetUserId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> sourceDoc =
          await _firestore.collection('users').doc(sourceUserId).get();

      List<dynamic>? sourceProducts =
          sourceDoc.data()?['products'] as List<dynamic>? ?? [];

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

  // Fetch sentProjects from Firestore
  Future<void> fetchSentProjects() async {
    User? currentUser = Auth().currentUser;
    if (currentUser == null) {
      print('No user is currently signed in');
      return;
    }
    String uid = currentUser.uid;

    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection("users").doc(uid).get();

      if (userDoc.exists) {
        List<dynamic>? projects =
            userDoc.data()?["sentProjects"] as List<dynamic>?;
        if (projects != null) {
          sentProjects.value = List<String>.from(projects);
        }
      }
    } catch (e) {
      print('Error fetching sent projects: $e');
    }
  }

  Future<void> addProjectToSentProjects(String project) async {
    User? currentUser = Auth().currentUser;
    if (currentUser == null) {
      print('No user is currently signed in');
      return;
    }
    String uid = currentUser.uid;

    sentProjects.add(project);

    try {
      await _firestore.collection("users").doc(uid).update({
        "sentProjects": FieldValue.arrayUnion([project])
      });
    } catch (e) {
      print('Error updating sent projects: $e');
    }
  }

  // Other existing methods remain the same...
}
