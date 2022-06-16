import 'package:get/get.dart';
import 'package:survey_stunting/controllers/ubah_profil_controller.dart';

class UbahProfilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UbahProfilController());
  }
}
