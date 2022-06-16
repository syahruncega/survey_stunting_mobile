import 'package:get/get.dart';

import 'package:flutter/material.dart';

dynamic successScackbar(String message) {
  return Get.snackbar(
    'Berhasil',
    message,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(20),
    backgroundColor: Colors.green.shade300,
    colorText: Colors.white,
  );
}
