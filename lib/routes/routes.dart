import 'package:get/get_navigation/get_navigation.dart';
import 'package:productcontroler/screens/home_page.dart';
import 'package:productcontroler/screens/login.dart';
import 'package:productcontroler/screens/signup.dart';

class RoutesClass {
  static String home = "/";
  static String signup = "/signup";
  static String login = "/login";
  static String details = "/details";
  static String deneme = "/deneme";

  static String getHomeRoute() => home;
  static String getSignupRoute() => signup;
  static String getLoginRoute() => login;
  static String getDetailsRoute() => details;
  static String getDenemeRoute() => deneme;

  static List<GetPage> routes = [
    GetPage(name: home, page: () => HomePage()),
    GetPage(
        name: login,
        page: () => LoginPage(),
        transition: Transition.fade,
        transitionDuration: const Duration(seconds: 1)),
    // GetPage(
    //     name: details,
    //     page: () => ProductDetailsPage(),
    //     transition: Transition.fade,
    //     transitionDuration: const Duration(seconds: 1)),
    GetPage(
        name: signup,
        page: () => SignupPage(),
        transition: Transition.fade,
        transitionDuration: const Duration(seconds: 1)),
  ];
}
