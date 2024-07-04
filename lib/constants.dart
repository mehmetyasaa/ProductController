import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocaleConstants {
  static const trLocale = Locale("tr", "TR");
  static const enLocale = Locale("en", "US");
  static const localePath = "assets/lang";
}

extension LocaleExtension on String {
  String get trLocale => this.tr().toString();
}
