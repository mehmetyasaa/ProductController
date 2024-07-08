import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    super.key,
    this.onpressed,
    required this.btnText,
  });

  final String btnText;
  final void Function()? onpressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onpressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 110),
        child: Text(
          btnText,
          style: GoogleFonts.lato(
              textStyle: Theme.of(context).textTheme.titleLarge),
        ),
      ),
    );
  }
}
