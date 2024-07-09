import 'package:flutter/material.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:imtapp/service/product_service.dart';
import 'package:imtapp/widgets/custom_button_widget.dart';
import 'package:imtapp/widgets/custom_form_widget.dart';

class CustomBottomSheetWidget extends StatelessWidget {
  final TextEditingController name;
  final TextEditingController description;
  final TextEditingController createDate;
  final TextEditingController count;
  final String dropdownValue;
  final void Function(String?) onDropdownChanged;

  const CustomBottomSheetWidget({
    Key? key,
    required this.name,
    required this.description,
    required this.createDate,
    required this.count,
    required this.dropdownValue,
    required this.onDropdownChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double deviceWidth = mediaQueryData.size.width;
    const List<String> list = <String>['Kg', 'G', 'L', 'Ml'];

    // final dateFormat = DateTime.parse(createDate.text);

    return Wrap(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Add Product".tr(),
              style: Theme.of(context).textTheme.bodyMedium,
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
                        tomorrow: 'tomorrow'.tr(),
                        now: 'now'.tr(),
                      ),
                      startDayOfWeek: DateTime.sunday,
                      pickerFormat: PickerFormat.ymd,
                      activeColor: const Color.fromARGB(255, 255, 147, 6),
                      backgroundDecoration:
                          const BoxDecoration(color: Colors.white),
                    ),
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
                readOnly: true,
              ),
            ),
            CustomFormWidget(
              controller: count,
              labelText: "quantity".tr(),
              icon: const Icon(Icons.format_list_numbered),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                  onChanged: onDropdownChanged,
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
              padding: const EdgeInsets.only(bottom: 35),
              child: CustomButtonWidget(
                btnText: "save".tr(),
                onPressed: () {
                  if (name.text.isEmpty ||
                      description.text.isEmpty ||
                      count.text.isEmpty ||
                      createDate.text.isEmpty) {
                    return;
                  }

                  int countValue = int.tryParse(count.text) ?? 0;

                  ProductsService().create(
                      name.text,
                      description.text,
                      DateTime.parse(createDate
                          .text), // Use DateTime.parse for string date
                      countValue,
                      dropdownValue);

                  //2024-07-09T00:00:00.000

                  // Optionally, you can close the bottom sheet here
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    Key? key,
    required this.btnText,
    required this.onPressed,
  }) : super(key: key);

  final String btnText;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 110),
        child: Text(
          btnText,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
