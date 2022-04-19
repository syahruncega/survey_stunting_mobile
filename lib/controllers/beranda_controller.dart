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

class BerandaController extends GetxController {
  final searchSurveyEditingController = TextEditingController();
  var isLoadedSurvey = false.obs;
  var isLoadedTotalSurvey = false.obs;
  List<Survey> surveys = [];
  TotalSurvey totalSurvey = TotalSurvey();

  String token = GetStorage().read("token");

  Future getSurvey({String? search}) async {
    isLoadedSurvey.value = false;
    String offlineMode = dotenv.get('OFFLINE_MODE');
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
      //
    }
    isLoadedSurvey.value = true;
  }

  Future getTotalSurvey() async {
    isLoadedTotalSurvey.value = false;
    try {
      TotalSurvey? response = await DioClient().getTotalSurvey(token: token);
      totalSurvey = response!;
    } on DioError catch (e) {
      handleError(error: e);
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
