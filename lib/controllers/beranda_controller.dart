import 'package:dio/dio.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_stunting/components/error_scackbar.dart';
import 'package:survey_stunting/models/survey.dart';
import 'package:survey_stunting/models/total_survey.dart';
import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';

class BerandaController extends GetxController {
  var isLoadedSurvey = false.obs;
  var isLoadedTotalSurvey = false.obs;
  var surveys = [].obs;
  Rx<TotalSurvey> totalSurvey = TotalSurvey().obs;

  String token = GetStorage().read("token");

  Future getSurveyByStatus() async {
    isLoadedSurvey.value = false;
    try {
      List<Survey>? response =
          await DioClient().getSurveyByStatus(token: token, isCompleted: true);
      surveys.value = response!;
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        surveys.value = [];
      } else {
        handleError(error: e);
      }
    }
    isLoadedSurvey.value = true;
  }

  Future getTotalSurvey() async {
    isLoadedTotalSurvey.value = false;
    try {
      TotalSurvey? response = await DioClient().getTotalSurvey(token: token);
      totalSurvey.value = response!;
    } on DioError catch (e) {
      handleError(error: e);
    }
    isLoadedTotalSurvey.value = true;
  }

  @override
  void onInit() async {
    await getSurveyByStatus();
    await getTotalSurvey();
    super.onInit();
  }
}
