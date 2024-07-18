import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:imtapp/firebase/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:imtapp/controllers/home_controller.dart';
import 'package:imtapp/widgets/custom_bottomSheet_widget.dart';
import 'package:imtapp/widgets/date_product_widget.dart';
import 'package:imtapp/models/product_model.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController createDate = TextEditingController();
  final TextEditingController count = TextEditingController();
  final TextEditingController search = TextEditingController();

  final HomeController controller = Get.put(HomeController());

  String dropdownValue = 'Kg';
  final PageController controllerr = PageController(initialPage: 0);
  //drawer
  final String? username = Auth().currentUser?.displayName;
  final String? email = Auth().currentUser!.email;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double topPadding = deviceHeight * 0.07;

    return Scaffold(
      // resizeToAvoidBottomInset: true,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              color: const Color.fromARGB(255, 255, 136, 0),
              width: double.infinity,
              padding: EdgeInsets.only(top: topPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: deviceHeight * 0.02),
                    height: deviceHeight * 0.12,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/image/profile.png')),
                    ),
                  ),
                  Text(
                    username ?? "undefined",
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: deviceHeight * 0.02),
                    child: Text(
                      email ?? "undefined",
                      style: TextStyle(color: Colors.grey[200], fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            drawerMethod(const Icon(Icons.exit_to_app), Text("Log Out".tr()),
                () => Auth().signOute()),
            drawerMethod(
              const Icon(Icons.delete),
              Text("Delete Account".tr()),
              () {
                showDialog(
                  context: Get.context!,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Delete Account".tr()),
                      content:
                          Text('Hesabı silmek istediğinize emin misiniz?'.tr()),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text('no'.tr()),
                        ),
                        TextButton(
                          onPressed: () {
                            Auth().deleteAccount();
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
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 249, 109, 49),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.only(
                topEnd: Radius.circular(25),
                topStart: Radius.circular(25),
              ),
            ),
            builder: (context) => Container(
                padding: const EdgeInsetsDirectional.only(
                  start: 20,
                  end: 20,
                  bottom: 20,
                  top: 8,
                ),
                child: CustomBottomSheetWidget(
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
                )),
          );
        },
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
      body: Obx(() {
        if (controller.productList.isEmpty) {
          return Center(
              child: Text("Product Not Found".tr(),
                  style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 22,
                      fontWeight: FontWeight.w600)));
        } else {
          final Map<String, List<Product>> groupedProducts =
              controller.groupProductsByDate();
          final List<String> sortedDates = groupedProducts.keys.toList()
            ..sort((a, b) => parseDate(a).compareTo(parseDate(b)));

          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: deviceHeight * 0.08,
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
                  padding: EdgeInsets.all(deviceHeight * 0.02),
                  child: TextField(
                    maxLength: 30,
                    onChanged: (value) {
                      controller.filterSearchResult(value);
                    },
                    controller: search,
                    decoration: InputDecoration(
                      labelText: "Search".tr(),
                      hintText: "Write to search".tr(),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(deviceHeight * 0.02)),
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

  ListTile drawerMethod(Widget leading, Widget title, Function()? onTap) {
    return ListTile(
      leading: leading,
      title: title,
      onTap: onTap,
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
