import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/components/custom_elevated_button_icon.dart';
import 'package:survey_stunting/controllers/isi_survey.controller.dart';

class IsiSurveyScreen extends StatelessWidget {
  const IsiSurveyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IsiSurveyController>(builder: (controller) {
      controller.currentJawabanSurvey = [];
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                runSpacing: 20,
                children: [
                  Text(
                    "Isi Survey",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => Visibility(
                      visible: !controller.isLoading.value,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: Form(
                        key: controller.formKey,
                        child: Wrap(
                          runSpacing: 20,
                          children: [
                            Center(
                              child: Text(
                                controller.title.value,
                                style: Theme.of(context).textTheme.headline2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ...controller.soalAndJawaban.map((value) {
                              var index =
                                  controller.soalAndJawaban.indexOf(value);
                              return controller.generateSoalUI(
                                number: index + 1,
                                context: context,
                                soal: value.soal.soal,
                                soalId: value.soal.id,
                                typeJawaban: value.soal.tipeJawaban,
                                jawabanSoal: value.jawabanSoal,
                              );
                            }).toList(),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (controller.currentOrder > 1)
                                    CustomElevatedButtonIcon(
                                      label: "Kembali",
                                      icon: SvgPicture.asset(
                                        "assets/icons/outline/arrow-left.svg",
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        if (!controller.isLoadingNext.value) {
                                          await controller.previousCategory();
                                        }
                                      },
                                    ),
                                  if (controller.currentOrder > 1)
                                    const SizedBox(
                                      width: 8,
                                    ),
                                  CustomElevatedButtonIcon(
                                    label: "Selanjutnya",
                                    icon: SvgPicture.asset(
                                      "assets/icons/outline/arrow-right2.svg",
                                      color: Colors.white,
                                    ),
                                    isLoading: controller.isLoadingNext.value,
                                    onPressed: () async {
                                      await controller.submitForm();
                                    },
                                  ),
                                ])
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
