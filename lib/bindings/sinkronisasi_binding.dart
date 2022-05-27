import 'package:get/get.dart';

import '../controllers/sinkronisasi_controller.dart';

class SinkronisasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SinkronisasiController());
  }
}
