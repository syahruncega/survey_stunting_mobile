import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/state_manager.dart';
import 'package:survey_stunting/controllers/sync_data_controller.dart';

import '../models/localDb/helpers.dart';

late final Objectbox objectbox;

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
    update();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  void onInit() async {
    // objectbox = await Objectbox.create();
    // SyncDataController(store_: objectbox.store).syncDataFromServer();
    Future.delayed(const Duration(milliseconds: 1500), () {
      canExit = true;
    });
    super.onInit();
  }
}
