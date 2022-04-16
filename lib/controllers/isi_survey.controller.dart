import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_stunting/components/filled_text_field.dart';
import 'package:survey_stunting/components/success_scackbar.dart';
import 'package:survey_stunting/models/jawaban_soal.dart';
import 'package:survey_stunting/models/jawaban_survey.dart';
import 'package:survey_stunting/models/kategori_soal.dart';
import 'package:survey_stunting/models/soal.dart';
import 'package:survey_stunting/models/soal_and_jawaban.dart';
import 'package:survey_stunting/models/survey.dart';
import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';

class IsiSurveyController extends GetxController {
  String token = GetStorage().read("token");
  Rx<String> title = "".obs;
  late KategoriSoal currentKategoriSoal;
  late Survey survey;
  late List<KategoriSoal> kategoriSoal = [];
  late List<JawabanSurvey> initialJawabanSurvey = [];
  final soal = RxList<Soal>();
  final soalAndJawaban = RxList<SoalAndJawaban>();
  late List<JawabanSurvey> currentJawabanSurvey;
  var isLoading = true.obs;
  final formKey = GlobalKey<FormState>();
  int currentKategoriIndex = 0;
  int currentOrder = 0;

  @override
  void onInit() async {
    survey = Get.arguments;
    await getKategoriSoal();
    //Bellow For Create Survey
    currentKategoriSoal = kategoriSoal.firstWhere(
        (element) => element.id.toString() == survey.kategoriSelanjutnya!);

    //Bellow For Update Survey
    // currentKategoriSoal = kategoriSoal[1];

    await getJawabanSurvey();
    title.value = currentKategoriSoal.nama;
    currentOrder = int.parse(currentKategoriSoal.urutan);
    await getSoal();
    await getJawabanSoal();
    log(listJawabanSurveyToJson(initialJawabanSurvey));
    isLoading.value = false;
    currentJawabanSurvey = [];
    super.onInit();
  }

  Future getKategoriSoal() async {
    try {
      List<KategoriSoal>? response = await DioClient().getKategoriSoal(
          token: token, namaSurveyId: survey.namaSurvey!.id.toString());
      kategoriSoal = response!;
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future getSoal() async {
    try {
      List<Soal>? response = await DioClient().getSoal(
        token: token,
        kategoriSoalId: currentKategoriSoal.id.toString(),
      );
      soal.value = response!;
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future getJawabanSoal() async {
    try {
      for (var item in soal) {
        if (item.tipeJawaban == "Jawaban Singkat") {
          soalAndJawaban.add(SoalAndJawaban(soal: item));
        } else {
          List<JawabanSoal>? response = await DioClient()
              .getJawabanSoal(token: token, soalId: item.id.toString());
          soalAndJawaban.add(SoalAndJawaban(soal: item, jawabanSoal: response));
        }
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Widget generateSoalUI({
    required int number,
    required String soal,
    required String typeJawaban,
    required int soalId,
    List<JawabanSoal>? jawabanSoal,
    required BuildContext context,
  }) {
    switch (typeJawaban) {
      case "Pilihan Ganda":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$number. $soal",
              style: Theme.of(context).textTheme.headline3,
            ),
            FormBuilderRadioGroup(
              name: soalId.toString(),
              activeColor: Theme.of(context).primaryColor,
              orientation: OptionsOrientation.vertical,
              options: jawabanSoal!.map((value) {
                return FormBuilderFieldOption(
                  value: JawabanSurvey(
                    soalId: soalId.toString(),
                    kodeUnikSurvey: survey.kodeUnik.toString(),
                    kategoriSoalId: currentKategoriSoal.id.toString(),
                    jawabanSoalId: value.id.toString(),
                  ),
                  child: Text(value.jawaban),
                );
              }).toList(),
              validator: (value) {
                if (value == null) {
                  return "Jawaban tidak boleh kosong";
                }
                return null;
              },
              onSaved: (value) async {
                value as JawabanSurvey;
                currentJawabanSurvey.add(value);
              },
            )
          ],
        );
      case "Kotak Centang":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$number. $soal",
              style: Theme.of(context).textTheme.headline3,
            ),
            FormBuilderCheckboxGroup(
              name: soalId.toString(),
              activeColor: Theme.of(context).primaryColor,
              orientation: OptionsOrientation.vertical,
              initialValue: [],
              options: jawabanSoal!.map((value) {
                JawabanSurvey jawabanSurvey = JawabanSurvey(
                  soalId: soalId.toString(),
                  kodeUnikSurvey: survey.kodeUnik.toString(),
                  kategoriSoalId: currentKategoriSoal.id.toString(),
                  jawabanSoalId: value.id.toString(),
                );
                return FormBuilderFieldOption(
                  value: jawabanSurvey,
                  child: value.isLainnya == "0"
                      ? Text(value.jawaban)
                      : FilledTextField(
                          onChanged: (value) =>
                              jawabanSurvey.jawabanLainnya = value,
                          hintText: "Lainnya",
                          onSaved: (value) {},
                        ),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Jawaban tidak boleh kosong";
                }
                return null;
              },
              onSaved: (value) async {
                if (value!.isNotEmpty) {
                  for (var item in value) {
                    currentJawabanSurvey.add(item as JawabanSurvey);
                  }
                }
              },
            ),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilledTextField(
              title: "$number. $soal",
              initialValue: initialJawabanSurvey.isNotEmpty
                  ? initialJawabanSurvey
                      .firstWhere(
                          (element) => element.soalId == soalId.toString())
                      .jawabanLainnya
                  : "",
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Jawaban tidak boleh kosong";
                }
                return null;
              },
              onSaved: (value) async {
                currentJawabanSurvey.add(
                  JawabanSurvey(
                    soalId: soalId.toString(),
                    kodeUnikSurvey: survey.kodeUnik.toString(),
                    kategoriSoalId: currentKategoriSoal.id.toString(),
                    jawabanLainnya: value,
                  ),
                );
              },
            ),
          ],
        );
    }
  }

