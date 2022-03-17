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
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: size.height * 0.04,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    buttonColor: Theme.of(context).colorScheme.secondary,
                    confirmTextColor: Colors.white,
                    title: "Filter",
                    onConfirm: () {},
                    onCancel: () {},
                    textCancel: "Batal",
                    textConfirm: "Proses",
                    content: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runSpacing: size.height * 0.03,
                      children: [
                        FilledAutocomplete(
                          title: "Jenis Survey",
                          hintText: "Pilih jenis survey",
                          controller: surveyController.jenisSurvey,
                          items: const ["Semua", "Pre", "Post"],
                        ),
                        FilledAutocomplete(
                          title: "Status Survey",
                          hintText: "Pilih status survey",
                          controller: surveyController.statusSurvey,
                          items: const ["Semua", "Selesai", "Belum Selesai"],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await surveyController.getAllSurvey();
            },
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: SvgPicture.asset("assets/icons/outline/add-square.svg",
                color: Colors.white),
            label: Text(
              "Tambah",
              style: Theme.of(context).textTheme.button,
            ),
          ),
          Expanded(
            child: Obx(
              () => Visibility(
                visible: surveyController.isLoaded.value,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: ListView.builder(
                  itemCount: surveyController.surveys.value.length,
                  itemBuilder: (context, index) {
                    return const Text("Hi");
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
