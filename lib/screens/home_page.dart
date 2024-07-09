import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:imtapp/controllers/home_controller.dart';
import 'package:imtapp/widgets/custom_bottomSheet_widget.dart';
import 'package:imtapp/widgets/date_product_widget.dart';
import 'package:imtapp/models/product_model.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController createDate = TextEditingController();
  final TextEditingController count = TextEditingController();
  final TextEditingController search = TextEditingController();

  final HomeController controller = Get.put(HomeController());

  String dropdownValue = 'Kg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 253, 91, 22),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return CustomBottomSheetWidget(
                name: name,
                description: description,
                createDate: createDate,
                count: count,
                dropdownValue: dropdownValue,
                onDropdownChanged: (String? newValue) {
                  if (newValue != null) {
                    dropdownValue = newValue;
                  }
                },
              );
            },
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            backgroundColor: Colors.white,
          );
        },
        child: const Icon(
          Icons.add,
          size: 27,
        ),
      ),
      body: Obx(() {
        if (controller.productList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final Map<String, List<Product>> groupedProducts =
              controller.groupProductsByDate();
          final List<String> sortedDates = groupedProducts.keys.toList()
            ..sort((a, b) => parseDate(a).compareTo(parseDate(b)));

          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 60,
                title: const Text("İletişim Yazılım"),
                flexibleSpace: FlexibleSpaceBar(
                  background: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                    child: Container(
                      color: Colors.orange,
                      height: 100,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: TextField(
                    onChanged: (value) {
                      controller.filterSearchResult(value);
                    },
                    controller: search,
                    decoration: const InputDecoration(
                      labelText: "Listeyi ara",
                      hintText: "Aramak için yaz",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final String dateString = sortedDates[index];
                    final DateTime date = parseDate(dateString);
                    final List<Product> products = groupedProducts[dateString]!;
                    return DateProductWidget(
                      date: date,
                      products: products,
                      formattedDate: dateString,
                    );
                  },
                  childCount: sortedDates.length,
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  DateTime parseDate(String dateString) {
    try {
      return DateFormat('yyyy-M-d').parse(dateString);
    } catch (e) {
      print('Error parsing date: $e');
      return DateTime.now();
    }
  }
}
