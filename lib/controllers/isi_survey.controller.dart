import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_stunting/components/custom_combo_box.dart';
import 'package:survey_stunting/components/filled_text_field.dart';
import 'package:survey_stunting/models/jawaban_soal.dart';
import 'package:survey_stunting/models/kategori_soal.dart';
import 'package:survey_stunting/models/soal.dart';
import 'package:survey_stunting/models/soal_and_jawaban.dart';
import 'package:survey_stunting/models/survey.dart';
import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';

class IsiSurveyController extends GetxController {
  String token = GetStorage().read("token");
  late String currentCategory;
  late List<Survey> survey;
  late List<KategoriSoal> kategoriSoal;
  final soal = RxList<Soal>();
  final soalAndJawaban = RxList<SoalAndJawaban>();
  var isLoading = true.obs;

  Future getKategoriSoal() async {
    try {
      List<KategoriSoal>? response = await DioClient().getKategoriSoal(
          token: token, namaSurveyId: survey[0].namaSurvey!.id.toString());
      kategoriSoal = response!;
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future getSoal() async {
    try {
      List<Soal>? response = await DioClient()
          .getSoal(token: token, kategoriSoalId: currentCategory);
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
    required String soal,
    required String typeJawaban,
    required int soalId,
    List<JawabanSoal>? jawaban,
    required BuildContext context,
  }) {
    Rx<String> groupValue = "".obs;
    switch (typeJawaban) {
      case "Pilihan Ganda":
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            soal,
            style: Theme.of(context).textTheme.headline3,
          ),
          ...jawaban!.map((value) {
            var index = jawaban.indexOf(value);
            if (index == 0) {
              groupValue.value = value.id.toString();
            }
            return Obx(
              () => CustomComboBox(
                label: value.jawaban,
                value: value.id.toString(),
                groupValue: groupValue.value,
                onChanged: (x) {
                  groupValue.value = x!;
                },
              ),
            );
          })
        ]);
      case "Kotak Centang":
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(soal),
        ]);
      default:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FilledTextField(
            title: soal,
          ),
        ]);
    }
  }

  @override
  void onInit() async {
    survey = Get.arguments;
    currentCategory = survey[0].kategoriSelanjutnya!;
    await getKategoriSoal();
    await getSoal();
    await getJawabanSoal();
    log(soalAndJawaban.toString());
    isLoading.value = false;
    super.onInit();
  }
}
