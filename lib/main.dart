import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:imtapp/firebase/auth.dart';
import 'package:imtapp/lang/constants.dart';
import 'package:imtapp/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  await Future.delayed(
    const Duration(seconds: 3),
  );
  FlutterNativeSplash.remove();

  await Firebase.initializeApp();
  runApp(EasyLocalization(
    supportedLocales: const [
      LocaleConstants.trLocale,
      LocaleConstants.enLocale,
    ],
    saveLocale: true,
    fallbackLocale: LocaleConstants.enLocale,
    path: LocaleConstants.localePath,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'İMT App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Auth().currentUser == null
          ? RoutesClass.getLoginRoute()
          : RoutesClass.getHomeRoute(),
      getPages: RoutesClass.routes,
    );
  }
}
