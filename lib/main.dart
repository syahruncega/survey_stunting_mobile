import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:survey_stunting/consts/colors.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: GoogleFonts.inter().fontFamily,
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: kTextColor),
        ),
      ),
      home: const LoginScreen(),
      initialRoute: RouteName.login,
      getPages: AppPage.pages,
    );
  }
}
