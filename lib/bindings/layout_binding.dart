import 'package:get/get.dart';
import 'package:survey_stunting/controllers/layout_controller.dart';

class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LayoutController>(() => LayoutController());
  }
}
