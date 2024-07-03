import 'package:flutter/material.dart';

class CustomFormWidget extends StatelessWidget {
  const CustomFormWidget({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
  });

  final TextEditingController? controller;
  final String labelText;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    const paddingAllCustomForm = 8.0;
    return Padding(
      padding: const EdgeInsets.all(
          value), //TODO: responsive tasarım olsun. statik değerler kullanma
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
