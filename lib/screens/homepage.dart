import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:imtapp/controllers/passwordController.dart';
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

  void filterSearchResult(String query) {
    List<String> dummySearchList;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double deviceWidth = mediaQueryData.size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 70, right: 20, left: 20),
              child: TextField(
                onChanged: (value) {},
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
                final product = productList[index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.green,
                        icon: Icons.edit_document,
                        label: "edit".tr(),
                        onPressed: (context) =>
                            _onDismissed(index, Actions.edit),
                      ),
                      SlidableAction(
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        label: "delete".tr(),
                        onPressed: (context) {
                          showDialogSlide(
                              context,
                              "delete".tr(),
                              "Are you sure you want to delete the product?"
                                  .tr());
                        },
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(product.name),
                    subtitle:
                        Text("${"description:".tr()}${product.description}"),
                    trailing: Text(
                      "${product.count}${"quantity".tr()}",
                      style: const TextStyle(fontSize: 17),
                    ),
                    leading: const Icon(Icons.tag),
                    contentPadding: const EdgeInsets.all(10),
                    onTap: () {},
                  ),
                );
              },
              childCount: productList.length,
            ),
          ),
        ],
      ),
    );
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

  Future<dynamic> customBottomSheet(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double deviceWidth = mediaQueryData.size.width;

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
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
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
                      prefixIcon: const Icon(Icons.date_range),
                    ),
                    readOnly: true, // Prevents the keyboard from appearing
                  ),
                ),
                CustomFormWidget(
                  controller: count,
                  labelText: "quantity".tr(),
                  icon: const Icon(Icons.format_list_numbered),
                ),
                CustomFormWidget(
                  controller: unit,
                  labelText: "unit".tr(),
                  icon: const Icon(Icons.ad_units),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35),
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

  Padding productTextField(
      TextEditingController controller, String text, Widget icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: UnderlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: text,
          prefixIcon: icon,
        ),
      ),
    );
  }

  void _onDismissed(int index, Actions action) {}
}
