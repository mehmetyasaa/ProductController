import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imtapp/controllers/passwordController.dart';
import 'package:imtapp/screens/homepage.dart';
import 'package:imtapp/screens/signup.dart';
import 'package:imtapp/widgets/custom_button_widget.dart';
import 'package:imtapp/widgets/custom_form_widget.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final isActive = false;

  @override
  Widget build(BuildContext context) {
    const appName = "ImtApp";
    const animationSignupAsset = 'assets/lottie/AnimationLogin.json';
    final isObscureController = Get.put(PasswordController());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Lottie.asset(animationSignupAsset, height: 250)),
            Text(
              appName,
              style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.displaySmall),
            ),
            const SizedBox(
              height: 60,
            ),
            CustomFormWidget(
                controller: email,
                labelText: "Mail",
                icon: const Icon(Icons.email,
                    color: Color.fromARGB(255, 99, 78, 145))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() => TextFormField(
                    obscureText: isObscureController.isObscure.value,
                    controller: password,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () =>
                                isObscureController.changeObscure(),
                            icon: Icon(isObscureController.isObscure.value
                                ? Icons.visibility
                                : Icons.visibility_off)),
                        labelText: "Şifre",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        prefixIcon: const Icon(Icons.password,
                            color: Color.fromARGB(255, 99, 78, 145))),
                  )),
            ),
            CustomButtonWidget(
              btnText: "Giriş Yap",
              onpressed: () {
                Get.to(HomePage());
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Üye değil misiniz?"),
                  TextButton(
                    onPressed: () {
                      Get.to(SignupPage());
                    },
                    child: const Text(
                      "Kayıt Ol",
                      style: TextStyle(
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
    );
  }
}
