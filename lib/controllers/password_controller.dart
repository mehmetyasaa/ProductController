import 'package:get/get.dart';

class PasswordController extends GetxController {
  RxBool isObscure = true.obs;

  void changeObscure() => isObscure.value = !isObscure.value;
}
