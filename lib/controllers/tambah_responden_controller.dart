import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:survey_stunting/components/error_scackbar.dart';
import 'package:survey_stunting/components/success_scackbar.dart';
import 'package:survey_stunting/models/kabupaten.dart';
import 'package:survey_stunting/models/kecamatan.dart';
import 'package:survey_stunting/models/kelurahan.dart';
import 'package:survey_stunting/models/provinsi.dart';
import 'package:survey_stunting/models/responden.dart';
import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';
import '../consts/globals_lib.dart' as global;
import '../models/localDb/helpers.dart';
import '../models/localDb/kabupaten_model.dart';
import '../models/localDb/kecamatan_model.dart';
import '../models/localDb/kelurahan_model.dart';
import '../models/localDb/provinsi_model.dart';
import '../models/localDb/responden_model.dart';

class TambahRespondenController extends GetxController {
  final kartuKeluargaTEC = TextEditingController();
  final namaKepalaKeluargaTEC = TextEditingController();
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
  var namaKepalaKeluargaError = "".obs;
  var alamatError = "".obs;
  var provinsiError = "".obs;
  var kabupatenError = "".obs;
  var kecamatanError = "".obs;
  var kelurahanError = "".obs;
  int provinsiId = 0;
  int kabupatenId = 0;
  int kecamatanId = 0;
  int kelurahanId = 0;
  late bool isConnect;
  String token = GetStorage().read("token");

