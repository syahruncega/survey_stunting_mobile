import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:survey_stunting/pages/Login/login_screen.dart';
import 'package:survey_stunting/routes/app_page.dart';
import 'package:survey_stunting/routes/route_name.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Survey Stunting',
      theme: FlexThemeData.light(
        scheme: FlexScheme.ebonyClay,
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.ebonyClay),
      themeMode: ThemeMode.light,
      home: const LoginScreen(),
      initialRoute: RouteName.login,
      getPages: AppPage.pages,
    );
  }
}
