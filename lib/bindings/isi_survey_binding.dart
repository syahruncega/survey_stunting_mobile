import 'package:get/get.dart';
import 'package:survey_stunting/controllers/isi_survey.controller.dart';

class IsiSurveyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IsiSurveyController());
  }
}
