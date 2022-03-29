import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/components/custom_elevated_button_icon.dart';
import 'package:survey_stunting/controllers/isi_survey.controller.dart';

class IsiSurveyScreen extends StatelessWidget {
  const IsiSurveyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<IsiSurveyController>(
      builder: (controller) => Scaffold(
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
                runSpacing: size.height * 0.02,
                children: [
                  Text(
                    "Isi Survey",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  Obx(
                    () => Visibility(
                      visible: !controller.isLoading.value,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: Wrap(
                        runSpacing: 20,
                        children: [
                          ...controller.soalAndJawaban.map((value) {
                            return controller.generateSoalUI(
                              context: context,
                              soal: value.soal.soal,
                              soalId: value.soal.id,
                              typeJawaban: value.soal.tipeJawaban,
                              jawaban: value.jawabanSoal,
                            );
                          }).toList(),
                          Center(
                            child: CustomElevatedButtonIcon(
                              label: "Selanjutnya",
                              icon: SvgPicture.asset(
                                "assets/icons/outline/arrow-right2.svg",
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                          )
                        ],
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
  }
}
