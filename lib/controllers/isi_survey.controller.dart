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
  var isLoading = true.obs;
  late KategoriSoal currentKategoriSoal;
  late Survey survey;
  late List<KategoriSoal> kategoriSoal = [];
  late List<JawabanSurvey> initialJawabanSurvey = [];
  late List<JawabanSurvey> currentJawabanSurvey;
  final soal = RxList<Soal>();
  final soalAndJawaban = RxList<SoalAndJawaban>();
  final formKey = GlobalKey<FormState>();
  int currentOrder = 0;

  @override
  void onInit() async {
    survey = Get.arguments;
    await getKategoriSoal();
    currentKategoriSoal = kategoriSoal.firstWhere(
        (element) => element.id.toString() == survey.kategoriSelanjutnya!);

    await getJawabanSurvey();
    title.value = currentKategoriSoal.nama;
    currentOrder = int.parse(currentKategoriSoal.urutan);

    await getSoal();
    await getJawabanSoal();
    isLoading.value = false;
    currentJawabanSurvey = [];
    super.onInit();
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
        var options = jawabanSoal!.map((value) {
          JawabanSurvey jawabanSurvey;
          var check = initialJawabanSurvey.firstWhereOrNull((element) =>
              element.soalId == soalId.toString() &&
              element.jawabanSoalId == value.id.toString());
          if (check != null) {
            jawabanSurvey = check;
          } else {
            jawabanSurvey = JawabanSurvey(
              soalId: soalId.toString(),
              kodeUnikSurvey: survey.kodeUnik.toString(),
              kategoriSoalId: currentKategoriSoal.id.toString(),
              jawabanSoalId: value.id.toString(),
            );
          }
          return FormBuilderFieldOption(
            value: jawabanSurvey,
            child: Text(value.jawaban),
          );
        }).toList();

        var initalValue = initialJawabanSurvey
            .firstWhereOrNull((element) => element.soalId == soalId.toString());

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
              initialValue: initalValue,
              options: options,
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
        var options = jawabanSoal!.map((value) {
          JawabanSurvey jawabanSurvey;
          var check = initialJawabanSurvey.firstWhereOrNull((element) =>
              element.soalId == soalId.toString() &&
              element.jawabanSoalId == value.id.toString());
          if (check != null) {
            jawabanSurvey = check;
          } else {
            jawabanSurvey = JawabanSurvey(
              soalId: soalId.toString(),
              kodeUnikSurvey: survey.kodeUnik.toString(),
              kategoriSoalId: currentKategoriSoal.id.toString(),
              jawabanSoalId: value.id.toString(),
            );
          }
          return FormBuilderFieldOption(
            value: jawabanSurvey,
            child: value.isLainnya == "0"
                ? Text(value.jawaban)
                : FilledTextField(
                    initialValue: jawabanSurvey.jawabanLainnya ?? "",
                    onChanged: (value) => jawabanSurvey.jawabanLainnya = value,
                    hintText: "Lainnya",
                    onSaved: (value) {},
                  ),
          );
        }).toList();
        var initialValue = initialJawabanSurvey
            .where((e) => e.soalId == soalId.toString())
            .toList();

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
              initialValue: initialValue,
              options: options,
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
        var initialValue = initialJawabanSurvey
            .firstWhereOrNull((element) => element.soalId == soalId.toString());
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilledTextField(
              title: "$number. $soal",
              initialValue: initialValue?.jawabanLainnya ?? "",
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
    survey.kategoriSelanjutnya = currentKategoriSoal.id.toString();
    await DioClient().updateSurvey(
      token: token,
      data: {
        "kode_unik": survey.kodeUnik,
        "kode_unik_responden": survey.kodeUnikResponden,
        "nama_survey_id": survey.namaSurveyId,
        "profile_id": survey.profileId,
        "kategori_selanjutnya": kategoriSoal
            .firstWhere((element) => element.urutan == currentOrder.toString())
            .id
            .toString(),
        "is_selesai": survey.isSelesai,
      },
    );

    if (currentOrder == kategoriSoal.length) {
      Get.back();
      return;
    }

    await getJawabanSurvey();
    await getSoal();
    await getJawabanSoal();
    currentJawabanSurvey = [];
    isLoading.value = false;
  }
}
