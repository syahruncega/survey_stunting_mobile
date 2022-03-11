import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/controllers/export_survey_controller.dart';

class ExportSurveyScreen extends StatelessWidget {
  ExportSurveyScreen({Key? key}) : super(key: key);
  final surveyController = Get.find<ExportSurveyController>();

  static const surveyType = ["Pre", "Post"];

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
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              decoration: InputDecoration(
                hintText: "Pilih tipe survey",
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      BorderSide(color: Theme.of(context).secondaryHeaderColor),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: SvgPicture.asset(
                    "assets/icons/outline/arrow-down.svg",
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
              controller: surveyController.tipeSurvey,
            ),
            suggestionsCallback: (pattern) => surveyType.where((element) =>
                element.toLowerCase().contains(pattern.toLowerCase())),
            itemBuilder: (_, String suggestion) => ListTile(
              title: Text(suggestion),
            ),
            getImmediateSuggestions: true,
            onSuggestionSelected: (String suggestion) {
              surveyController.tipeSurvey.text = suggestion;
            },
            noItemsFoundBuilder: (context) => const Padding(
              padding: EdgeInsets.all(20),
              child: Text("Item tidak ditemukan"),
            ),
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
                borderRadius: BorderRadius.circular(10)),
          ),
        ],
      ),
    );
  }
}
