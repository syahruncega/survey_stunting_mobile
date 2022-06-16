import 'package:get/get.dart';
import 'package:survey_stunting/controllers/ubah_akun_controller.dart';

class UbahAkunBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UbahAkunController());
  }
}
