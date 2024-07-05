import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart' hide Trans;
import 'package:imtapp/models/product_model.dart';
import 'package:imtapp/widgets/custom_button_widget.dart';
import 'package:imtapp/widgets/custom_form_widget.dart';

enum Actions { delete, edit }

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController createDate = TextEditingController();
  final TextEditingController count = TextEditingController();
  final TextEditingController unit = TextEditingController();
  final TextEditingController search = TextEditingController();

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double deviceWidth = mediaQueryData.size.width;
    final double deviceHeight = mediaQueryData.size.height;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 253, 91, 22),
        onPressed: () {
          customBottomSheet(context);
        },
        child: const Icon(
          Icons.add,
          size: 27,
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            leading: Icon(Icons.menu),
            title: Text("İletişim Yazılım"),
            flexibleSpace: FlexibleSpaceBar(),
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
          Obx(() {
            final Map<DateTime, List<Product>> groupedProducts =
                controller.groupProductsByDate();
            final List<DateTime> sortedDates = groupedProducts.keys.toList()
              ..sort((a, b) => b.compareTo(a));
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final DateTime date = sortedDates[index];
                  final List<Product> products = groupedProducts[date]!;
                  return DateProductWidget(date: date, products: products);
                },
                childCount: sortedDates.length,
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<dynamic> customBottomSheet(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double deviceWidth = mediaQueryData.size.width;
    const List<String> list = <String>['Kg', 'G', 'L', 'Ml'];
    String dropdownValue = list.first;
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add Product".tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                CustomFormWidget(
                  controller: name,
                  labelText: "name".tr(),
                  icon: const Icon(Icons.tag),
                ),
                CustomFormWidget(
                  controller: description,
                  labelText: "description".tr(),
                  icon: const Icon(Icons.description),
                ),
                Padding(
                  padding: EdgeInsets.all(deviceWidth / 60),
                  child: TextFormField(
                    onTap: () async {
                      DateTime? picked = await showBoardDateTimePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        pickerType: DateTimePickerType.datetime,
                        options: BoardDateTimeOptions(
                            languages: BoardPickerLanguages(
                                locale: 'en'.tr(),
                                today: 'today'.tr(),
                                tomorrow: 'tommorrow'.tr(),
                                now: 'now'.tr()),
                            startDayOfWeek: DateTime.sunday,
                            pickerFormat: PickerFormat.ymd,
                            activeColor: const Color.fromARGB(255, 255, 147, 6),
                            backgroundDecoration:
                                BoxDecoration(color: Colors.white)),
                      );

                      if (picked != null) {
                        createDate.text = "${picked.toLocal()}".split(' ')[0];
                      }
                    },
                    controller: createDate,
                    decoration: InputDecoration(
                      labelText: "date".tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      prefixIcon: Icon(Icons.date_range),
                    ),
                    readOnly: true, // Prevents the keyboard from appearing
                  ),
                ),
                CustomFormWidget(
                  controller: count,
                  labelText: "quantity".tr(),
                  icon: const Icon(Icons.format_list_numbered),
                ),
                // CustomFormWidget(
                //   controller: unit,
                //   labelText: "unit".tr(),
                //   icon: const Icon(Icons.ad_units),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.0),
                      border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 0.50,
                      ),
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (String? newValue) {
                        dropdownValue = newValue!;
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 35),
                  child: CustomButtonWidget(btnText: "save".tr()),
                ),
              ],
            ),
          ],
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: Colors.white,
    );
  }
}

//dışarıya alınacak
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

  void onDismissed(Product product, Actions action) {
    // Implement your edit or delete functionality here
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

class DateProductWidget extends StatelessWidget {
  final DateTime date;
  final List<Product> products;

  DateProductWidget({required this.date, required this.products});

  @override
  Widget build(BuildContext context) {
    bool isToday = DateTime.now().year == date.year &&
        DateTime.now().month == date.month &&
        DateTime.now().day == date.day;

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 60,
              child: Column(
                children: [
                  Text(
                    isToday
                        ? "Bugün"
                        : DateFormat('MMM').format(date), // Month or "Today"
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color.fromARGB(255, 255, 77, 0)),
                  ),
                  if (!isToday)
                    Text(
                      DateFormat('d').format(date), // Day
                      style: const TextStyle(
                          fontSize: 30,
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
                          icon: Icons.edit_document,
                          label: "edit".tr(),
                          onPressed: (context) => Get.find<HomeController>()
                              .onDismissed(product, Actions.edit),
                        ),
                        SlidableAction(
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          label: "delete".tr(),
                          onPressed: (context) {
                            Get.find<HomeController>().showDialogSlide(
                                context,
                                "delete".tr(),
                                "Are you sure you want to delete the product?"
                                    .tr());
                          },
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        product.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 17),
                      ),
                      subtitle:
                          Text("description".tr() + ": ${product.description}"),
                      trailing: Text(
                        "${product.count}" + " " + "quantity".tr(),
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
        const Divider(),
      ],
    );
  }
}
