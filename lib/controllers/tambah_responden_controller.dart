import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:survey_stunting/components/success_scackbar.dart';
import 'package:survey_stunting/models/kabupaten.dart';
import 'package:survey_stunting/models/kecamatan.dart';
import 'package:survey_stunting/models/kelurahan.dart';
import 'package:survey_stunting/models/provinsi.dart';
import 'package:survey_stunting/models/responden.dart';
import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';

class TambahRespondenController extends GetxController {
  final kartuKeluargaTEC = TextEditingController();
  final alamatTEC = TextEditingController();
  final provinsiTEC = TextEditingController();
  final kabupatenTEC = TextEditingController();
  final kecamatanTEC = TextEditingController();
  final kelurahanTEC = TextEditingController();
  final nomorHPTEC = TextEditingController();
  var provinsi = [].obs;
  var kabupaten = [].obs;
  var kecamatan = [].obs;
  var kelurahan = [].obs;
  var kartuKeluargaError = "".obs;
  var alamatError = "".obs;
  var provinsiError = "".obs;
  var kabupatenError = "".obs;
  var kecamatanError = "".obs;
  var kelurahanError = "".obs;
  late int provinsiId;
  late int kabupatenId;
  late int kecamatanId;
  late int kelurahanId;
  String token = GetStorage().read("token");

  @override
  void onInit() async {
    await getProvinsi();
    super.onInit();
  }

  @override
  void dispose() {
    provinsiTEC.dispose();
    kabupatenTEC.dispose();
    kecamatanTEC.dispose();
    kelurahanTEC.dispose();
    super.dispose();
  }

  bool validate() {
    kartuKeluargaError.value = "";
    alamatError.value = "";
    provinsiError.value = "";
    kabupatenError.value = "";
    kecamatanError.value = "";
    kelurahanError.value = "";

    if (kartuKeluargaTEC.text.trim().isEmpty) {
      kartuKeluargaError.value = 'Nomor Kartu Keluarga tidak boleh kosong';
    }
    if (alamatTEC.text.trim().isEmpty) {
      alamatError.value = "Alamat tidak boleh kosong";
    }
    if (provinsiTEC.text.trim().isEmpty) {
      provinsiError.value = "Provinsi tidak boleh kosong";
    }
    if (kabupatenTEC.text.trim().isEmpty) {
      kabupatenError.value = "Kabupaten tidak boleh kosong";
    }
    if (kecamatanTEC.text.trim().isEmpty) {
      kecamatanError.value = "Kecamatan tidak boleh kosong";
    }
    if (kelurahanTEC.text.trim().isEmpty) {
      kelurahanError.value = "Kelurahan tidak boleh kosong";
    }

    if (kartuKeluargaError.value.isNotEmpty ||
        alamatError.value.isNotEmpty ||
        provinsiError.value.isNotEmpty ||
        kabupatenError.value.isNotEmpty ||
        kecamatanError.value.isNotEmpty ||
        kelurahanError.value.isNotEmpty) {
      return false;
    }
    return true;
  }

  Future submitForm() async {
    if (validate()) {
      try {
        Responden responden = Responden(
          kartuKeluarga: kartuKeluargaTEC.text,
          alamat: alamatTEC.text,
          provinsiId: provinsiId.toString(),
          kabupatenKotaId: kabupatenId.toString(),
          kecamatanId: kecamatanId.toString(),
          desaKelurahanId: kelurahanId.toString(),
          nomorHp: nomorHPTEC.text,
        );
        await DioClient()
            .createResponden(token: token, data: respondenToJson(responden));
        Get.back();
        successScackbar("Data berhasil disimpan");
      } on DioError catch (e) {
        handleError(error: e);
      }
    }
  }

  Future getProvinsi() async {
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
  }

  Future getKabupaten() async {
    kabupaten.value = [];
    kabupatenTEC.text = "";
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
  }

  Future getKecamatan() async {
    kecamatan.value = [];
    kecamatanTEC.text = "";
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
  }

  Future getKelurahan() async {
    kelurahan.value = [];
    kelurahanTEC.text = "";
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
  }

  final maskFormatter = MaskTextInputFormatter(
    mask: '##-##-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
}
