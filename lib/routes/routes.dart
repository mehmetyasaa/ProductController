import 'package:get/get_navigation/get_navigation.dart';
import 'package:imtapp/screens/home_page.dart';
import 'package:imtapp/screens/login.dart';
import 'package:imtapp/screens/signup.dart';
import 'package:imtapp/service/deneme.dart';

class RoutesClass {
  static String home = "/";
  static String signup = "/signup";
  static String login = "/login";
  static String local = "/local";

  static String getHomeRoute() => home;
  static String getSignupRoute() => signup;
  static String getLoginRoute() => login;
  static String getLocalRoute() => local;

  static List<GetPage> routes = [
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: local, page: () => ProductsPage()),
    GetPage(
        name: login,
        page: () => LoginPage(),
        transition: Transition.fade,
        transitionDuration: const Duration(seconds: 1)),
    GetPage(
        name: signup,
        page: () => SignupPage(),
        transition: Transition.fade,
        transitionDuration: const Duration(seconds: 1)),
  ];
}
