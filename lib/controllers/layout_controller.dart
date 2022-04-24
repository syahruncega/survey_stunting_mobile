import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_stunting/controllers/sync_data_controller.dart';

import '../models/localDb/helpers.dart';
import '../services/dio_client.dart';
import '../services/handle_errors.dart';

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

  Future checkConnection() async {
    log('checking connection..');
    final prefs = await SharedPreferences.getInstance();
    try {
      bool response = await DioClient().testConnection(
        token: GetStorage().read("token"),
      );
      if (response) {
        prefs.setBool("offline_mode", false);
        SyncDataController(store_: Objectbox.store_).syncDataFromServer();
      } else {
        prefs.setBool("offline_mode", true);
        Fluttertoast.showToast(
          msg: "Tidak ada koneksi Internet",
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
      }
    } on DioError catch (e) {
      prefs.setBool("offline_mode", true);
      Fluttertoast.showToast(
        msg: "Tidak ada koneksi Internet",
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      handleError(error: e);
    }
  }

  @override
  void onInit() async {
    await checkConnection();
    Future.delayed(const Duration(milliseconds: 1500), () {
      canExit = true;
    });
    super.onInit();
  }
}
