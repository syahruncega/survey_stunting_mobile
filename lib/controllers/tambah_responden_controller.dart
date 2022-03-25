import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:survey_stunting/models/kabupaten.dart';
import 'package:survey_stunting/models/kecamatan.dart';
import 'package:survey_stunting/models/kelurahan.dart';
import 'package:survey_stunting/models/provinsi.dart';
import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';

class TambahRespondenController extends GetxController {
  final provinsiTEC = TextEditingController();
  final kabupatenTEC = TextEditingController();
  final kecamatanTEC = TextEditingController();
  final kelurahanTEC = TextEditingController();
  late int idProvinsi;
  late int idKabupaten;
  late int idKecamatan;
  late int idKelurahan;
  final provinsi = [].obs;
  final kabupaten = [].obs;
  final kecamatan = [].obs;
  final kelurahan = [].obs;
  String token = GetStorage().read("token");

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
        idProvinsi: idProvinsi.toString(),
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
        idKabupaten: idKabupaten.toString(),
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
        idKecamatan: idKecamatan.toString(),
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

  @override
  void onInit() async {
    // provinsiTEC.addListener(() {
    //   kabupatenTEC.text = "";
    // });
    // kabupatenTEC.addListener(() {
    //   kecamatanTEC.text = "";
    // });
    // kecamatanTEC.addListener(() {
    //   kelurahanTEC.text = "";
    // });
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
}
