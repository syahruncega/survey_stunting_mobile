import 'package:get/get.dart';
import 'package:survey_stunting/controllers/export_survey_controller.dart';
import 'package:survey_stunting/controllers/layout_controller.dart';
import 'package:survey_stunting/controllers/survey_controller.dart';

class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LayoutController>(() => LayoutController());
    Get.lazyPut<SurveyController>(() => SurveyController());
    Get.lazyPut<ExportSurveyController>(() => ExportSurveyController());
  }
}
