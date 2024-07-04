import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:imtapp/local.dart';
import 'package:imtapp/screens/homepage.dart';
import 'package:imtapp/screens/login.dart';
import 'package:imtapp/screens/signup.dart';

class RoutesClass {
  static String home = "/";
  static String signup = "/signup";
  static String login = "/login";
  static String local = "/local";

  static String getHomeRoute() => home;
  static String getSignupRoute() => signup;
  static String getLoginRoute() => login;
  static String getLocalRoute() => local; //localizations deneme ekranı

  static List<GetPage> routes = [
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: local, page: () => LocalScreen()),
    GetPage(
        name: login,
        page: () => LoginPage(),
        transition: Transition.fade,
        transitionDuration: Duration(seconds: 1)),
    GetPage(
        name: signup,
        page: () => SignupPage(),
        transition: Transition.fade,
        transitionDuration: Duration(seconds: 1)),
  ];
}
