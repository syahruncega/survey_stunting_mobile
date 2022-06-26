import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

void synchronizeDialog(RxBool loading, Size size) {
  Get.defaultDialog(
    title: '',
    barrierDismissible: false,
    onWillPop: () async {
      Fluttertoast.showToast(
        msg: "Mohon tunggu proses sinkronisasi",
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return false;
    },
    content: Obx(
      () => Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              child: LottieBuilder.asset(
                loading.value
                    ? 'assets/anim/sync-data-phone.json'
                    : 'assets/anim/loading-completed.json',
                width: size.width * 0.5,
              ),
            ),
            Visibility(
              visible: loading.value,
              child: SizedBox(
                child: LottieBuilder.asset(
                  'assets/anim/loading-dot.json',
                  width: 70,
                  height: 70,
                ),
              ),
            ),
          ],
        ),
        // ),
      ),
    ),
  );
}
