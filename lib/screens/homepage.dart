import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imtapp/controllers/home_controller.dart';
import 'package:imtapp/models/product_model.dart';
import 'package:imtapp/widgets/custom_bottomSheet_widget.dart';
import 'package:imtapp/widgets/date_product_widget.dart';

enum Actions { delete, edit }

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
    MediaQuery.of(context);

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
      body: ClipRRect(
        borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(MediaQuery.of(context).size.width * .1)),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 80,
                  leading: const Icon(Icons.menu),
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
                    padding:
                        const EdgeInsets.only(top: 20, right: 20, left: 20),
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
                Obx(() {
                  final Map<DateTime, List<Product>> groupedProducts =
                      controller.groupProductsByDate();
                  final List<DateTime> sortedDates = groupedProducts.keys
                      .toList()
                    ..sort((a, b) => b.compareTo(a));
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final DateTime date = sortedDates[index];
                        final List<Product> products = groupedProducts[date]!;
                        return DateProductWidget(
                          date: date,
                          products: products,
                        );
                      },
                      childCount: sortedDates.length,
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
