import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:survey_stunting/consts/colors.dart';
import 'package:survey_stunting/routes/app_page.dart';
import 'package:survey_stunting/routes/route_name.dart';
import 'package:survey_stunting/services/dio_client.dart';

import 'models/localDb/helpers.dart';
import 'models/user_profile.dart';

late final Objectbox objectbox;
Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  Get.put<GetStorage>(GetStorage());
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await Objectbox.create();
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
          bodyText2: TextStyle(
            color: textColor,
            fontSize: 14,
          ),
          bodyText1: TextStyle(
            color: textColor,
            fontSize: 14,
          ),
          headline1: TextStyle(
            color: textColor,
            fontSize: 26,
            letterSpacing: 0,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            color: textColor,
            fontSize: 18,
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
            fontSize: 14,
          ),
          bodyText2: TextStyle(
            color: hintColor,
            fontSize: 14,
          ),
          headline1: TextStyle(
            color: Colors.white,
            fontSize: 26,
            letterSpacing: 0,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            color: Colors.white,
            fontSize: 18,
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
        drawerTheme: const DrawerThemeData(
          backgroundColor: scaffoldBackgroundDark,
        ),
      ),
      themeMode: ThemeMode.light,
      home: const Wrapper(),
      // initialRoute: RouteName.login,
      getPages: AppPage.pages,
    );
  }
}

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);
  @override
  WrapperState createState() => WrapperState();
}

class WrapperState extends State<Wrapper> {
  @override
  void initState() {
    sessionCheck();
    super.initState();
  }

  @override
  void dispose() {
    // objectbox.store.close();
    // objectbox.admin.close();
    super.dispose();
  }

  void sessionCheck() async {
    await GetStorage.init();
    final box = Get.find<GetStorage>();
    final session = box.read('token');
    if (session == null) {
      Get.offAllNamed(RouteName.login);
    } else {
      await checkProfile(session);
    }
  }

  Future checkProfile(final token) async {
    UserProfile? profileData = await DioClient().getProfile(token: token);
    if (profileData == null) {
      Get.toNamed(RouteName.lengkapiProfil);
    } else {
      Get.offAllNamed(RouteName.layout);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
