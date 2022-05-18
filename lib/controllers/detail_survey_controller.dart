import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_stunting/models/detail_survey.dart';
import 'package:survey_stunting/models/survey.dart';
import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';

class DetailSurveyController extends GetxController {
  String token = GetStorage().read("token");
  late Survey survey;
  late List<DetailSurvey> detailSurvey = [];
  var isLoading = true.obs;

  @override
  void onInit() async {
    survey = Get.arguments;
    await getDetailSurvey();
    isLoading.value = false;
    super.onInit();
  }

  Future getDetailSurvey() async {
    try {
      List<DetailSurvey>? response = await DioClient().getDetailSurvey(
        token: token,
        kodeUnikSurvey: survey.kodeUnik!,
      );
      log("${response!.length}");
      detailSurvey = response;
      for (var item in detailSurvey) {
        log(item.nama);
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }
}
