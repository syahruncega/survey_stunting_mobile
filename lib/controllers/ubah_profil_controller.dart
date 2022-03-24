import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
  final provinsiTextController = TextEditingController();
  final kabupatenTextController = TextEditingController();
  final kecamatanTextController = TextEditingController();
  final kelurahanTextController = TextEditingController();
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

  var isLoaded = false.obs;

  final maskFormatter = MaskTextInputFormatter(
    mask: '####-##-##',
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

  getKabupatenByProvinsiId({required int provinsiId}) {}
  getKecamatanByKabupatenId({required int kabupatenId}) {}
  getKelurahanByKecamatanId({required int kecamatanId}) {}

  void updateUserAddressUi(
      {String? provinsiId, String? kabupatenId, String? kecamatanId}) {
    if (provinsiId != null) {
      listKabupaten.clear();
      for (var i in kabupatenData.value.data!) {
        if (i.provinsiId == provinsiId) {
          listKabupaten.add({
            'label': i.nama,
            'value': i.id.toString(),
          });
        }
      }
      kabupatenTextController.text = "--- Pilih Kabupaten ---";
    }

    if (kabupatenId != null) {
      listKecamatan.clear();
      for (var i in kecamatanData.value.data!) {
        if (i.kabupatenKotaId == kabupatenId) {
          listKecamatan.add({
            'label': i.nama,
            'value': i.id.toString(),
          });
        }
      }
      kecamatanTextController.text = "--- Pilih Kecamatan ---";
    }

    if (kecamatanId != null) {
      listKelurahan.clear();
      for (var i in kelurahanData.value.data!) {
        if (i.kecamatanId == kecamatanId) {
          listKelurahan.add({
            'label': i.nama,
            'value': i.id.toString(),
          });
        }
      }
      kelurahanTextController.text = "--- Pilih Kelurahan";
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
      provinsiTextController.text = userProvinsi.toString();

      userKabupaten = kabupatenData.value.data!
          .singleWhere((element) => element.id == userKabupatenId)
          .nama
          .toString();
      kabupatenTextController.text = userKabupaten;

      userKecamatan = kecamatanData.value.data!
          .singleWhere((element) => element.id == userKecamatanId)
          .nama
          .toString();
      kecamatanTextController.text = userKecamatan;

      userKelurahan = kelurahanData.value.data!
          .singleWhere((element) => element.id == userKelurahanId)
          .nama
          .toString();
      kelurahanTextController.text = userKelurahan;

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
