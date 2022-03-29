import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_stunting/components/custom_combo_box.dart';
import 'package:survey_stunting/components/filled_text_field.dart';
import 'package:survey_stunting/models/jawaban_soal.dart';
import 'package:survey_stunting/models/kategori_soal.dart';
import 'package:survey_stunting/models/soal.dart';
import 'package:survey_stunting/models/survey.dart';
import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';

class IsiSurveyController extends GetxController {
  String token = GetStorage().read("token");
  late String currentCategory;
  late List<Survey> survey;
  late List<KategoriSoal> kategoriSoal;
  final soal = RxList<Soal>();
  var soalAndJawaban = [].obs;
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
      log("$soal");

      for (var item in soal) {
        if (item.tipeJawaban == "Pilihan Ganda") {
          List<JawabanSoal>? response = await DioClient()
              .getJawabanSoal(token: token, soalId: item.id.toString());
          log(response.toString());
          soalAndJawaban.add({"soal": item, "jawaban": response});
          log(item.toString());
        } else {
          soalAndJawaban.add({"soal": item, "jawaban": null});
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
    required dynamic jawaban,
  }) {
    switch (typeJawaban) {
      case "Pilihan Ganda":
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(soal),
          ...jawaban.map(
            (value) => CustomComboBox(
              title: value.jawaban,
              value: value.id.toString(),
              groupValue: "1",
              onChanged: (_) {},
            ),
          )
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
