import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imtapp/controllers/product_controller.dart';
import 'package:imtapp/models/product_model.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  ProductDetailsPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller inside the build method
    final ProductController controller =
        Get.put(ProductController(product), tag: product.id);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          children: [
            Obx(() {
              if (controller.imageUrl.value.isEmpty) {
                return Center(child: CircularProgressIndicator());
              } else if (controller.imageUrl.value ==
                  'assets/image/profile.png') {
                return Positioned.fill(
                  child: RoundedCornerImage(
                    productImage: 'assets/image/profile.png',
                    isNetworkImage: false,
                  ),
                );
              } else {
                return Positioned.fill(
                  child: RoundedCornerImage(
                    productImage: controller.imageUrl.value,
                  ),
                );
              }
            }),
            Align(
              alignment: Alignment.bottomCenter,
              child: CurvedCornerContainer(
                child: DescriptionContent(product: product),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedCornerImage extends StatelessWidget {
  final String productImage;
  final bool isNetworkImage;

  const RoundedCornerImage({
    Key? key,
    required this.productImage,
    this.isNetworkImage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Transform.translate(
        offset: const Offset(0, -135),
        child: Transform.scale(
          scale: 1.1,
          alignment: Alignment.topCenter,
          child: isNetworkImage
              ? Image.network(productImage)
              : Image.asset(productImage),
        ),
      ),
    );
  }
}

class CurvedCornerContainer extends StatelessWidget {
  final Widget? child;

  const CurvedCornerContainer({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: FancyClipPath(),
      child: Container(
        constraints:
            const BoxConstraints(minHeight: 400, maxHeight: 600, minWidth: 400),
        color: Colors.white,
        child: child,
      ),
    );
  }
}

class FancyClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const radius = 48.0;
    Path path = Path();
    path.moveTo(0, radius * 2);
    path.arcToPoint(const Offset(radius, radius),
        radius: const Radius.circular(radius));
    path.lineTo(size.width - radius, radius);
    path.arcToPoint(Offset(size.width, 0),
        radius: const Radius.circular(radius), clockwise: false);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class DescriptionContent extends StatelessWidget {
  final Product product;

  const DescriptionContent({Key? key, required this.product}) : super(key: key);
  final cOrange = const Color.fromARGB(255, 255, 123, 0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 90, right: 90, bottom: 20, top: 70),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Ürün Adı",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w600, color: cOrange),
          ),
          Text(
            product.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          Text(
            "Ürün Açıklaması",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w500, color: cOrange),
          ),
          Text(
            product.description,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text(
                    "Miktar",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    product.count.toString(),
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    "Birim",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    product.unit,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Tarih",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w500, color: cOrange),
          ),
          Text(
            product.createDate,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
