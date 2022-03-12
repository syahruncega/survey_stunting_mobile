import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/components/elevated_icon_button.dart';
import 'package:survey_stunting/components/filled_autocomplete.dart';
import 'package:survey_stunting/components/filled_text_field.dart';
import 'package:survey_stunting/controllers/survey_controller.dart';

class SurveyScreen extends StatelessWidget {
  SurveyScreen({Key? key}) : super(key: key);
  final surveyController = Get.find<SurveyController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Survey",
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          SizedBox(
            height: size.height * 0.04,
          ),
          Row(
            children: [
              Flexible(
                child: FilledTextField(
                  hintText: "Cari...",
                  prefixIcon: SvgPicture.asset(
                    "assets/icons/outline/search-2.svg",
                    color: Theme.of(context).hintColor,
                    height: 22,
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.03,
              ),
              ElevatedIconButton(
                icon: SvgPicture.asset(
                  "assets/icons/outline/setting-4.svg",
                  color: Colors.white,
                ),
                onTap: () {
                  Get.defaultDialog(
                    title: "Filter",
                    onConfirm: () {},
                    onCancel: () {},
                    textCancel: "Batal",
                    textConfirm: "Proses",
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Jenis Survey",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        FilledAutocomplete(
                          hintText: "Pilih jenis survey",
                          controller: surveyController.jenisSurvey,
                          items: const ["Semua", "Pre", "Post"],
                        ),
                        SizedBox(height: size.height * 0.03),
                        const Text(
                          "Status Survey",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        FilledAutocomplete(
                          hintText: "Pilih status survey",
                          controller: surveyController.statusSurvey,
                          items: const ["Semua", "Selesai", "Belum Selesai"],
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
