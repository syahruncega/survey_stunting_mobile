import 'package:get/get.dart';
import 'package:survey_stunting/controllers/detail_survey_controller.dart';

class DetailSurveyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailSurveyController());
  }
}
