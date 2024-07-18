import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart'
    hide
        Trans; //getx ve easy local'de string.tr() kullanımı çakıştığından hide kullandım
import 'package:google_fonts/google_fonts.dart';
import 'package:imtapp/controllers/password_controller.dart';
import 'package:imtapp/firebase/auth.dart';
import 'package:imtapp/routes/routes.dart';
import 'package:imtapp/widgets/custom_button_widget.dart';
import 'package:imtapp/widgets/custom_form_widget.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final isActive = false;
  String? errorMessage = "";

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      Get.toNamed(RoutesClass.home);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage?.tr() ?? 'Unknown error')),
      );
      print(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    const appName = "ImtApp";
    const animationSignupAsset = 'assets/lottie/AnimationLogin.json';
    final isObscureController = Get.put(PasswordController());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
            left: deviceHeight * 0.01,
            right: deviceHeight * 0.01,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: deviceHeight * 0.1),
              Center(
                child: Lottie.asset(animationSignupAsset,
                    height: deviceHeight * 0.25),
              ),
              Text(
                appName,
                style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.08,
              ),
              CustomFormWidget(
                controller: email,
                labelText: "email".tr(),
                icon: const Icon(Icons.email,
                    color: Color.fromARGB(255, 99, 78, 145)),
              ),
              Padding(
                padding: EdgeInsets.all(deviceHeight * 0.01),
                child: Obx(() => TextFormField(
                      obscureText: isObscureController.isObscure.value,
                      controller: password,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () => isObscureController.changeObscure(),
                          icon: Icon(
                            isObscureController.isObscure.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        labelText: "password".tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        prefixIcon: const Icon(Icons.password,
                            color: Color.fromARGB(255, 99, 78, 145)),
                      ),
                    )),
              ),
              CustomButtonWidget(
                btnText: "login".tr(),
                onpressed: () async {
                  await signInWithEmailAndPassword(context);
                },
                onPressed: () {},
              ),
              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?".tr()),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(RoutesClass.signup);
                      },
                      child: Text(
                        "signup".tr(),
                        style: const TextStyle(
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
