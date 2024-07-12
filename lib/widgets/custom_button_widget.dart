import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    super.key,
    this.onpressed,
    required this.btnText,
    required Function() onPressed,
  });

  final String btnText;
  final void Function()? onpressed;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return FilledButton.tonal(
      onPressed: onpressed,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: deviceHeight * 0.014, horizontal: deviceHeight * 0.13),
        child: Text(
          btnText,
          style: GoogleFonts.lato(
              textStyle: Theme.of(context).textTheme.titleLarge),
        ),
      ),
    );
  }
}