  @override
  void onInit() async {
    await checkConnection();
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

  Future checkConnection() async {
    isConnect = await global.isConnected();
  }

  bool validate() {
    kartuKeluargaError.value = "";
    namaKepalaKeluargaError.value = "";
    alamatError.value = "";
    provinsiError.value = "";
    kabupatenError.value = "";
    kecamatanError.value = "";
    kelurahanError.value = "";

    if (kartuKeluargaTEC.text.trim().length < 16) {
      kartuKeluargaError.value = 'Nomor Kartu Keluarga harus 16 digit';
    }
    if (kartuKeluargaTEC.text.trim().isEmpty) {
      kartuKeluargaError.value = 'Nomor Kartu Keluarga wajib diisi';
    }
    if (namaKepalaKeluargaTEC.text.trim().isEmpty) {
      namaKepalaKeluargaError.value = 'Nama Kepala Keluarga wajib diisi';
    }
    if (alamatTEC.text.trim().isEmpty) {
      alamatError.value = "Alamat wajib diisi";
    }
    if (provinsiId == 0) {
      provinsiError.value = "Provinsi wajib diisi";
    }
    if (provinsiTEC.text.trim().isEmpty) {
      provinsiError.value = "Provinsi wajib diisi";
    }
    if (kabupatenId == 0) {
      kabupatenError.value = "Kabupaten wajib diisi";
    }
    if (kabupatenTEC.text.trim().isEmpty) {
      kabupatenError.value = "Kabupaten wajib diisi";
    }
    if (kecamatanId == 0) {
      kecamatanError.value = "Kecamatan wajib diisi";
    }
    if (kecamatanTEC.text.trim().isEmpty) {
      kecamatanError.value = "Kecamatan wajib diisi";
    }
    if (kelurahanId == 0) {
      kelurahanError.value = "Kelurahan wajib diisi";
    }
    if (kelurahanTEC.text.trim().isEmpty) {
      kelurahanError.value = "Kelurahan wajib diisi";
    }

    if (kartuKeluargaError.value.isNotEmpty ||
        namaKepalaKeluargaError.value.isNotEmpty ||
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
      await checkConnection();
      if (isConnect) {
        debugPrint('add responden online');
        try {
          Responden responden = Responden(
            kartuKeluarga: kartuKeluargaTEC.text,
            namaKepalaKeluarga: namaKepalaKeluargaTEC.text,
            alamat: alamatTEC.text,
            provinsiId: provinsiId.toString(),
            kabupatenKotaId: kabupatenId.toString(),
            kecamatanId: kecamatanId.toString(),
            desaKelurahanId: kelurahanId.toString(),
            nomorHp: nomorHPTEC.text,
          );
          await DioClient().createResponden(token: token, data: responden);
          Get.back();
          successScackbar("Data berhasil disimpan");
        } on DioError catch (e) {
          handleError(error: e);
        }
      } else {
        debugPrint('add responden local');
        List<RespondenModel> nResponden =
            await DbHelper.getResponden(Objectbox.store_);
        var responden = nResponden.firstWhereOrNull(
            (resp) => resp.kartuKeluarga == int.parse(kartuKeluargaTEC.text));
        if (responden != null) {
          errorScackbar('Responden sudah ada');
          return;
        }

        int uniqueCode = await generateUniqueCode();
        int id = await getIdResponden();
        RespondenModel respondenModel = RespondenModel(
          id: id,
          kodeUnik: uniqueCode,
          kartuKeluarga: int.parse(kartuKeluargaTEC.text),
          namaKepalaKeluarga: namaKepalaKeluargaTEC.text,
          alamat: alamatTEC.text,
          nomorHp: nomorHPTEC.text,
          provinsiId: provinsiId,
          kabupatenId: kabupatenId,
          kecamatanId: kecamatanId,
          kelurahanId: kelurahanId,
          lastModified: DateTime.now().toString(),
        );
        await DbHelper.putResponden(Objectbox.store_, [respondenModel]);
        Get.back();
        successScackbar("Data berhasil disimpan");
      }
    }
  }

  Future getProvinsi() async {
    // await checkConnection();
    // if (isConnect) {
    //   debugPrint('get provinsi online');
    //   try {
    //     List<Provinsi>? response = await DioClient().getProvinsi(
    //       token: token,
    //     );
    //     provinsi.value = response!;
    //   } on DioError catch (e) {
    //     if (e.response?.statusCode == 404) {
    //       provinsi.value = [];
    //     } else {
    //       handleError(error: e);
    //     }
    //   }
    // } else {
    try {
      debugPrint('get provinsi local');
      List<ProvinsiModel>? localProvinsi =
          await DbHelper.getProvinsi(Objectbox.store_);
      if (localProvinsi.isNotEmpty) {
        provinsi.value = localProvinsi;
      } else {
        provinsi.value = [];
        debugPrint('data provinsi not found on local, please sync from server');
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
    // }
  }

  Future getKabupaten() async {
    kabupaten.value = [];
    kabupatenTEC.text = "";
    // await checkConnection();
    // if (isConnect) {
    //   debugPrint('get kabupaten online');
    //   try {
    //     List<Kabupaten>? response = await DioClient().getKabupaten(
    //       token: token,
    //       provinsiId: provinsiId.toString(),
    //     );
    //     kabupaten.value = response!;
    //   } on DioError catch (e) {
    //     if (e.response?.statusCode == 404) {
    //       kabupaten.value = [];
    //     } else {
    //       handleError(error: e);
    //     }
    //   }
    // } else {
    try {
      debugPrint('get kabupaten local');
      List<KabupatenModel>? localKabupaten =
          await DbHelper.getKabupatenByProvinsiId(Objectbox.store_,
              provinsiId: provinsiId);
      if (localKabupaten.isNotEmpty) {
        kabupaten.value = localKabupaten;
      } else {
        kabupaten.value = [];
        debugPrint('data provinsi not found on local, please sync from server');
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
    // }
  }

  Future getKecamatan() async {
    kecamatan.value = [];
    kecamatanTEC.text = "";
    // await checkConnection();
    // if (isConnect) {
    //   debugPrint('get kecamatan online');
    //   try {
    //     List<Kecamatan>? response = await DioClient().getKecamatan(
    //       token: token,
    //       kabupatenId: kabupatenId.toString(),
    //     );
    //     kecamatan.value = response!;
    //   } on DioError catch (e) {
    //     if (e.response?.statusCode == 404) {
    //       kecamatan.value = [];
    //     } else {
    //       handleError(error: e);
    //     }
    //   }
    // } else {
    try {
      debugPrint('get kecamatan local');
      List<KecamatanModel>? localKecamatan =
          await DbHelper.getKecamatanByKabupatenId(Objectbox.store_,
              kabupatenId: kabupatenId);
      if (localKecamatan.isNotEmpty) {
        kecamatan.value = localKecamatan;
      } else {
        kecamatan.value = [];
        debugPrint(
            'data kecamatan not found on local, please sync from server');
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
    // }
  }

  Future getKelurahan() async {
    kelurahan.value = [];
    kelurahanTEC.text = "";
    // await checkConnection();
    // if (isConnect) {
    //   debugPrint('get kelurahan online');
    //   try {
    //     List<Kelurahan>? response = await DioClient().getKelurahan(
    //       token: token,
    //       kecamatanId: kecamatanId.toString(),
    //     );
    //     kelurahan.value = response!;
    //   } on DioError catch (e) {
    //     if (e.response?.statusCode == 404) {
    //       kelurahan.value = [];
    //     } else {
    //       handleError(error: e);
    //     }
    //   }
    // } else {
    try {
      debugPrint('get kelurahan local');
      List<KelurahanModel>? localKelurahan =
          await DbHelper.getKelurahanByKecamatanId(Objectbox.store_,
              kecamatanId: kecamatanId);
      if (localKelurahan.isNotEmpty) {
        kelurahan.value = localKelurahan;
      } else {
        kelurahan.value = [];
        debugPrint(
            'data kelurahan not found on local, please sync from server');
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
    // }
  }

  Future<int> generateUniqueCode() async {
    debugPrint('get data list responden local');
    List<RespondenModel>? localResponden =
        await DbHelper.getResponden(Objectbox.store_);
    late int uniqueCode;
    late List kodeUnik;
    do {
      debugPrint('generate random number');
      uniqueCode = Random.secure().nextInt(89999999) + 10000000;
      kodeUnik = localResponden
          .where((responden) => responden.kodeUnik == uniqueCode)
          .toList();
    } while (kodeUnik.isNotEmpty);
    return uniqueCode;
  }

  Future<int> getIdResponden() async {
    List<RespondenModel>? localResponden =
        await DbHelper.getResponden(Objectbox.store_);
    return localResponden.length + 1;
  }

  final maskFormatter = MaskTextInputFormatter(
    mask: '##-##-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
}
