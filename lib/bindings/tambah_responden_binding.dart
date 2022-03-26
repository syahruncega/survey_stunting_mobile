import 'package:get/get.dart';
import 'package:survey_stunting/controllers/tambah_responden_controller.dart';

class TambahRespondenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TambahRespondenController());
  }
}
