import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../consts/colors.dart';
import '../../controllers/sinkronisasi_controller.dart';

class SinkronisasiScreen extends StatelessWidget {
  const SinkronisasiScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<SinkronisasiController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: SvgPicture.asset(
              "assets/icons/outline/arrow-left.svg",
              color: Theme.of(context).textTheme.headline1!.color,
            ),
          ),
        ),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(color: primaryColor),
                )
              : SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: SingleChildScrollView(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runSpacing: size.height * 0.02,
                        children: [
                          Text(
                            "Sinkronisasi",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          SizedBox(
                            height: size.height * 0.06,
                          ),
                          Center(
                              child: Column(children: <Widget>[
                            SvgPicture.asset(
                                "assets/images/sync-illustration.svg",
                                height: size.height * 0.2),
                            const SizedBox(height: 15),
                            Text('Terakhir kali pada :',
                                style: GoogleFonts.kodchasan(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(controller.lastSync.value,
                                style: GoogleFonts.kodchasan(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                )),
                          ])),
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                controller.synchronizeStatus.value == 'waiting'
                                    ? null
                                    : await controller.synchronize();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: controller.synchronizeStatus.value !=
                                      'waiting'
                                  ? SvgPicture.asset(
                                      "assets/icons/outline/synchronize.svg",
                                      color: Colors.white,
                                    )
                                  : Container(
                                      width: 24,
                                      height: 24,
                                      padding: const EdgeInsets.all(2.0),
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    ),
                              label: Text(
                                "Sinkron Sekarang",
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      );
    });
  }
}
