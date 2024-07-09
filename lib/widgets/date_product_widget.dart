import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart' hide Trans;
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:imtapp/controllers/home_controller.dart';
import 'package:imtapp/models/product_model.dart';

enum Actions { delete, edit }

class DateProductWidget extends StatelessWidget {
  final DateTime date;
  final List<Product> products;

  const DateProductWidget(
      {super.key,
      required this.date,
      required this.products,
      required String formattedDate});

  @override
  Widget build(BuildContext context) {
    bool isToday = DateTime.now().year == date.year &&
        DateTime.now().month == date.month &&
        DateTime.now().day == date.day;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Column(
              children: [
                Text(
                  isToday ? "today".tr() : DateFormat('MMM').format(date),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: Color.fromARGB(255, 255, 77, 0)),
                ),
                if (!isToday)
                  Text(
                    DateFormat('d').format(date), // Day
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 255, 77, 0)),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: products.map((product) {
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                          backgroundColor: Colors.green,
                          icon: Icons.edit,
                          label: "edit".tr(),
                          onPressed: (context) =>
                              onDismissed(product, Actions.edit)),
                      SlidableAction(
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        label: "delete".tr(),
                        onPressed: (context) =>
                            onDismissed(product, Actions.delete),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Text(
                        product.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 17),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Text(
                          "${"description".tr()} : ${product.description}"),
                    ),
                    trailing: Text(
                      "${product.count}  ${"quantity".tr()}",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 255, 99, 9)),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                    onTap: () {},
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void onDismissed(Product product, Actions action) {
    if (action == Actions.delete) {
      // Implement delete functionality
      Get.find<HomeController>().deleteProduct(product);
    } else if (action == Actions.edit) {
      // Implement edit functionality
      Get.find<HomeController>().editProduct(product);
    }
  }
}
