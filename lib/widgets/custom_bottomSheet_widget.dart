import 'package:flutter/material.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;
import 'package:image_picker/image_picker.dart';
import 'package:imtapp/firebase/auth.dart';
import 'package:imtapp/widgets/custom_form_widget.dart';
import 'package:imtapp/controllers/home_controller.dart';

class CustomBottomSheetWidget extends StatelessWidget {
  final TextEditingController name;
  final TextEditingController description;
  final TextEditingController createDate;
  final TextEditingController count;
  final String dropdownValue;
  final void Function(String?) onDropdownChanged;

  const CustomBottomSheetWidget({
    super.key,
    required this.name,
    required this.description,
    required this.createDate,
    required this.count,
    required this.dropdownValue,
    required this.onDropdownChanged,
  });

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double deviceWidth = mediaQueryData.size.width;
    final double deviceHeight = mediaQueryData.size.height;
    const List<String> list = <String>['Kg', 'G', 'L', 'Ml'];

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(deviceHeight * 0.02),
              child: Text(
                "Add Product".tr(),
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
              ),
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
                textInputAction: TextInputAction.next,
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
              padding: EdgeInsets.all(deviceHeight * 0.012),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22.0),
                  border: Border.all(
                    color: Colors.black,
                    style: BorderStyle.solid,
                    width: deviceHeight * 0.0006,
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
            // Expanded(
            //   child: Column(
            //     children: [
            //       Expanded(
            //         child: Center(
            //           child: _image == null
            //               ? Text('No image selected.')
            //               : Image.file(_image!),
            //         ),
            //       ),
            //       ElevatedButton(
            //         onPressed: () async {
            //           final image = await ImagePicker()
            //               .pickImage(source: ImageSource.gallery);
            //           if (image != null) {
            //             _image = File(image.path);
            //           }
            //         },
            //         child: Text('Select image'),
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.03),
              child: CustomButtonWidget(
                btnText: "save".tr(),
                onPressed: () async {
                  if (name.text.isEmpty ||
                      description.text.isEmpty ||
                      count.text.isEmpty ||
                      createDate.text.isEmpty) {
                    return;
                  }

                  Get.find<HomeController>().create(
                      Auth().currentUser!.uid,
                      name.text,
                      description.text,
                      DateTime.parse(createDate.text),
                      int.parse(count.text),
                      dropdownValue);

                  name.text = "";
                  description.text = "";
                  createDate.text = "";
                  count.text = "";

                  Get.find<HomeController>().fetchProducts();
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
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
    double deviceHeight = MediaQuery.of(context).size.height;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 147, 6)),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: deviceHeight * 0.013, horizontal: deviceHeight * 0.12),
        child: Text(
          btnText,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    );
  }
}
