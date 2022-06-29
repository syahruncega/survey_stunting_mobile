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

import '../models/user_profile.dart';

class LoginController extends GetxController {
  final username = TextEditingController();
  final password = TextEditingController();
  final usernameError = "".obs;
  final passwordError = "".obs;
  final showPassword = false.obs;

  bool validate() {
    usernameError.value = "";
    passwordError.value = "";

    if (username.text.trim().isEmpty) {
      usernameError.value = 'Nama pengguna wajib diisi';
    }
    if (password.text.trim().isEmpty) {
      passwordError.value = "Kata sandi wajib diisi";
    }

    if (usernameError.value.isNotEmpty || passwordError.value.isNotEmpty) {
      return false;
    }
    return true;
  }

  Future login() async {
    if (validate()) {
      final DioClient _dioClient = DioClient();
      Auth auth = Auth(username: username.text, password: password.text);
      try {
        Session? session = await _dioClient.login(loginInfo: auth);
        GetStorage().write("token", session?.token);
        GetStorage().write("userId", session?.data.id);
        GetStorage().write("session", sessionToJson(session!));

        UserProfile? profileData =
            await DioClient().getProfile(token: session.token);
        if (profileData == null) {
          Get.toNamed(RouteName.lengkapiProfil);
        } else {
          Get.offAllNamed(RouteName.layout);
        }
      } on DioError catch (e) {
        if (e.response?.statusCode == 401) {
          errorScackbar('Nama pengguna atau kata sandi salah');
        } else {
          handleError(error: e);
        }
      }
    }
  }
}
