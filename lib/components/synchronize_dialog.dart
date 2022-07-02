import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../controllers/sinkronisasi_controller.dart';

Future synchronizeDialog(BuildContext context) async {
  final syncController = SinkronisasiController();
  var loading = true.obs;
  Size size = MediaQuery.of(context).size;
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
  await syncController.synchronize();
  loading.value = false;
  await Future.delayed(const Duration(seconds: 3));
  Navigator.pop(context);
}
