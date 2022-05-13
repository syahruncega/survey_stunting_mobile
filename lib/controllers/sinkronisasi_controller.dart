import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_stunting/components/error_scackbar.dart';
import 'package:survey_stunting/components/success_scackbar.dart';
import 'package:survey_stunting/controllers/sync_data_controller.dart';
import '../consts/globals_lib.dart' as global;
import '../models/localDb/helpers.dart';

class SinkronisasiController extends GetxController {
  late bool isConnect;
  var isLoading = false.obs;
  var synchronizeStatus = ''.obs;
  String token = GetStorage().read("token");

  Future synchronize() async {
    synchronizeStatus.value = 'waiting';
    await checkConnection();
    if (isConnect) {
      await SyncDataController(store_: Objectbox.store_)
          .syncData(syncAll: true);
      successScackbar('Sinkronisasi Berhasil');
      synchronizeStatus.value = 'successfully';
    } else {
      errorScackbar('Tidak ada koneksi internet');
      synchronizeStatus.value = 'failed';
    }
  }

  Future checkConnection() async {
    isConnect = await global.isConnected();
  }
}
