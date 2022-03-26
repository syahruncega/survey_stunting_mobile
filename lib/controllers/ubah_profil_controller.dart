import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:survey_stunting/components/error_scackbar.dart';
import 'package:survey_stunting/components/success_snackbar.dart';
import 'package:survey_stunting/models/kabupaten.dart';
import 'package:survey_stunting/models/kecamatan.dart';
import 'package:survey_stunting/models/kelurahan.dart';
import 'package:survey_stunting/models/provinsi.dart';
import 'package:survey_stunting/models/user_profile.dart';
import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';

class UbahProfilController extends GetxController {
  String token = GetStorage().read("token");

  final namaLengkapTextController = TextEditingController().obs;
  final jenisKelaminTextController = TextEditingController().obs;
  final tempatLahirTextController = TextEditingController().obs;
  final tglLahirTextController = TextEditingController().obs;
  final alamatTextController = TextEditingController().obs;
  final provinsiTextController = TextEditingController().obs;
  final kabupatenTextController = TextEditingController().obs;
  final kecamatanTextController = TextEditingController().obs;
  final kelurahanTextController = TextEditingController().obs;
  final nomorHpTextController = TextEditingController().obs;
  final emailTextController = TextEditingController().obs;

  Rx<UserProfile> profileData = UserProfile().obs;
  Rx<Provinsi> provinsiData = Provinsi().obs;
  Rx<Kabupaten> kabupatenData = Kabupaten().obs;
  Rx<Kecamatan> kecamatanData = Kecamatan().obs;
  Rx<Kelurahan> kelurahanData = Kelurahan().obs;

  final List<Map<String, dynamic>> listProvinsi = [];
  final List<Map<String, dynamic>> listKabupaten = [];
  final List<Map<String, dynamic>> listKecamatan = [];
  final List<Map<String, dynamic>> listKelurahan = [];

  var currentProvinsiId = ''.obs;
  var currentKabupatenId = ''.obs;
  var currentKecamatanId = ''.obs;
  var currentKelurahanId = ''.obs;

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