  Future getJawabanSurvey() async {
    try {
      List<JawabanSurvey>? response = await DioClient().getJawabanSurvey(
        token: token,
        kodeUnikSurvey: survey.kodeUnik!,
        kategoriSoalId: currentKategoriSoal.id.toString(),
      );
      initialJawabanSurvey = response!;
    } on DioError catch (e) {
      if (e.response!.statusCode == 404) {
        initialJawabanSurvey = [];
      } else {
        handleError(error: e);
      }
    }
  }

  Future submitForm() async {
    try {
      if (formKey.currentState!.validate()) {
        currentJawabanSurvey.clear();
        formKey.currentState!.save();
        List<JawabanSurvey>? oldJawabanSurvey;
        try {
          oldJawabanSurvey = await DioClient().getJawabanSurvey(
            token: token,
            kodeUnikSurvey: survey.kodeUnik!,
            kategoriSoalId: currentKategoriSoal.id.toString(),
          );
        } on DioError catch (e) {
          if (e.response?.statusCode == 404) {
            oldJawabanSurvey = [];
          } else {
            handleError(error: e);
            return;
          }
        }

        if (oldJawabanSurvey!.isNotEmpty) {
          for (var item in oldJawabanSurvey) {
            await DioClient().deleteJawabanSurvey(
              token: token,
              id: item.id.toString(),
            );
          }
        }

        for (var item in currentJawabanSurvey) {
          await DioClient().createJawabanSurvey(token: token, data: item);
        }

        successScackbar("Data berhasil disimpan");
        await nextCategory();
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future nextCategory() async {
    currentOrder++;
    await refreshPage();
  }

  Future previousCategory() async {
    currentOrder--;
    await refreshPage();
  }

  Future refreshPage() async {
    isLoading.value = true;
    soalAndJawaban.clear();
    // currentKategoriSoal = kategoriSoal[currentKategoriIndex + 1];
    if (currentOrder > kategoriSoal.length) {
      currentOrder = kategoriSoal.length;
      survey.isSelesai = "1";
      isLoading.value = false;
      return;
    }
    if (currentOrder < 1) {
      currentOrder = 1;
      isLoading.value = false;
      return;
    }
    currentKategoriSoal = kategoriSoal
        .firstWhere((element) => element.urutan == currentOrder.toString());
    title.value = currentKategoriSoal.nama;
    // survey.kategoriSelanjutnya = currentKategoriSoal.id.toString();
    // await DioClient().updateSurvey(
    //   token: token,
    //   data: {
    //     "kode_unik": survey.kodeUnik,
    //     "kode_unik_responden": survey.kodeUnikResponden,
    //     "nama_survey_id": survey.namaSurveyId,
    //     "profile_id": survey.profileId,
    //     "kategori_selanjutnya": currentKategoriSoal.id.toString(),
    //     "is_selesai": survey.isSelesai,
    //   },
    // );

    if (currentOrder == kategoriSoal.length) {
      Get.back();
      return;
    }

    await getSoal();
    await getJawabanSoal();
    currentJawabanSurvey = [];
    isLoading.value = false;
  }
}
