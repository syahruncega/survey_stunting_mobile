import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_stunting/models/survey.dart';
import 'package:survey_stunting/services/dio_client.dart';

class SurveyController extends GetxController {
  final jenisSurvey = TextEditingController();
  final statusSurvey = TextEditingController();
  var isLoaded = false.obs;
  var surveys = [].obs;

  Future getAllSurvey() async {
    isLoaded.value = false;
    String token = GetStorage().read("token");
    List<Survey>? response = await DioClient().getAllSurvey(token: token);
    log('$surveys');
    if (response != null) {
      isLoaded.value = true;
      surveys.value = response;
    }
  }

  @override
  void onInit() async {
    await getAllSurvey();
    super.onInit();
  }
}
