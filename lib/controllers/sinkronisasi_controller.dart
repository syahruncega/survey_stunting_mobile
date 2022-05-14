import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  var lastSync = ''.obs;

  Future synchronize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    synchronizeStatus.value = 'waiting';
    await checkConnection();
    if (isConnect) {
      await SyncDataController(store_: Objectbox.store_)
          .syncData(syncAll: true);
      successScackbar('Sinkronisasi Berhasil');
      synchronizeStatus.value = 'successfully';
      // set value last sync
      prefs.setString('last_sync', DateTime.now().toString());
      lastSync.value = prefs.getString('last_sync') == null
          ? 'Belum pernah melakukan Sinkronisasi data'
          : DateFormat("dd-MMMM-yyyy hh:mm a")
              .format(DateTime.parse(prefs.getString('last_sync')!));
    } else {
      errorScackbar('Tidak ada koneksi internet');
      synchronizeStatus.value = 'failed';
    }
  }

  Future checkConnection() async {
    isConnect = await global.isConnected();
  }

  @override
  void onInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lastSync.value = prefs.getString('last_sync') == null
        ? 'Belum pernah melakukan Sinkronisasi data'
        : DateFormat("dd-MMMM-yyyy hh:mm a")
            .format(DateTime.parse(prefs.getString('last_sync')!));
    super.onInit();
  }
}
