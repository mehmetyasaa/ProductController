import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:imtapp/controllers/home_controller.dart';
import 'package:imtapp/models/product_model.dart';
import 'package:imtapp/screens/product_details_page.dart';
import 'package:imtapp/service/api_service.dart';

enum Actions { delete, send, passive }

class DateProductWidget extends StatelessWidget {
  final DateTime date;
  final List<Product> products;
  final String formattedDate;

  const DateProductWidget({
    super.key,
    required this.date,
    required this.products,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    bool isToday = DateTime.now().year == date.year &&
        DateTime.now().month == date.month &&
        DateTime.now().day == date.day;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: deviceHeight * 0.006,
        horizontal: deviceHeight * 0.0010,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: products.asMap().entries.map((entry) {
          int index = entry.key;
          Product product = entry.value;
          bool isFirst = index == 0;

          return Padding(
            padding: EdgeInsets.only(bottom: deviceHeight * 0.015),
            child: Slidable(
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    backgroundColor: Colors.green,
                    icon: Icons.send,
                    label: "Gönder",
                    onPressed: (context) async {
                      // Fetch the latest product data
                      Product latestProduct = await Get.find<HomeController>()
                          .fetchLatestProduct(product.id);

                      if (latestProduct.status == null ||
                          !latestProduct.status!) {
                        Get.snackbar(
                          "Ürün Aktif Değil",
                          "'${latestProduct.name}' isimli ürün aktif değil, bu yüzden gönderilemez.",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        showDialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          builder: (BuildContext context) {
                            TextEditingController messageController =
                                TextEditingController();

                            return AlertDialog(
                              title: Text(
                                  "'${latestProduct.name}' isimli ürünü gönderiyorsunuz"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      color: Colors.red.shade50,
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.info,
                                            color: Colors.red,
                                          ),
                                          Text(
                                            "Veri gönderebilmek için Firebase\nprojenizde Firestore Database\naçılmalı ve 'products' isimli collection \noluşturulmalıdır.",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: messageController,
                                    decoration: const InputDecoration(
                                      labelText: 'Veri Tabanı Adı',
                                    ),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('İptal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ApiService().checkAndCreateProductInApi(
                                        latestProduct,
                                        projeName: messageController.text);
                                    Get.back();
                                  },
                                  child: const Text('Gönder'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                  SlidableAction(
                    backgroundColor: Colors.red,
                    icon: Icons.delete,
                    label: "delete".tr(),
                    onPressed: (context) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('delete'.tr()),
                            content: Text(
                              'Are you sure you want to delete the product?'
                                  .tr(),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Get.back(),
                                child: Text('no'.tr()),
                              ),
                              TextButton(
                                onPressed: () {
                                  onDismissed(product, Actions.delete);
                                  Get.back();
                                },
                                child: Text('yes'.tr()),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              startActionPane: ActionPane(
                motion: const BehindMotion(),
                children: [
                  SlidableAction(
                    backgroundColor: const Color.fromARGB(255, 255, 218, 194),
                    icon: Icons.published_with_changes,
                    label: "Status Change",
                    onPressed: (context) =>
                        onDismissed(product, Actions.passive),
                  )
                ],
              ),
              child: ListTile(
                leading: isFirst
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isToday
                                ? "today".tr()
                                : DateFormat('MMM').format(date),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Color.fromARGB(255, 255, 77, 0),
                            ),
                          ),
                          if (!isToday)
                            Text(
                              DateFormat('d').format(date),
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Color.fromARGB(255, 255, 77, 0),
                              ),
                            ),
                        ],
                      )
                    : null,
                title: Padding(
                  padding:
                      EdgeInsets.only(left: isFirst ? 0 : deviceHeight * 0.075),
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding:
                      EdgeInsets.only(left: isFirst ? 0 : deviceHeight * 0.075),
                  child: Text("${"description".tr()} : ${product.description}"),
                ),
                trailing: Column(
                  children: [
                    Text(
                      "${product.count}  ${product.unit}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 255, 99, 9),
                      ),
                    ),
                    const Icon(
                      Icons.swipe_left_outlined,
                      color: Color.fromARGB(255, 190, 71, 2),
                    ),
                  ],
                ),
                contentPadding: EdgeInsets.all(deviceHeight * 0.015),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(product: product),
                  ));
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void onDismissed(Product product, Actions action) {
    if (action == Actions.delete) {
      Get.find<HomeController>().deleteProduct(product);
    } else if (action == Actions.send) {
      // ApiService().checkAndCreateProductInApi(product);
    } else if (action == Actions.passive) {
      Get.find<HomeController>().updateStatus(product, false);
    }
  }
}
