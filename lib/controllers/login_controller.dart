import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_stunting/components/error_scackbar.dart';
import 'package:survey_stunting/models/auth.dart';
import 'package:survey_stunting/models/session.dart';
import 'package:survey_stunting/routes/route_name.dart';

import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';

class LoginController extends GetxController {
  final username = TextEditingController();
  final password = TextEditingController();
  final usernameError = "".obs;
  final passwordError = "".obs;
  final FocusNode usernameNode = FocusNode();
  final passwordNode = FocusNode();

  bool validate() {
    usernameError.value = "";
    passwordError.value = "";

    if (username.text.trim().isEmpty) {
      usernameError.value = 'Username harus diiisi';
    }
    if (password.text.trim().isEmpty) {
      passwordError.value = "Password harus diisi";
    }

    if (usernameError.value.isNotEmpty || passwordError.value.isNotEmpty) {
      return false;
    }
    return true;
  }

  Future login() async {
    final DioClient _dioClient = DioClient();
    Auth auth = Auth(username: username.text, password: password.text);
    try {
      Session? session = await _dioClient.login(loginInfo: auth);
      GetStorage().write("token", session?.token);
      Get.offAllNamed(RouteName.layout);
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        errorScackbar('Username atau password salah');
      } else {
        handleError(error: e);
      }
    }
  }
}
