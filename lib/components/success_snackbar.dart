import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:survey_stunting/consts/colors.dart';

dynamic successSnackbar(String message) {
  return Get.snackbar(
    'Berhasil',
    message,
    snackPosition: SnackPosition.TOP,
    margin: const EdgeInsets.all(20),
    backgroundColor: secondary,
    // backgroundColor: Colors.red.shade300,
    colorText: Colors.white,
  );
}
