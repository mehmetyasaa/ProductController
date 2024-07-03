import 'package:flutter/material.dart';
import 'package:imtapp/models/product_model.dart';
import 'package:imtapp/widgets/custom_button_widget.dart';
import 'package:imtapp/widgets/custom_form_widget.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController createDate = TextEditingController();
  final TextEditingController count = TextEditingController();
  final TextEditingController unit = TextEditingController();

  // void addProduct() {
  //   final String name = name.;
  //   final String description = descriptionController.text;
  //   final DateTime createDate = DateTime.parse(createDateController.text);
  //   final int count = int.parse(countController.text);
  //   final int unit = int.parse(unitController.text);

  //   final Product newProduct = Product(
  //     name: name,
  //     description: description,
  //     createDate: createDate,
  //     count: count,
  //     unit: unit,
  //   );

  //   productList.add(newProduct);
  // }

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        itemBuilder: (context, index) {
          final _product = productList[index];
          return Dismissible(
            key: Key(const Uuid().v4()),
            onDismissed: (direction) {
              var deletedProduct = productList[index];
              if (direction == DismissDirection.endToStart) {
                // Sağa kaydırıldığında borcu debts listesinden kaldırın.
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("${deletedProduct.name} Ürünü Silindi")));
                productList.removeAt(index);
                print("${deletedProduct.name} adlı borç silindi.");
              }
            },
            background: Container(),
            secondaryBackground: Container(
              color: Colors.red,
              child: const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.delete),
              ),
            ),
            child: Card(
              child: ListTile(
                title: Text("İsim: ${_product.name}"),
                subtitle: Text("Açıklama: ${_product.description}"),
                trailing: Text(
                  "${_product.count} Adet",
                  style: TextStyle(fontSize: 17),
                ),
                leading: const Icon(Icons.tag),
                contentPadding: const EdgeInsets.all(10),
                onTap: () {},
              ),
            ),
          );
        },
        itemCount: productList.length,
      ),
    );
  }

  Future<dynamic> customBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ürün Ekle",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  CustomFormWidget(
                      controller: name,
                      labelText: "Ürün Adı",
                      icon: const Icon(Icons.tag)),
                  CustomFormWidget(
                      controller: description,
                      labelText: "Ürün Açıklaması",
                      icon: const Icon(Icons.description)),
                  CustomFormWidget(
                      controller: name,
                      labelText: "Tarih",
                      icon: const Icon(Icons.date_range)),
                  CustomFormWidget(
                      controller: name,
                      labelText: "Sayı",
                      icon: const Icon(Icons.format_list_numbered)),
                  CustomFormWidget(
                      controller: name,
                      labelText: "Birim",
                      icon: const Icon(Icons.ad_units)),
                  const Padding(
                      padding: EdgeInsets.only(bottom: 35),
                      child: CustomButtonWidget(btnText: "Kaydet"))
                ],
              ),
            ],
          );
        },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white);
  }

  Padding productTextField(
      TextEditingController controller, String text, Widget icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            border:
                UnderlineInputBorder(borderRadius: BorderRadius.circular(20)),
            labelText: text,
            prefixIcon: icon),
      ),
    );
  }
}
