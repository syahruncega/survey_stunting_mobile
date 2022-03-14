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

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Survey Stunting',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: primaryColor,
        hintColor: hintColor,
        fontFamily: GoogleFonts.inter().fontFamily,
        inputDecorationTheme:
            const InputDecorationTheme(fillColor: Colors.white),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
          primary: primaryColor,
          secondary: secondary,
        ),
        textTheme: const TextTheme(
          button: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            color: textColor,
          ),
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
        scaffoldBackgroundColor: scaffoldBackground,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        primaryColor: primaryColor,
        hintColor: hintColor,
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color.fromARGB(255, 30, 35, 53),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 30, 35, 53),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
          primary: primaryColor,
          secondary: secondary,
        ),
        fontFamily: GoogleFonts.inter().fontFamily,
        textTheme: const TextTheme(
          button: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          bodyText2: TextStyle(
            color: hintColor,
            fontSize: 12,
          ),
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
        scaffoldBackgroundColor: scaffoldBackgroundDark,
      ),
      themeMode: ThemeMode.light,
      home: const LoginScreen(),
      initialRoute: RouteName.login,
      getPages: AppPage.pages,
    );
  }
}
