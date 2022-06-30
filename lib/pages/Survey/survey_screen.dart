import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
import 'package:survey_stunting/consts/colors.dart';
import 'package:survey_stunting/controllers/survey_controller.dart';
import 'package:survey_stunting/models/survey_parameters.dart';
import 'package:survey_stunting/routes/route_name.dart';
import '../../consts/globals_lib.dart' as global;

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
                            buttonColor:
                                Theme.of(context).colorScheme.secondary,
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
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FilledAutocomplete(
                                  title: "Jenis Survey",
                                  hintText: "Pilih jenis survey",
                                  controller: surveyController
                                      .typeSurveyEditingController,
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
                                const SizedBox(height: 20),
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
                                    surveyController
                                        .statusSurveyEditingController
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
                    height: size.height * 0.02,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: CustomElevatedButton(
                          icon: SvgPicture.asset(
                              "assets/icons/bulk/profile-2user.svg",
                              color: Colors.white),
                          label: "Tambah Responden",
                          onPressed: () =>
                              Get.toNamed(RouteName.tambahResponden),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Obx(
                        () => CustomElevatedButton(
                          icon: SvgPicture.asset(
                              "assets/icons/outline/note.svg",
                              color: Colors.white),
                          backgroundColor: primaryColor,
                          isLoading: surveyController.isLoadingFilter.value,
                          label: "Tambah Survey",
                          width: size.width * 0.4,
                          onPressed: () async {
                            surveyController.isLoadingFilter.value = true;
                            await surveyController.getResponden();
                            await surveyController.getNamaSurvey();
                            surveyController.isLoadingFilter.value = false;
                            Get.defaultDialog(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              buttonColor:
                                  Theme.of(context).colorScheme.primary,
                              confirmTextColor: Colors.white,
                              title: "Filter",
                              onConfirm: surveyController.submitForm,
                              onCancel: () {},
                              textCancel: "Batal",
                              cancelTextColor:
                                  Theme.of(context).colorScheme.primary,
                              textConfirm: "Tambah Survey",
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(
                                    () => FilledAutocomplete(
                                      title: "Responden",
                                      hintText: "Pilih responden",
                                      errorText:
                                          surveyController.respondenError.value,
                                      keyboardType: TextInputType.text,
                                      controller: surveyController.respondenTEC,
                                      items: surveyController.responden
                                          .map((e) => {
                                                "label": e.kartuKeluarga +
                                                    ' - ' +
                                                    e.namaKepalaKeluarga,
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
                                  const SizedBox(height: 20),
                                  Obx(
                                    () => FilledAutocomplete(
                                      title: "Jenis Survey",
                                      hintText: "Pilih jenis survey",
                                      errorText: surveyController
                                          .namaSurveyError.value,
                                      controller:
                                          surveyController.namaSurveyTEC,
                                      items: surveyController.namaSurvey
                                          .map((e) => {
                                                "label":
                                                    "${e.nama} | ${e.tipe}",
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
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
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
                                  survey: surveyController.surveys[index],
                                  onTap: () {
                                    if (surveyController
                                            .surveys[index].isSelesai ==
                                        "0") {
                                      Get.toNamed(
                                        RouteName.isiSurvey,
                                        arguments: [
                                          surveyController.surveys[index],
                                          false
                                        ],
                                      );
                                    } else {
                                      Get.toNamed(
                                        RouteName.detailSurvey,
                                        arguments:
                                            surveyController.surveys[index],
                                      );
                                    }
                                  },
                                  onDelete: () async {
                                    Get.defaultDialog(
                                      title: "Hapus",
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
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
                                        arguments: [
                                          surveyController.surveys[index],
                                          true
                                        ]);
                                  },
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
        ));
  }
}
