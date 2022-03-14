import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:survey_stunting/consts/colors.dart';
import 'package:survey_stunting/pages/Login/login_screen.dart';
import 'package:survey_stunting/routes/app_page.dart';
import 'package:survey_stunting/routes/route_name.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final FlexSchemeColor _myFlexScheme = const FlexSchemeColor(
    primary: primaryColor,
    primaryVariant: primaryVariant,
    secondary: secondary,
    secondaryVariant: secondaryVariant,
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Survey Stunting',
      theme: FlexThemeData.light(
        colors: _myFlexScheme,
        fontFamily: GoogleFonts.inter().fontFamily,
        textTheme: const TextTheme(
          button: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          bodyText1: TextStyle(color: textColor),
          headline1: TextStyle(
            color: textColor,
            fontSize: 26,
            letterSpacing: 0,
            fontWeight: FontWeight.bold,
          ),
          headline3: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        scaffoldBackground: scaffoldBackground,
      ),
      darkTheme: FlexThemeData.dark(
        colors: _myFlexScheme.toDark(),
        fontFamily: GoogleFonts.inter().fontFamily,
        textTheme: const TextTheme(
          button: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          headline1: TextStyle(
            color: Colors.white,
            fontSize: 26,
            letterSpacing: 0,
            fontWeight: FontWeight.bold,
          ),
          headline3: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        scaffoldBackground: scaffoldBackgroundDark,
      ),
      themeMode: ThemeMode.light,
      home: const LoginScreen(),
      initialRoute: RouteName.login,
      getPages: AppPage.pages,
    );
  }
}
