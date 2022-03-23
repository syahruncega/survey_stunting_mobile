import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/components/elevated_icon_button.dart';
import 'package:survey_stunting/components/filled_autocomplete.dart';
import 'package:survey_stunting/components/filled_text_field.dart';
import 'package:survey_stunting/components/rounded_button.dart';
import 'package:survey_stunting/components/survey_item.dart';
import 'package:survey_stunting/controllers/survey_controller.dart';
import 'package:survey_stunting/models/survey_parameters.dart';

class SurveyScreen extends StatelessWidget {
  const SurveyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SurveyController surveyController = Get.put(SurveyController());
    return RefreshIndicator(
      onRefresh: () async => await surveyController.getSurvey(
        queryParameters: SurveyParameters(
          search: surveyController.searchSurveyEditingController.text,
          status: surveyController.statusSurvey,
          typeSurveyId: surveyController.typeSurvey,
        ),
      ),
      displacement: 0,
      child: Padding(
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
                    controller: surveyController.searchSurveyEditingController,
                    hintText: "Cari...",
                    onEditingComplete: () async =>
                        await surveyController.getSurvey(
                      queryParameters: SurveyParameters(
                        search:
                            surveyController.searchSurveyEditingController.text,
                        status: surveyController.statusSurvey,
                        typeSurveyId: surveyController.typeSurvey,
                      ),
                    ),
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
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      buttonColor: Theme.of(context).colorScheme.secondary,
                      confirmTextColor: Colors.white,
                      title: "Filter",
                      onConfirm: () async {
                        await surveyController.getSurvey(
                          queryParameters: SurveyParameters(
                            search: surveyController
                                .searchSurveyEditingController.text,
                            status: surveyController.statusSurvey,
                            typeSurveyId: surveyController.typeSurvey,
                          ),
                        );
                        Get.back();
                      },
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
                            controller:
                                surveyController.typeSurveyEditingController,
                            items: const [
                              {"label": "Semua", "value": ""},
                              {"label": "Post", "value": "1"},
                              {"label": "Pre", "value": "2"},
                            ],
                            onSuggestionSelected:
                                (Map<String, dynamic> suggestion) {
                              surveyController.typeSurveyEditingController
                                  .text = suggestion["label"];
                              surveyController.typeSurvey = suggestion["value"];
                            },
                          ),
                          FilledAutocomplete(
                            title: "Status Survey",
                            hintText: "Pilih status survey",
                            controller:
                                surveyController.statusSurveyEditingController,
                            items: const [
                              {"label": "Semua", "value": ""},
                              {"label": "Selesai", "value": "selesai"},
                              {
                                "label": "Belum Selesai",
                                "value": "belum_selesai"
                              }
                            ],
                            onSuggestionSelected:
                                (Map<String, dynamic> suggestion) {
                              surveyController.statusSurveyEditingController
                                  .text = suggestion["label"];
                              surveyController.statusSurvey =
                                  suggestion["value"];
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            ElevatedButton.icon(
              onPressed: () async {},
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
            SizedBox(
              height: size.height * 0.01,
            ),
            Expanded(
              child: Obx(
                () => Visibility(
                  visible: !surveyController.isLoading.value,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: surveyController.surveys.isNotEmpty
                      ? ListView.builder(
                          itemCount: surveyController.surveys.length,
                          itemBuilder: (context, index) {
                            return SurveyItem(
                              key: UniqueKey(),
                              onDelete: () async {
                                Get.defaultDialog(
                                  title: "Hapus",
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  confirm: RoundedButton(
                                    title: "Hapus",
                                    backgroundColor: Colors.red.shade400,
                                    onPressed: () async {
                                      await surveyController.deleteSurvey(
                                        id: surveyController.surveys[index].id,
                                      );
                                      Get.back();
                                    },
                                  ),
                                  cancel: RoundedButton.outline(
                                    title: "Batal",
                                    onPressed: () => Get.back(),
                                  ),
                                  content: const Text(
                                      "Anda yakin akan menghapus data ini?"),
                                );
                              },
                              onEdit: () {},
                              survey: surveyController.surveys[index],
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
