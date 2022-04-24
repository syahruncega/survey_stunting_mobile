import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/components/custom_elevated_button.dart';
import 'package:survey_stunting/components/custom_elevated_button_icon.dart';
import 'package:survey_stunting/components/custom_icon_button.dart';
import 'package:survey_stunting/components/filled_autocomplete.dart';
import 'package:survey_stunting/components/filled_text_field.dart';
import 'package:survey_stunting/components/not_found.dart';
import 'package:survey_stunting/components/rounded_button.dart';
import 'package:survey_stunting/components/survey_item.dart';
import 'package:survey_stunting/controllers/survey_controller.dart';
import 'package:survey_stunting/models/survey_parameters.dart';
import 'package:survey_stunting/routes/route_name.dart';

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
          namaSurveyId: surveyController.typeSurvey,
        ),
      ),
      displacement: 0,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                      controller:
                          surveyController.searchSurveyEditingController,
                      hintText: "Cari...",
                      onEditingComplete: () async =>
                          await surveyController.getSurvey(
                        queryParameters: SurveyParameters(
                          search: surveyController
                              .searchSurveyEditingController.text,
                          status: surveyController.statusSurvey,
                          namaSurveyId: surveyController.typeSurvey,
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
                  CustomIconButton(
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
                          Get.back();
                          await surveyController.getSurvey(
                            queryParameters: SurveyParameters(
                              search: surveyController
                                  .searchSurveyEditingController.text,
                              status: surveyController.statusSurvey,
                              namaSurveyId: surveyController.typeSurvey,
                            ),
                          );
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
                                surveyController.typeSurvey =
                                    suggestion["value"];
                              },
                            ),
                            FilledAutocomplete(
                              title: "Status Survey",
                              hintText: "Pilih status survey",
                              controller: surveyController
                                  .statusSurveyEditingController,
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
              Obx(
                () => CustomElevatedButtonIcon(
                  isLoading: surveyController.isLoadingFilter.value,
                  label: "Tambah",
                  icon: SvgPicture.asset("assets/icons/outline/add-square.svg",
                      color: Colors.white),
                  onPressed: () async {
                    surveyController.isLoadingFilter.value = true;
                    await surveyController.getResponden();
                    await surveyController.getNamaSurvey();
                    surveyController.isLoadingFilter.value = false;
                    Get.defaultDialog(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      buttonColor: Theme.of(context).colorScheme.primary,
                      confirmTextColor: Colors.white,
                      title: "Filter",
                      onConfirm: surveyController.submitForm,
                      onCancel: () {},
                      textCancel: "Batal",
                      cancelTextColor: Theme.of(context).colorScheme.primary,
                      textConfirm: "Tambah Survey",
                      content: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runSpacing: size.height * 0.03,
                        children: [
                          Obx(
                            () => FilledAutocomplete(
                              title: "Responden",
                              hintText: "Pilih responden",
                              errorText: surveyController.respondenError.value,
                              keyboardType: TextInputType.number,
                              controller: surveyController.respondenTEC,
                              items: surveyController.responden
                                  .map((e) => {
                                        "label": e.kartuKeluarga,
                                        "value": e.kodeUnik
                                      })
                                  .toList(),
                              onSuggestionSelected:
                                  (Map<String, dynamic> suggestion) {
                                surveyController.respondenTEC.text =
                                    suggestion["label"];
                                surveyController.kodeUnikResponden =
                                    suggestion["value"];
                              },
                            ),
                          ),
                          Obx(
                            () => FilledAutocomplete(
                              title: "Nama Survey",
                              hintText: "Pilih nama survey",
                              errorText: surveyController.namaSurveyError.value,
                              controller: surveyController.namaSurveyTEC,
                              items: surveyController.namaSurvey
                                  .map((e) => {
                                        "label": "${e.nama} | ${e.tipe}",
                                        "value": e.id
                                      })
                                  .toList(),
                              onSuggestionSelected:
                                  (Map<String, dynamic> suggestion) {
                                surveyController.namaSurveyTEC.text =
                                    suggestion["label"];
                                surveyController.namaSurveyId =
                                    suggestion["value"];
                              },
                            ),
                          ),
                          Center(
                            child: CustomElevatedButton(
                              label: "Tambah Responden",
                              onPressed: () {
                                Get.back();
                                Get.toNamed(RouteName.tambahResponden);
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Obx(
                () => Visibility(
                  visible: !surveyController.isLoading.value,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: surveyController.surveys.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
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
                                      Get.back();
                                      await surveyController.deleteSurvey(
                                        kodeUnik: surveyController
                                            .surveys[index].kodeUnik!,
                                      );
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
                              onEdit: () {
                                Get.toNamed(RouteName.isiSurvey,
                                    arguments: surveyController.surveys[index]);
                              },
                              survey: surveyController.surveys[index],
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
    );
  }
}
