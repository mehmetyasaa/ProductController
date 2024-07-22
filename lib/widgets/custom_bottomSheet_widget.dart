import 'package:flutter/material.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:imtapp/controllers/CustomBottomSheetController.dart';
import 'package:imtapp/firebase/auth.dart';
import 'package:imtapp/widgets/custom_button_widget.dart';
import 'package:imtapp/widgets/custom_form_widget.dart';
import 'package:imtapp/controllers/home_controller.dart';

class CustomBottomSheetWidget extends StatelessWidget {
  CustomBottomSheetWidget({super.key});

  final CustomBottomSheetController _controller =
      Get.put(CustomBottomSheetController());
  final HomeController _homeController = Get.find<HomeController>();
  final _formKey = GlobalKey<FormState>(); // Key to manage form state

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double deviceWidth = mediaQueryData.size.width;
    final double deviceHeight = mediaQueryData.size.height;
    const List<String> list = <String>['Kg', 'G', 'L', 'Ml'];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey, // Form widget to manage state
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(deviceHeight * 0.02),
                child: const Text(
                  "Add Product",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                ),
              ),
              CustomFormWidget(
                controller: _controller.name,
                labelText: "Name",
                icon: const Icon(Icons.tag),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              CustomFormWidget(
                controller: _controller.description,
                labelText: "Description",
                icon: const Icon(Icons.description),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
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
                      options: const BoardDateTimeOptions(
                        languages: BoardPickerLanguages(
                          locale: 'en',
                          today: 'today',
                          tomorrow: 'tomorrow',
                          now: 'now',
                        ),
                        startDayOfWeek: DateTime.sunday,
                        pickerFormat: PickerFormat.ymd,
                        activeColor: Color.fromARGB(255, 255, 147, 6),
                        backgroundDecoration:
                            BoxDecoration(color: Colors.white),
                      ),
                    );

                    if (picked != null) {
                      _controller.createDate.text =
                          "${picked.toLocal()}".split(' ')[0];
                    }
                  },
                  controller: _controller.createDate,
                  decoration: InputDecoration(
                    labelText: "Date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    prefixIcon: const Icon(Icons.date_range),
                  ),
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Date is required';
                    }
                    return null;
                  },
                ),
              ),
              CustomFormWidget(
                controller: _controller.count,
                labelText: "Quantity",
                icon: const Icon(Icons.format_list_numbered),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Quantity is required';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
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
                  child: Obx(
                    () => DropdownButtonFormField<String>(
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
                      value: _controller.dropdownValue.value,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      onChanged: _controller.setDropdownValue,
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(deviceHeight * 0.012),
                child: Column(
                  children: [
                    Obx(
                      () => _controller.image.value != null
                          ? Image.file(
                              _controller.image.value!,
                              height: deviceHeight * 0.2,
                            )
                          : const Text('No image selected.'),
                    ),
                    ElevatedButton(
                      onPressed: _controller.pickImage,
                      child: const Text('Select image'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.03),
                child: Obx(() {
                  if (_controller.isLoading.value) {
                    return const CircularProgressIndicator();
                  } else {
                    return CustomButtonWidget(
                      btnText: "Save",
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          _controller.isLoading.value = true;

                          try {
                            await _homeController.create(
                              Auth().currentUser!.uid,
                              _controller.name.text,
                              _controller.description.text,
                              DateTime.parse(_controller.createDate.text),
                              int.parse(_controller.count.text),
                              _controller.dropdownValue.value,
                              _controller.image.value,
                            );

                            _controller.name.clear();
                            _controller.description.clear();
                            _controller.createDate.clear();
                            _controller.count.clear();
                            _controller.image.value = null;

                            _homeController.fetchProducts();
                            Get.back();
                          } finally {
                            _controller.isLoading.value = false;
                          }
                        }
                      },
                    );
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    super.key,
    required this.btnText,
    required this.onPressed,
  });

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
