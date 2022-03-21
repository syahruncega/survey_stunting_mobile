import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/components/filled_autocomplete.dart';
import 'package:survey_stunting/components/survey_item.dart';
import 'package:survey_stunting/controllers/export_survey_controller.dart';

class ExportSurveyScreen extends StatelessWidget {
  const ExportSurveyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ExportSurveyController exportSurveyController =
        Get.put(ExportSurveyController());
    Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async => await exportSurveyController.getSurvey(
        typeSurveyId: exportSurveyController.jenisSurvey,
      ),
      displacement: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Export Survey",
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: size.height * 0.04),
            FilledAutocomplete(
              controller: exportSurveyController.jenisSurveyEditingController,
              hintText: "Pilih jenis survey",
              items: const [
                {"label": "Post", "value": 1},
                {"label": "Pre", "value": 2},
              ],
              onSuggestionSelected: (Map<String, dynamic> suggestion) async {
                exportSurveyController.jenisSurveyEditingController.text =
                    suggestion["label"];
                await exportSurveyController.getSurvey(
                  typeSurveyId: suggestion["value"],
                );
              },
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                primary: Theme.of(context).colorScheme.secondary,
              ),
              icon: SvgPicture.asset("assets/icons/outline/import.svg",
                  color: Colors.white),
              label: Text(
                "Export",
                style: Theme.of(context).textTheme.button,
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Expanded(
              child: Obx(
                () => Visibility(
                  visible: exportSurveyController.isLoaded.value,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: exportSurveyController.surveys.isNotEmpty
                      ? ListView.builder(
                          itemCount: exportSurveyController.surveys.length,
                          itemBuilder: (context, index) {
                            return SurveyItem(
                              key: UniqueKey(),
                              enabled: false,
                              survey: exportSurveyController.surveys[index],
                            );
                          },
                        )
                      : ListView(
                          children: const [Text("Data tidak ditemukan")],
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
