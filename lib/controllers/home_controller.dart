import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:imtapp/models/product_model.dart';

class HomeController extends GetxController {
  RxList<Product> filteredProducts = RxList<Product>(productList);

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

  Map<DateTime, List<Product>> groupProductsByDate() {
    Map<DateTime, List<Product>> groupedProducts = {};

    for (var product in filteredProducts) {
      DateTime dateKey = DateTime(product.createDate.year,
          product.createDate.month, product.createDate.day);
      if (!groupedProducts.containsKey(dateKey)) {
        groupedProducts[dateKey] = [];
      }
      groupedProducts[dateKey]!.add(product);
    }

    return groupedProducts;
  }

  Future<dynamic> showDialogSlide(
      BuildContext context, String title, String content) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("yes".tr()),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("no".tr()),
            ),
          ],
        );
      },
    );
  }
}
