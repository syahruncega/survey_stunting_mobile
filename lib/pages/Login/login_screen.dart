import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/controllers/login_controller.dart';
import 'package:survey_stunting/pages/Login/components/login_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LoginController());
    return Scaffold(
      body: LoginBody(),
    );
  }
}
