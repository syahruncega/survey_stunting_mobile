import 'package:get/get.dart';
import 'package:survey_stunting/bindings/layout_binding.dart';
import 'package:survey_stunting/bindings/login_binding.dart';
import 'package:survey_stunting/pages/Login/login_screen.dart';
import 'package:survey_stunting/pages/layout.dart';
import 'package:survey_stunting/routes/route_name.dart';

class AppPage {
  static final pages = [
    GetPage(
      name: RouteName.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: RouteName.layout,
      page: () => Layout(),
      binding: LayoutBinding(),
    ),
  ];
}
