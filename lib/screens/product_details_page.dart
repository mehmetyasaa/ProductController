import 'package:flutter/material.dart';
import 'package:imtapp/models/product_model.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: ButtonsBar(
        buyButtonText: 'Gönder',
        onBuyButtonTapped: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          children: [
            Positioned.fill(
              child:
                  RoundedCornerImage(productImage: 'assets/image/profile.png'),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CurvedCornerContainer(
                child: DescriptionContent(product: product),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DescriptionContent extends StatelessWidget {
  final Product product;

  const DescriptionContent({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 200, top: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
          Text(
            product.description, // Assuming product has a brand field
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28),
            child: Text(
              product.description,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedCornerImage extends StatelessWidget {
  final String productImage;

  const RoundedCornerImage({super.key, required this.productImage});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Transform.translate(
        offset: const Offset(0, -135),
        child: Transform.scale(
          scale: 1.1,
          child: Image.asset("assets/image/profile.png"),
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}

class CurvedCornerContainer extends StatelessWidget {
  final Widget? child;

  const CurvedCornerContainer({super.key, this.child});

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

class ButtonsBar extends StatelessWidget {
  final String buyButtonText;
  final VoidCallback? onBuyButtonTapped;

  const ButtonsBar(
      {super.key, required this.buyButtonText, this.onBuyButtonTapped});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Flexible(
            flex: 6,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: onBuyButtonTapped,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  buyButtonText,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(flex: 2),
          const Icon(Icons.file_upload_outlined),
          const Spacer(flex: 1),
          const Icon(Icons.favorite_border_outlined)
        ],
      ),
    );
  }
}
