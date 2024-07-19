import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CustomBottomSheetController extends GetxController {
  var isLoading = false.obs;
  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController createDate = TextEditingController();
  final TextEditingController count = TextEditingController();
  final RxString dropdownValue = 'Kg'.obs;
  final Rx<File?> image = Rx<File?>(null);

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image.value = File(pickedImage.path);
    }
  }

  void setDropdownValue(String? newValue) {
    if (newValue != null) {
      dropdownValue.value = newValue;
    }
  }
}
