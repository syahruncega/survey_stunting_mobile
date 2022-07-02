import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:survey_stunting/components/error_scackbar.dart';
import 'package:survey_stunting/components/success_scackbar.dart';
import 'package:survey_stunting/models/kabupaten.dart';
import 'package:survey_stunting/models/kecamatan.dart';
import 'package:survey_stunting/models/kelurahan.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/models/provinsi.dart';
import 'package:survey_stunting/models/user_profile.dart';
import 'package:survey_stunting/routes/route_name.dart';
import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';
import '../consts/globals_lib.dart' as global;
import '../models/institusi.dart';

class LengkapiProfilController extends GetxController {
  String token = GetStorage().read("token");
  int userId = GetStorage().read("userId");
  late bool isConnect;

  final namaLengkapTextController = TextEditingController();
  final jenisKelaminTextController = TextEditingController();
  final tempatLahirTextController = TextEditingController();
  final tglLahirTextController = TextEditingController();
  final alamatTextController = TextEditingController();
  final provinsiTEC = TextEditingController();
  final kabupatenTEC = TextEditingController();
  final kecamatanTEC = TextEditingController();
  final kelurahanTEC = TextEditingController();
  final nomorHpTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final institusiTextController = TextEditingController();

  Rx<UserProfile> profileData = UserProfile().obs;
  var provinsi = [].obs;
  var kabupaten = [].obs;
  var kecamatan = [].obs;
  var kelurahan = [].obs;
  var institusi = [].obs;

  int provinsiId = 0;
  int kabupatenId = 0;
  int kecamatanId = 0;
  int kelurahanId = 0;
  int institusiId = 0;

  var isLoaded = false.obs;
  var profileUpdateStatus = ''.obs;

  var namaLengkapError = ''.obs;
  var jenisKelaminError = ''.obs;
  var tempatLahirError = ''.obs;
  var tglLahirError = ''.obs;
  var alamatError = ''.obs;
  var provinsiError = ''.obs;
  var kabupatenError = ''.obs;
  var kecamatanError = ''.obs;
  var kelurahanError = ''.obs;
  var nomorHpError = ''.obs;
  var emailError = ''.obs;
  var namaInstitusiError = ''.obs;