  Future getUserProfile() async {
    try {
      UserProfile? response = await DioClient().getProfile(token: token);
      profileData.value = response!;
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future getProvinsi() async {
    try {
      Provinsi? response = await DioClient().getProvinsi(token: token);
      provinsiData.value = response;
      for (var i in provinsiData.value.data!) {
        listProvinsi.add({
          'label': i.nama,
          'value': i.id.toString(),
        });
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future getKabupaten() async {
    try {
      Kabupaten? response = await DioClient().getKabupaten(token: token);
      kabupatenData.value = response;
      for (var i in kabupatenData.value.data!) {
        listKabupaten.add({
          'label': i.nama,
          'value': i.id.toString(),
        });
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future getKecamatan() async {
    try {
      Kecamatan? response = await DioClient().getKecamatan(token: token);
      kecamatanData.value = response;
      for (var i in kecamatanData.value.data!) {
        listKecamatan.add({
          'label': i.nama,
          'value': i.id.toString(),
        });
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future getKelurahan() async {
    try {
      Kelurahan? response = await DioClient().getKelurahan(token: token);
      kelurahanData.value = response;
      for (var i in kelurahanData.value.data!) {
        listKelurahan.add({
          'label': i.nama,
          'value': i.id.toString(),
        });
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
    required String email,
  }) async {
    if (validate()) {
      try {
        profileUpdateStatus.value = 'waiting';
        bool response = await DioClient().updateProfile(
            token: token,
            nama: nama,
            jenisKelamin: jenisKelamin,
            tempatLahir: tempatLahir,
            tglLahir: tglLahir,
            alamat: alamat,
            provinsi: currentProvinsiId.value,
            kabupaten: currentKabupatenId.value,
            kecamatan: currentKecamatanId.value,
            kelurahan: currentKelurahanId.value,
            nomorHp: nomorHp,
            email: email);
        if (response) {
          profileUpdateStatus.value = 'successful';
          successSnackbar('Profile berhasil diupdate.');
        } else {
          profileUpdateStatus.value = 'failed';
          errorScackbar('Update profile gagal.');
        }
      } on DioError catch (e) {
        handleError(error: e);
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
    emailError.value = '';

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

    if (provinsiTextController.value.text.trim().isEmpty) {
      provinsiError.value = 'Provinsi wajib diisi';
    }

    if (provinsiTextController.value.text.trim().contains('-')) {
      provinsiError.value = 'Provinsi tidak valid';
    }

    if (kabupatenTextController.value.text.trim().isEmpty) {
      kabupatenError.value = 'Kabupaten wajib diisi';
    }

    if (kabupatenTextController.value.text.trim().contains('-')) {
      kabupatenError.value = 'Kabupaten tidak valid';
    }

    if (kecamatanTextController.value.text.trim().isEmpty) {
      kecamatanError.value = 'Kecamatan wajib diisi';
    }

    if (kecamatanTextController.value.text.trim().contains('-')) {
      kecamatanError.value = 'Kecamatan tidak valid';
    }

    if (kelurahanTextController.value.text.trim().isEmpty) {
      kelurahanError.value = 'Kelurahan wajib diisi';
    }

    if (kelurahanTextController.value.text.trim().contains('-')) {
      kelurahanError.value = 'Kelurahan tidak valid';
    }

    if (nomorHpTextController.value.text.trim().isEmpty) {
      nomorHpError.value = 'Nomor Hp wajib diisi';
    }

    if (emailTextController.value.text.trim().isEmpty) {
      emailError.value = 'E-mail wajib diisi';
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
        emailError.value.isNotEmpty) {
      return false;
    }
    return true;
  }

  getKabupatenByProvinsiId({required int provinsiId}) {}
  getKecamatanByKabupatenId({required int kabupatenId}) {}
  getKelurahanByKecamatanId({required int kecamatanId}) {}

  void updateUserAddressUi(
      {String? provinsiId,
      String? kabupatenId,
      String? kecamatanId,
      String? kelurahanId}) {
    if (provinsiId != null) {
      currentProvinsiId.value = provinsiId;
      listKabupaten.clear();
      for (var i in kabupatenData.value.data!) {
        if (i.provinsiId == provinsiId) {
          listKabupaten.add({
            'label': i.nama,
            'value': i.id.toString(),
          });
        }
      }
      kabupatenTextController.value.text = "--- Pilih Kabupaten ---";
      kecamatanTextController.value.text = "--- Pilih Kecamatan ---";
      kelurahanTextController.value.text = "--- Pilih Kelurahan ---";
    }

    if (kabupatenId != null) {
      currentKabupatenId.value = kabupatenId;
      listKecamatan.clear();
      for (var i in kecamatanData.value.data!) {
        if (i.kabupatenKotaId == kabupatenId) {
          listKecamatan.add({
            'label': i.nama,
            'value': i.id.toString(),
          });
        }
      }
      kecamatanTextController.value.text = "--- Pilih Kecamatan ---";
      kelurahanTextController.value.text = "--- Pilih Kelurahan ---";
    }

    if (kecamatanId != null) {
      currentKecamatanId.value = kecamatanId;
      listKelurahan.clear();
      for (var i in kelurahanData.value.data!) {
        if (i.kecamatanId == kecamatanId) {
          listKelurahan.add({
            'label': i.nama,
            'value': i.id.toString(),
          });
        }
      }
      kelurahanTextController.value.text = "--- Pilih Kelurahan ---";
    }

    if (kelurahanId != null) {
      currentKelurahanId.value = kelurahanId;
    }
  }

  void displayUserData() {
    String userProvinsi;
    String userKabupaten;
    String userKecamatan;
    String userKelurahan;

    isLoaded.value = false;

    if (profileData.value.data != null) {
      namaLengkapTextController.value.text =
          profileData.value.data!.namaLengkap;
      jenisKelaminTextController.value.text =
          profileData.value.data!.jenisKelamin;
      tempatLahirTextController.value.text =
          profileData.value.data!.tempatLahir;
      tglLahirTextController.value.text = profileData.value.data!.tanggalLahir;
      alamatTextController.value.text = profileData.value.data!.alamat;
      nomorHpTextController.value.text = profileData.value.data!.nomorHp;
      emailTextController.value.text = profileData.value.data!.email;

      int userProvinsiId = int.parse(profileData.value.data!.provinsi);
      int userKabupatenId = int.parse(profileData.value.data!.kabupatenKota);
      int userKecamatanId = int.parse(profileData.value.data!.kecamatan);
      int userKelurahanId = int.parse(profileData.value.data!.desaKelurahan);

      userProvinsi = provinsiData.value.data!
          .singleWhere((element) => element.id == userProvinsiId)
          .nama
          .toString();
      provinsiTextController.value.text = userProvinsi.toString();

      userKabupaten = kabupatenData.value.data!
          .singleWhere((element) => element.id == userKabupatenId)
          .nama
          .toString();
      kabupatenTextController.value.text = userKabupaten;

      userKecamatan = kecamatanData.value.data!
          .singleWhere((element) => element.id == userKecamatanId)
          .nama
          .toString();
      kecamatanTextController.value.text = userKecamatan;

      userKelurahan = kelurahanData.value.data!
          .singleWhere((element) => element.id == userKelurahanId)
          .nama
          .toString();
      kelurahanTextController.value.text = userKelurahan;

      //set initial value of user address
      currentProvinsiId.value = profileData.value.data!.provinsi;
      currentKabupatenId.value = profileData.value.data!.kabupatenKota;
      currentKecamatanId.value = profileData.value.data!.kecamatan;
      currentKelurahanId.value = profileData.value.data!.desaKelurahan;

      isLoaded.value = true;
    }
  }

  @override
  void onInit() async {
    await getUserProfile();
    await getProvinsi();
    await getKabupaten();
    await getKecamatan();
    await getKelurahan();
    displayUserData();
    super.onInit();
  }
}
