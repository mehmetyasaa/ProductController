import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:imtapp/models/product_model.dart';

class ProductController extends GetxController {
  final Product product;
  var imageUrl = ''.obs;
  var isLoading = true.obs;

  ProductController(this.product);

  @override
  void onInit() {
    super.onInit();
    _getImageUrl();
  }

  Future<void> _getImageUrl() async {
    if (product.image != null && product.image!.isNotEmpty) {
      try {
        final ref = FirebaseStorage.instance.refFromURL(product.image!);
        final url = await ref.getDownloadURL();
        imageUrl.value = url;
      } catch (e) {
        print('Error loading image from Firebase Storage: $e');
        imageUrl.value = 'assets/image/imtLogo.png';
      }
    } else {
      imageUrl.value = 'assets/image/imtLogo.png';
    }
    isLoading.value = false;
  }
}
