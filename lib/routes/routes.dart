import 'package:get/get_navigation/get_navigation.dart';
import 'package:imtapp/screens/home_page.dart';
import 'package:imtapp/screens/login.dart';
import 'package:imtapp/screens/signup.dart';

class RoutesClass {
  static String home = "/";
  static String signup = "/signup";
  static String login = "/login";

  static String getHomeRoute() => home;
  static String getSignupRoute() => signup;
  static String getLoginRoute() => login;

  static List<GetPage> routes = [
    GetPage(name: home, page: () => HomePage()),
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
