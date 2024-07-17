import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:imtapp/controllers/home_controller.dart';
import 'package:imtapp/models/product_model.dart';
import 'package:imtapp/screens/product_details_page.dart';
import 'package:http/http.dart' as http;

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
                    onPressed: (context) => onDismissed(product, Actions.send),
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
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    backgroundColor: const Color.fromARGB(255, 255, 136, 0),
                    icon: Icons.no_adult_content,
                    label: "Passive",
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
      checkAndCreateProductInApi(product);
    } else if (action == Actions.passive) {
      Get.find<HomeController>().updateStatus(product, false);
    }
  }

  void checkAndCreateProductInApi(Product product) async {
    try {
      String apiUrl =
          'https://firestore.googleapis.com/v1/projects/imtapp17/databases/(default)/documents/products/${product.id}';

      final checkResponse = await http.get(Uri.parse(apiUrl));

      if (checkResponse.statusCode == 404) {
        final createResponse = await http.post(
          Uri.parse(
              'https://firestore.googleapis.com/v1/projects/imtapp17/databases/(default)/documents/products'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'fields': {
              'id': {'stringValue': product.id},
              'name': {'stringValue': product.name},
              'description': {'stringValue': product.description},
              'count': {'integerValue': product.count.toString()},
              'createDate': {'stringValue': product.createDate},
              'unit': {'stringValue': product.unit},
              'status': {'booleanValue': true},
            },
          }),
        );

        if (createResponse.statusCode == 200) {
          print('Ürün başarıyla oluşturuldu.');
        } else {
          print(
              'Ürün oluşturulurken hata oluştu. HTTP ${createResponse.statusCode}');
          print(createResponse.body);
        }
      } else if (checkResponse.statusCode == 200) {
        updateFirestoreDocument(product);
      } else {
        print(
            'Ürün kontrol edilirken hata oluştu. HTTP ${checkResponse.statusCode}');
        print(checkResponse.body);
      }
    } catch (e) {
      print('Hata: $e');
    }
  }

  void updateFirestoreDocument(Product product) async {
    try {
      String apiUrl =
          'https://firestore.googleapis.com/v1/projects/imtapp17/databases/(default)/documents/products/${product.id}?';

      Map<String, dynamic> documentData = {
        'fields': {
          'id': {'stringValue': product.id},
          'name': {'stringValue': product.name},
          'description': {'stringValue': product.description},
          'count': {'integerValue': product.count.toString()},
          'createDate': {'stringValue': product.createDate},
          'unit': {'stringValue': product.unit},
          'status': {'booleanValue': true},
        }
      };

      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(documentData),
      );

      if (response.statusCode == 200) {
        print('Belge başarıyla güncellendi.');
      } else {
        print('Belge güncellenirken hata oluştu. HTTP ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Hata: $e');
    }
  }
}
