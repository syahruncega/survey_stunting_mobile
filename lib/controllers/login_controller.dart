import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';

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

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  // @override
  // onClose() {
  //   usernameNode.dispose();
  //   super.onClose();
  // }
}
