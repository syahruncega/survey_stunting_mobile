import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/components/filled_autocomplete.dart';
import 'package:survey_stunting/controllers/export_survey_controller.dart';

class ExportSurveyScreen extends StatelessWidget {
  ExportSurveyScreen({Key? key}) : super(key: key);
  final exportSurveyController = Get.find<ExportSurveyController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Export Survey",
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          // const Text(
          //   "Memorandum Of Agreement",
          //   style: TextStyle(fontSize: 14, color: kHintColor),
          // )
          SizedBox(height: size.height * 0.04),
          FilledAutocomplete(
            controller: exportSurveyController.jenisSurvey,
            hintText: "Pilih jenis survey",
            items: const ["Pre", "Post"],
          )
        ],
      ),
    );
  }
}