  final tglLahirMaskFormatter = MaskTextInputFormatter(
    mask: '####-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  final nomorHpMaskFormatter = MaskTextInputFormatter(
    mask: '############',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  Future getProvinsi() async {
    if (isConnect) {
      debugPrint('get provinsi online');
      try {
        List<Provinsi>? response = await DioClient().getProvinsi(
          token: token,
        );
        provinsi.value = response!;
      } on DioError catch (e) {
        if (e.response?.statusCode == 404) {
          provinsi.value = [];
        } else {
          handleError(error: e);
        }
      }
    } else {
      errorScackbar('Gagal menampilkan provinsi. Tidak ada koneksi internet');
    }
  }

  Future getKabupaten() async {
    kabupaten.value = [];
    kabupatenTEC.text = "";
    if (isConnect) {
      debugPrint('get kabupaten online');
      try {
        List<Kabupaten>? response = await DioClient().getKabupaten(
          token: token,
          provinsiId: provinsiId.toString(),
        );
        kabupaten.value = response!;
      } on DioError catch (e) {
        if (e.response?.statusCode == 404) {
          kabupaten.value = [];
        } else {
          handleError(error: e);
        }
      }
    } else {
      errorScackbar('Gagal menampilkan Kabupaten. Tidak ada koneksi internet');
    }
  }

  Future getKecamatan() async {
    kecamatan.value = [];
    kecamatanTEC.text = "";
    if (isConnect) {
      debugPrint('get kecamatan online');
      try {
        List<Kecamatan>? response = await DioClient().getKecamatan(
          token: token,
          kabupatenId: kabupatenId.toString(),
        );
        kecamatan.value = response!;
      } on DioError catch (e) {
        if (e.response?.statusCode == 404) {
          kecamatan.value = [];
        } else {
          handleError(error: e);
        }
      }
    } else {
      errorScackbar('Gagal menampilkan kecamatan. Tidak ada koneksi internet');
    }
  }

  Future getKelurahan() async {
    kelurahan.value = [];
    kelurahanTEC.text = "";
    if (isConnect) {
      debugPrint('get kelurahan online');
      try {
        List<Kelurahan>? response = await DioClient().getKelurahan(
          token: token,
          kecamatanId: kecamatanId.toString(),
        );
        kelurahan.value = response!;
      } on DioError catch (e) {
        if (e.response?.statusCode == 404) {
          kelurahan.value = [];
        } else {
          handleError(error: e);
        }
      }
    } else {
      errorScackbar('Gagal menampilkan kelurahan. Tidak ada koneksi internet');
    }
  }

  Future getInstitusi() async {
    institusi.value = [];
    institusiTextController.text = "";
    try {
      List<Institusi>? response = await DioClient().getInstitusi(token: token);
      if (response != null) {
        institusi.value = response;
      } else {
        institusi.value = [];
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future updateUserProfile({
    required String nama,
    required String jenisKelamin,
    required String tempatLahir,
    required String tglLahir,
    required String alamat,
    required String nomorHp,
    String? email,
  }) async {
    if (validate()) {
      if (isConnect) {
        debugPrint('update user profile online');
        try {
          profileUpdateStatus.value = 'waiting';
          bool response = await DioClient().updateProfile(
            token: token,
            nama: nama,
            jenisKelamin: jenisKelamin,
            tempatLahir: tempatLahir,
            tglLahir: tglLahir,
            alamat: alamat,
            provinsi: provinsiId.toString(),
            kabupaten: kabupatenId.toString(),
            kecamatan: kecamatanId.toString(),
            kelurahan: kelurahanId.toString(),
            nomorHp: nomorHp,
            email: email,
            institusiId: institusiId.toString(),
            updatedAt: DateTime.now().toString(),
          );
          if (response) {
            profileUpdateStatus.value = 'successful';
            successScackbar('Profile berhasil disimpan.');
            Get.offAllNamed(RouteName.layout);
          } else {
            profileUpdateStatus.value = 'failed';
            errorScackbar('Gagal menyimpan data profil.');
          }
        } on DioError catch (e) {
          handleError(error: e);
        }
      } else {
        errorScackbar('Tidak dapat menyimpan data. Tidak ada koneksi internet');
      }
    } else {
      debugPrint('validation failed');
    }
  }

  bool validate() {
    namaLengkapError.value = '';
    jenisKelaminError.value = '';
    tempatLahirError.value = '';
    tglLahirError.value = '';
    alamatError.value = '';
    provinsiError.value = '';
    kabupatenError.value = '';
    kecamatanError.value = '';
    kelurahanError.value = '';
    nomorHpError.value = '';
    namaInstitusiError.value = '';

    if (institusiTextController.value.text.trim().isEmpty) {
      namaInstitusiError.value = 'Nama Institusi wajib diisi';
    }

    if (institusiId == 0) {
      namaInstitusiError.value = 'Nama Institusi wajib diisi';
    }

    if (namaLengkapTextController.value.text.trim().isEmpty) {
      namaLengkapError.value = 'Nama wajib diisi';
    }

    if (jenisKelaminTextController.value.text.trim().isEmpty) {
      jenisKelaminError.value = 'Jenis Kelamin wajib diisi';
    }

    if (tempatLahirTextController.value.text.trim().isEmpty) {
      tempatLahirError.value = 'Tempat lahir wajib diisi';
    }

    if (tglLahirTextController.value.text.trim().isEmpty) {
      tglLahirError.value = 'Tanggal lahir wajib diisi';
    }

    if (alamatTextController.value.text.trim().isEmpty) {
      alamatError.value = 'Alamat wajib diisi';
    }

    if (provinsiTEC.value.text.trim().isEmpty) {
      provinsiError.value = 'Provinsi wajib diisi';
    }

    if (provinsiId == 0) {
      provinsiError.value = 'Provinsi wajib diisi';
    }

    if (provinsiTEC.value.text.trim().contains('-')) {
      provinsiError.value = 'Provinsi tidak valid';
    }

    if (kabupatenTEC.value.text.trim().isEmpty) {
      kabupatenError.value = 'Kabupaten wajib diisi';
    }

    if (kabupatenId == 0) {
      kabupatenError.value = 'Kabupaten wajib diisi';
    }

    if (kabupatenTEC.value.text.trim().contains('-')) {
      kabupatenError.value = 'Kabupaten tidak valid';
    }

    if (kecamatanTEC.value.text.trim().isEmpty) {
      kecamatanError.value = 'Kecamatan wajib diisi';
    }

    if (kecamatanId == 0) {
      kecamatanError.value = 'Kecamatan wajib diisi';
    }

    if (kecamatanTEC.value.text.trim().contains('-')) {
      kecamatanError.value = 'Kecamatan tidak valid';
    }

    if (kelurahanTEC.value.text.trim().isEmpty) {
      kelurahanError.value = 'Kelurahan wajib diisi';
    }

    if (kelurahanId == 0) {
      kelurahanError.value = 'Kelurahan wajib diisi';
    }

    if (kelurahanTEC.value.text.trim().contains('-')) {
      kelurahanError.value = 'Kelurahan tidak valid';
    }

    if (nomorHpTextController.value.text.trim().isEmpty) {
      nomorHpError.value = 'Nomor Hp wajib diisi';
    }

    if (namaLengkapError.value.isNotEmpty ||
        jenisKelaminError.value.isNotEmpty ||
        tempatLahirError.value.isNotEmpty ||
        tglLahirError.value.isNotEmpty ||
        alamatError.value.isNotEmpty ||
        provinsiError.value.isNotEmpty ||
        kabupatenError.value.isNotEmpty ||
        kecamatanError.value.isNotEmpty ||
        kelurahanError.value.isNotEmpty ||
        nomorHpError.value.isNotEmpty ||
        namaInstitusiError.value.isNotEmpty) {
      return false;
    }
    return true;
  }

  Future checkConnection() async {
    isConnect = await global.isConnected();
  }

  @override
  void onInit() async {
    isLoaded.value = false;
    await checkConnection();
    await getInstitusi();
    await getProvinsi();
    await getKabupaten();
    await getKecamatan();
    await getKelurahan();
    isLoaded.value = true;
    super.onInit();
  }
}
