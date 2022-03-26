import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/components/filled_text_field.dart';
import 'package:survey_stunting/consts/colors.dart';
import 'package:survey_stunting/controllers/ubah_akun_controller.dart';

class UbahAkunScreen extends StatefulWidget {
  const UbahAkunScreen({Key? key}) : super(key: key);

  @override
  State<UbahAkunScreen> createState() => _UbahAkunScreenState();
}

class _UbahAkunScreenState extends State<UbahAkunScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UbahAkunController ubahAkunController = Get.put(UbahAkunController());
    return GetBuilder<UbahAkunController>(builder: (controller) {
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
          // title: Text(
          //   "Dahboard",
          //   style: Theme.of(context).textTheme.titleLarge,
          // ),
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
                            "Ubah Akun",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          SizedBox(
                            height: size.height * 0.06,
                          ),
                          FilledTextField(
                            controller: controller.username,
                            errorText: controller.usernameError.value,
                            title: "Nama Pengguna",
                            textInputAction: TextInputAction.next,
                          ),
                          FilledTextField(
                            controller: controller.password,
                            title: "Kata Sandi",
                            obsecureText: !controller.showPassword.value,
                            errorText: controller.passwordError.value,
                            suffixIcon: IconButton(
                              icon: SvgPicture.asset(
                                controller.showPassword.value
                                    ? "assets/icons/bold/eye.svg"
                                    : "assets/icons/bold/eye-slash.svg",
                                color: Theme.of(context)
                                    .primaryColor
                                    .withAlpha(125),
                              ),
                              onPressed: () => controller.showPassword.value =
                                  !controller.showPassword.value,
                            ),
                            textInputAction: TextInputAction.next,
                            helperText:
                                "Biarkan kosong apabila tidak ingin mengubah kata sandi.",
                          ),
                          FilledTextField(
                            controller: controller.passwordConfirm,
                            title: "Konfirmasi Kata Sandi",
                            obsecureText: !controller.showPassword.value,
                            errorText: controller.passwordConfirmError.value,
                            suffixIcon: IconButton(
                              icon: SvgPicture.asset(
                                controller.showPassword.value
                                    ? "assets/icons/bold/eye.svg"
                                    : "assets/icons/bold/eye-slash.svg",
                                color: Theme.of(context)
                                    .primaryColor
                                    .withAlpha(125),
                              ),
                              onPressed: () => controller.showPassword.value =
                                  !controller.showPassword.value,
                            ),
                            textInputAction: TextInputAction.done,
                            helperText:
                                "Biarkan kosong apabila tidak ingin mengubah kata sandi.",
                          ),
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                String username =
                                    controller.username.value.text;
                                String? password = controller.password.text;

                                controller.akunUpdateStatus.value == 'waiting'
                                    ? null
                                    : controller.updateAkun(
                                        username: username, password: password);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: controller.akunUpdateStatus.value == '' ||
                                      controller.akunUpdateStatus.value ==
                                          'failed' ||
                                      controller.akunUpdateStatus.value ==
                                          'successful'
                                  ? SvgPicture.asset(
                                      "assets/icons/outline/tick-square.svg",
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
                                "Simpan",
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
