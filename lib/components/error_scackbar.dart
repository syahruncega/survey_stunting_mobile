import 'package:get/get.dart';

import 'package:flutter/material.dart';

dynamic errorScackbar(String message) {
  return Get.snackbar(
    'Terjadi Kesalahan',
    message,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(20),
    backgroundColor: Colors.red.shade300,
    colorText: Colors.white,
  );
}
