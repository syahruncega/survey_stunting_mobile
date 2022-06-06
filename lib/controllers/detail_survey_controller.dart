import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_stunting/models/detail_survey.dart';
import 'package:survey_stunting/models/localDb/helpers.dart';
import 'package:survey_stunting/models/survey.dart';
import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';
import '../consts/globals_lib.dart' as global;

class DetailSurveyController extends GetxController {
  String token = GetStorage().read("token");
  late Survey survey;
  late List<DetailSurvey> detailSurvey = [];
  late bool isConnect;
  var isLoading = true.obs;

  @override
  void onInit() async {
    await checkConnection();
    survey = Get.arguments;
    await getDetailSurvey();
    isLoading.value = false;
    super.onInit();
  }

  Future checkConnection() async {
    isConnect = await global.isConnected();
  }

  Future getDetailSurvey() async {
    if (isConnect) {
      try {
        List<DetailSurvey>? response = await DioClient().getDetailSurvey(
          token: token,
          kodeUnikSurvey: survey.kodeUnik!,
        );
        log("${response!.length}");
        detailSurvey = response;
        inspect(response);
        for (var item in detailSurvey) {
          log(item.nama);
        }
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      try {
        List<DetailSurvey> detailSurveyLocal =
            await DbHelper.getDetailSurveyByKodeUnik(
          Objectbox.store_,
          kodeUnik: int.parse(survey.kodeUnik!),
          namaSurveyId: int.parse(survey.namaSurveyId),
        );
        detailSurvey = detailSurveyLocal;
      } on DioError catch (e) {
        handleError(error: e);
      }
    }
  }
}
