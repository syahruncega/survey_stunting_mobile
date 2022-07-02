import 'package:get/get.dart';

import '../controllers/lengkapi_profil_controller.dart';

class LengkapiProfilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LengkapiProfilController());
  }
}
