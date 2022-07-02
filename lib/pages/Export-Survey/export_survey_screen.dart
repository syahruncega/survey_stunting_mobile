import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/components/filled_autocomplete.dart';
import 'package:survey_stunting/components/not_found.dart';
import 'package:survey_stunting/components/survey_item.dart';
import 'package:survey_stunting/controllers/export_survey_controller.dart';
import '../../consts/globals_lib.dart' as global;

class ExportSurveyScreen extends StatelessWidget {
  const ExportSurveyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ExportSurveyController exportSurveyController =
        Get.put(ExportSurveyController());
    Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async => await exportSurveyController.getSurvey(
        namaSurveyId: exportSurveyController.namaSurveyId,
      ),
      displacement: 0,
      child: NotificationListener<UserScrollNotification>(
        onNotification: ((notification) {
          final ScrollDirection direction = notification.direction;
          if (notification.metrics.maxScrollExtent == 0) {
            global.isFabVisible.value = true;
          } else {
            if (direction == ScrollDirection.reverse) {
              global.isFabVisible.value = false;
            } else if (direction == ScrollDirection.forward) {
              global.isFabVisible.value = true;
            }
          }
          return true;
        }),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                Obx(
                  () => FilledAutocomplete(
                    controller: exportSurveyController.namaSurveyTEC,
                    hintText: "Pilih jenis survey",
                    items: exportSurveyController.namaSurvey
                        .map((e) => {
                              'label': e.nama + '|' + e.tipe,
                              'value': e.id.toString()
                            })
                        .toList(),
                    errorText: exportSurveyController.namaSurveyIdError.value,
                    onSuggestionSelected:
                        (Map<String, dynamic> suggestion) async {
                      exportSurveyController.namaSurveyTEC.text =
                          suggestion["label"];
                      exportSurveyController.namaSurveyId = suggestion["value"];
                      await exportSurveyController.getSurvey(
                        namaSurveyId: suggestion["value"],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Obx(
                  () => ElevatedButton.icon(
                    onPressed: () async {
                      await exportSurveyController.exportToExcelNew();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      primary: Theme.of(context).colorScheme.secondary,
                    ),
                    icon: exportSurveyController.exportStatus.value ==
                            'completed'
                        ? SvgPicture.asset("assets/icons/outline/import.svg",
                            color: Colors.white)
                        : Container(
                            width: 24,
                            height: 24,
                            padding: const EdgeInsets.all(2.0),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                    label:
                        exportSurveyController.exportStatus.value == 'completed'
                            ? Text(
                                "Export",
                                style: Theme.of(context).textTheme.button,
                              )
                            : Text(
                                "Exporting..",
                                style: Theme.of(context).textTheme.button,
                              ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Obx(
                  () => Visibility(
                    visible: exportSurveyController.isLoaded.value,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: exportSurveyController.surveys.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: exportSurveyController.surveys.length,
                            itemBuilder: (context, index) {
                              return SurveyItem(
                                key: UniqueKey(),
                                enabled: false,
                                survey: exportSurveyController.surveys[index],
                              );
                            },
                          )
                        : const NotFound(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
