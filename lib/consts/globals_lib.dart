library globals;

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_storage/get_storage.dart';

import '../services/dio_client.dart';

var offlineMode = false.obs;
var syncCompleted = false.obs;
var isFabVisible = true.obs;

/// Return true if connected
Future<bool> isConnected() async {
  try {
    bool response = await DioClient().testConnection(
      token: GetStorage().read("token"),
    );
    if (response) {
      offlineMode.value = false;
      return true;
    }
    offlineMode.value = true;
    return false;
  } on DioError catch (e) {
    log('something Wrong on checking network connection :' + e.toString());
    offlineMode.value = true;
    return false;
  }
}
