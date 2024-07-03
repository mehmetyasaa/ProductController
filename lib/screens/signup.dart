// ignore: file_names
import "package:flutter/material.dart";
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imtapp/screens/login.dart';
import 'package:imtapp/widgets/custom_button_widget.dart';
import 'package:lottie/lottie.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const appName = "ImtApp";
    const animationSignupAsset = 'assets/lottie/AnimationSignup.json';
    const signupText = 'Üye Ol';
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Lottie.asset(animationSignupAsset, height: 200)),
            Text(
              appName,
              style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.displaySmall),
            ),
            const SizedBox(
              height: 60,
            ),
            customTextForm(
              name,
              "İsim",
              const Icon(Icons.account_box,
                  color: Color.fromARGB(255, 99, 78, 145)),
            ),
            customTextForm(
              email,
              "Mail",
              const Icon(Icons.email, color: Color.fromARGB(255, 99, 78, 145)),
            ),
            customTextForm(
              phone,
              "Telefon",
              const Icon(Icons.phone, color: Color.fromARGB(255, 99, 78, 145)),
            ),
            customTextForm(
              password,
              "Şifre",
              const Icon(Icons.password,
                  color: Color.fromARGB(255, 99, 78, 145)),
            ),
            const CustomButtonWidget(btnText: signupText),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Zaten üye misiniz?"),
                  TextButton(
                    onPressed: () {
                      Get.to(LoginPage());
                    },
                    child: const Text(
                      "Giriş Yap",
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

  Padding customTextForm(
      TextEditingController? controller, String labelText, Widget icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            prefixIcon: icon),
      ),
    );
  }
}
