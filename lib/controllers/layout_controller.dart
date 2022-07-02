import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_stunting/controllers/sync_data_controller.dart';

import '../models/localDb/helpers.dart';

import '../consts/globals_lib.dart' as global;

class LayoutController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime backButtonPressedTime = DateTime.now();
  bool canExit = false;

  var tabIndex = 0;

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    bool cannotExit = !canExit ||
        currentTime.difference(backButtonPressedTime) >
            const Duration(milliseconds: 1500);

    if (cannotExit) {
      backButtonPressedTime = currentTime;
      Fluttertoast.showToast(
        msg: "Tekan sekali lagi untuk keluar",
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return false;
    }
    return true;
  }

  void changeTabIndex(int index) {
    tabIndex = index;
    if (tabIndex == 3) {
      global.isFabVisible.value = false;
    } else {
      global.isFabVisible.value = true;
    }
    update();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  Future checkConnection() async {
    log('checking connection..');
    bool connect = await global.isConnected();
    final prefs = await SharedPreferences.getInstance();
    if (connect) {
      bool firstInstall_ = await firstInstall();
      if (firstInstall_) {
        debugPrint('FIRST_INSTALL');
        showDialog(scaffoldKey.currentContext!);
        await SyncDataController(store_: Objectbox.store_).pullDataFromServer();
        prefs.setBool('first_install', false);
        Navigator.pop(scaffoldKey.currentContext!);
      } else {
        debugPrint('ALREADY INSTALLED BEFORE');
        SyncDataController(store_: Objectbox.store_).syncData(syncAll: false);
      }
    }
  }

  Future<bool> firstInstall() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("first_install") ?? true;
  }

  @override
  void onInit() async {
    await checkConnection();

    Future.delayed(const Duration(milliseconds: 1500), () {
      canExit = true;
    });
    super.onInit();
  }

  void showDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.defaultDialog(
      title: '',
      barrierDismissible: false,
      content: WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Mohon tunggu..',
                  style: TextStyle(
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontWeight: FontWeight.bold,
                  )),
              LottieBuilder.asset(
                'assets/anim/loading-dot.json',
                width: size.width * 0.2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
