import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_stunting/models/survey.dart';
import 'package:survey_stunting/models/survey_parameters.dart';
import 'package:survey_stunting/models/total_survey.dart';
import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';

import '../models/localDb/helpers.dart';
import '../models/localDb/survey_model.dart';

class BerandaController extends GetxController {
  final searchSurveyEditingController = TextEditingController();
  var isLoadedSurvey = false.obs;
  var isLoadedTotalSurvey = false.obs;
  List<Survey> surveys = [];
  TotalSurvey totalSurvey = TotalSurvey();

  String token = GetStorage().read("token");
  int userId = GetStorage().read("userId");
  String offlineMode = dotenv.get('OFFLINE_MODE');

  Future getSurvey({String? search}) async {
    isLoadedSurvey.value = false;
    if (offlineMode == '0') {
      try {
        List<Survey>? response = await DioClient().getSurvey(
          token: token,
          queryParameters: SurveyParameters(
            status: "belum_selesai",
            search: search,
          ),
        );
        surveys = response!;
      } on DioError catch (e) {
        if (e.response?.statusCode == 404) {
          surveys = [];
        } else {
          handleError(error: e);
        }
      }
    } else {
      log('get local');
      // Get survey local
      var profileData =
          await DbHelper.getProfileByUserId(Objectbox.store_, userId: userId);
      int profileId = profileData!.id!;
      List<SurveysModel>? localSurveys_ = await DbHelper.getDetailSurvey(
        Objectbox.store_,
        profileId: profileId,
        isSelesai: 0,
        keyword: search,
      );
      surveys = localSurveys_.map((e) => Survey.fromJson(e.toJson())).toList();
    }
    isLoadedSurvey.value = true;
  }

  Future getTotalSurvey() async {
    isLoadedTotalSurvey.value = false;
    if (offlineMode == '0') {
      try {
        TotalSurvey? response = await DioClient().getTotalSurvey(token: token);
        totalSurvey = response!;
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      // get total survey local
      var profileData =
          await DbHelper.getProfileByUserId(Objectbox.store_, userId: userId);
      int profileId = profileData!.id!;
      TotalSurvey? result =
          await DbHelper.getTotalSurvey(Objectbox.store_, profileId: profileId);
      totalSurvey = result;
    }
    isLoadedTotalSurvey.value = true;
  }

  @override
  void onInit() async {
    await getSurvey();
    await getTotalSurvey();
    super.onInit();
  }

  @override
  void dispose() {
    searchSurveyEditingController.dispose();
    super.dispose();
  }
}
