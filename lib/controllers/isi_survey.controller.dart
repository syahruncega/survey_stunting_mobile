import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_stunting/components/custom_check_box.dart';
import 'package:survey_stunting/components/custom_combo_box.dart';
import 'package:survey_stunting/components/filled_text_field.dart';
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
  Rx<String> currentKategoriSoalTitle = "".obs;
  late KategoriSoal currentKategoriSoal;
  late Survey survey;
  late List<KategoriSoal> kategoriSoal;
  final soal = RxList<Soal>();
  final soalAndJawaban = RxList<SoalAndJawaban>();
  late List<JawabanSurvey> listJawabanSurvey;
  var isLoading = true.obs;

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
    List<JawabanSoal>? jawaban,
    required BuildContext context,
  }) {
    String key = "";
    if (typeJawaban == "Pilihan Ganda" || typeJawaban == "Jawaban Singkat") {
      key = UniqueKey().toString();
      listJawabanSurvey.add(
        JawabanSurvey(
          soalId: soalId.toString(),
          kodeUnikSurvey: survey.kodeUnik.toString(),
          kategoriSoalId: currentKategoriSoal.id.toString(),
          key: key,
          isAllowed: true,
        ),
      );
    }
    switch (typeJawaban) {
      case "Pilihan Ganda":
        Rx<String> groupValue = "".obs;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "$number. $soal",
            style: Theme.of(context).textTheme.headline3,
          ),
          ...jawaban!.map((value) {
            var index = jawaban.indexOf(value);
            if (index == 0) {
              groupValue.value = value.id.toString();
            }
            JawabanSurvey jawabanSurvey =
                listJawabanSurvey.firstWhere((element) => element.key == key);
            return Obx(
              () => CustomComboBox(
                label: value.jawaban,
                value: value.id.toString(),
                groupValue: groupValue.value,
                onChanged: (x) {
                  groupValue.value = x!;
                  jawabanSurvey.jawabanSoalId = groupValue.value;
                },
              ),
            );
          })
        ]);
      case "Kotak Centang":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$number. $soal",
              style: Theme.of(context).textTheme.headline3,
            ),
            ...jawaban!.map((value) {
              key = UniqueKey().toString();
              Rx<bool> checkedValue = false.obs;
              TextEditingController textEditingController =
                  TextEditingController();
              JawabanSurvey jawabanSurvey = JawabanSurvey(
                soalId: soalId.toString(),
                kodeUnikSurvey: survey.kodeUnik.toString(),
                kategoriSoalId: currentKategoriSoal.id.toString(),
                jawabanSoalId: value.id.toString(),
                key: key,
                isAllowed: true,
              );
              listJawabanSurvey.add(jawabanSurvey);
              return Obx(
                () => CustomCheckBox(
                  label: value.jawaban,
                  value: checkedValue.value,
                  isOther: value.isLainnya == "1" ? true : false,
                  controller: textEditingController,
                  jawabanSurvey: jawabanSurvey,
                  onChanged: (x) {
                    checkedValue.value = x!;
                    jawabanSurvey.isAllowed = checkedValue.value;
                    if (value.isLainnya == "1") {
                      jawabanSurvey.jawabanLainnya = textEditingController.text;
                    }
                  },
                ),
              );
            })
          ],
        );
      default:
        TextEditingController textEditingController = TextEditingController();
        JawabanSurvey jawabanSurvey =
            listJawabanSurvey.firstWhere((element) => element.key == key);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilledTextField(
              title: "$number. $soal",
              controller: textEditingController,
              onEditingComplete: () {
                jawabanSurvey.jawabanLainnya = textEditingController.text;
              },
            ),
          ],
        );
    }
  }

  @override
  void onInit() async {
    survey = Get.arguments;
    await getKategoriSoal();
    currentKategoriSoal = kategoriSoal.firstWhere(
        (element) => element.id.toString() == survey.kategoriSelanjutnya!);
    currentKategoriSoalTitle.value = currentKategoriSoal.nama;
    await getSoal();
    await getJawabanSoal();
    log(soalAndJawaban.toString());
    isLoading.value = false;
    listJawabanSurvey = [];
    super.onInit();
  }
}
