// ignore: file_names
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imtapp/firebase/auth.dart';
import 'package:imtapp/routes/routes.dart';
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
    double deviceHeight = MediaQuery.of(context).size.height;
    const appName = "ImtApp";
    const animationSignupAsset = 'assets/lottie/AnimationSignup.json';

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
            left: deviceHeight * 0.01,
            right: deviceHeight * 0.01,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: deviceHeight * 0.08),
              Center(
                  child: Lottie.asset(animationSignupAsset,
                      height: deviceHeight * 0.20)),
              Text(
                appName,
                style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.displaySmall),
              ),
              SizedBox(
                height: deviceHeight * 0.04,
              ),
              customTextForm(
                name,
                "name".tr(),
                const Icon(Icons.account_box,
                    color: Color.fromARGB(255, 99, 78, 145)),
              ),
              customTextForm(
                email,
                "email".tr(),
                const Icon(Icons.email,
                    color: Color.fromARGB(255, 99, 78, 145)),
              ),
              customTextForm(
                phone,
                "phone".tr(),
                const Icon(Icons.phone,
                    color: Color.fromARGB(255, 99, 78, 145)),
              ),
              customTextForm(
                password,
                "password".tr(),
                const Icon(Icons.password,
                    color: Color.fromARGB(255, 99, 78, 145)),
              ),
              CustomButtonWidget(
                btnText: "signup".tr(),
                onpressed: () async {
                  await Auth().createUserWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                      displayName: name.text,
                      phone: int.parse(phone.text));
                  Get.toNamed("/");
                },
                onPressed: () {},
              ),
              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an Account ?".tr()),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(RoutesClass.login);
                      },
                      child: Text(
                        "login".tr(),
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

//diğer textform ile birleştirilecek
  Padding customTextForm(
      TextEditingController? controller, String labelText, Widget icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        textInputAction: TextInputAction.next,
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
