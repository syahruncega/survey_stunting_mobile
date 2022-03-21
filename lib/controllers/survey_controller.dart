import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_stunting/models/survey.dart';
import 'package:survey_stunting/models/survey_parameters.dart';
import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';

class SurveyController extends GetxController {
  final typeSurveyEditingController = TextEditingController();
  final statusSurveyEditingController = TextEditingController();
  final searchSurveyEditingController = TextEditingController();
  dynamic typeSurvey = "".obs;
  dynamic statusSurvey = "".obs;
  var isLoaded = false.obs;
  var surveys = [].obs;
  String token = GetStorage().read("token");

  Future getSurvey({SurveyParameters? queryParameters}) async {
    isLoaded.value = false;
    try {
      List<Survey>? response = await DioClient().getSurvey(
        token: token,
        queryParameters: queryParameters,
      );
      surveys.value = response!;
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        surveys.value = [];
      } else {
        handleError(error: e);
      }
    }
    isLoaded.value = true;
  }

  @override
  void onInit() async {
    await getSurvey();
    super.onInit();
  }
}
