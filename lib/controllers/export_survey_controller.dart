import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:survey_stunting/components/success_scackbar.dart';
import 'package:survey_stunting/models/jawaban_soal.dart';
import 'package:survey_stunting/models/jawaban_survey.dart';
import 'package:survey_stunting/models/kategori_soal.dart';
import 'package:survey_stunting/models/localDb/jawaban_soal_model.dart';
import 'package:survey_stunting/models/localDb/jawaban_survey_model.dart';
import 'package:survey_stunting/models/localDb/kategori_soal_model.dart';
import 'package:survey_stunting/models/localDb/nama_survey_mode.dart';
import 'package:survey_stunting/models/localDb/soal_model.dart';
import 'package:survey_stunting/models/localDb/survey_model.dart';
import 'package:survey_stunting/models/nama_survey.dart';
import 'package:survey_stunting/models/soal.dart';
import 'package:survey_stunting/models/survey.dart';
import 'package:survey_stunting/models/survey_parameters.dart';
import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';

import '../consts/globals_lib.dart' as global;

import '../models/localDb/helpers.dart';

class ExportSurveyController extends GetxController {
  final namaSurveyTEC = TextEditingController();
  var isLoaded = false.obs;
  var exportStatus = 'completed'.obs;
  String namaSurveyId = "";
  List<Survey> surveys = [];
  var namaSurvey = [].obs;
  List<KategoriSoal> kategoriSoal = [];
  List<Soal> soal = [];
  List<JawabanSurvey> jawabanSurvey = [];
  List<JawabanSoal> jawabanSoal = [];
  String token = GetStorage().read("token");
  int userId = GetStorage().read("userId");
  late bool isConnect;

  final namaSurveyIdError = "".obs;

  Future getSurvey({required dynamic namaSurveyId}) async {
    isLoaded.value = false;
    await checkConnection();
    if (isConnect) {
      debugPrint('EXPORT : get survey online');
      try {
        List<Survey>? response = await DioClient().getSurvey(
          token: token,
          queryParameters: SurveyParameters(
            namaSurveyId: namaSurveyId,
            status: "selesai",
          ),
        );
        surveys = response!;
      } on DioError catch (e) {
        if (e.response?.statusCode == 404) {
          surveys = [];
        } else {
          handleError(error: e);
        }
      }
    } else {
      debugPrint('EXPORT : get survey offline');
      var profileData =
          await DbHelper.getProfileByUserId(Objectbox.store_, userId: userId);
      int profileId = profileData!.id!;
      List<SurveyModel>? localSurveys_ = await DbHelper.getDetailSurvey(
        Objectbox.store_,
        profileId: profileId,
        isSelesai: 1,
        namaSurveyId: namaSurveyId,
      );
      surveys = localSurveys_.map((e) => Survey.fromJson(e.toJson())).toList();
    }
    isLoaded.value = true;
  }

  bool validate() {
    namaSurveyIdError.value = "";
    if (namaSurveyTEC.text.trim().isEmpty) {
      namaSurveyIdError.value = "Pilih survey yang ingin di Export";
    }

    if (namaSurveyIdError.value.isNotEmpty) {
      return false;
    }
    return true;
  }

  static Future _checkPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  static Future saveFile(String name, Uint8List bytes, String ext) async {
    await _checkPermission();
    DocumentFileSavePlus.saveFile(bytes, name + '.' + ext, "application/xlsx");
  }

  Future exportSurvey() async {
    var excel = Excel.createExcel();
    String sheetName = namaSurveyTEC.text;
    Sheet sheetObject = excel[sheetName];
    excel.setDefaultSheet(sheetName);

    // style
    CellStyle cellStyle = CellStyle(
        backgroundColorHex: "#FF7562",
        fontFamily: getFontFamily(FontFamily.Calibri));
    cellStyle.isBold = true;

    // print header table survey

    var nomorField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    nomorField.value = 'no';
    nomorField.cellStyle = cellStyle;

    var respondenIdFiled = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0));
    respondenIdFiled.cellStyle = cellStyle;
    respondenIdFiled.value = 'kode_unik_responden';

    var namaSurveyIdField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0));
    namaSurveyIdField.cellStyle = cellStyle;
    namaSurveyIdField.value = 'nama_survey_id';

    var profileIdField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0));
    profileIdField.cellStyle = cellStyle;
    profileIdField.value = 'profile_id';

    var kategoriField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0));
    kategoriField.cellStyle = cellStyle;
    kategoriField.value = 'kategori_selanjutnya';

    var isSelesaiField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0));
    isSelesaiField.cellStyle = cellStyle;
    isSelesaiField.value = 'is_selesai';

    var kodeUnikField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0));
    kodeUnikField.cellStyle = cellStyle;
    kodeUnikField.value = 'kode_unik';

    // print value survey
    int rowIndex = 0;
    for (var s in surveys) {
      int kodeUnikResponden;
      int namaSurveyId;
      int profileId;

      if (s.responden == null) {
        kodeUnikResponden = int.parse(s.kodeUnikResponden);
      } else {
        kodeUnikResponden = int.parse(s.responden!.kodeUnik);
      }

      if (s.namaSurvey == null) {
        namaSurveyId = int.parse(s.namaSurveyId);
      } else {
        namaSurveyId = s.namaSurvey!.id;
      }

      if (s.profile == null) {
        profileId = int.parse(s.profileId);
      } else {
        profileId = s.profile!.id;
      }

      sheetObject
          .cell(CellIndex.indexByColumnRow(
              columnIndex: 0, rowIndex: 1 + rowIndex))
          .value = rowIndex + 1;

      sheetObject
          .cell(CellIndex.indexByColumnRow(
              columnIndex: 1, rowIndex: 1 + rowIndex))
          .value = kodeUnikResponden;

      sheetObject
          .cell(CellIndex.indexByColumnRow(
              columnIndex: 2, rowIndex: 1 + rowIndex))
          .value = namaSurveyId;

      sheetObject
          .cell(CellIndex.indexByColumnRow(
              columnIndex: 3, rowIndex: 1 + rowIndex))
          .value = profileId;

      sheetObject
          .cell(CellIndex.indexByColumnRow(
              columnIndex: 4, rowIndex: 1 + rowIndex))
          .value = s.kategoriSelanjutnya;

      sheetObject
          .cell(CellIndex.indexByColumnRow(
              columnIndex: 5, rowIndex: 1 + rowIndex))
          .value = s.isSelesai;

      sheetObject
          .cell(CellIndex.indexByColumnRow(
              columnIndex: 6, rowIndex: 1 + rowIndex))
          .value = s.kodeUnik;

      rowIndex++;
    }

    //! web version
    // const filename = 'tableSurvey.xlsx';
    // excel.save(fileName: filename);
    //? mobile version
    final String path = (await getApplicationSupportDirectory()).path;
    final String filename = '$path/$namaSurvey.xlsx';
    final List<int>? mBytes = excel.save(fileName: filename);
    final Uint8List bytes = Uint8List.fromList(mBytes!);

    await saveFile("survey", bytes, "xlsx");
  }

  Future exportJawabanSurvey() async {
    var excel = Excel.createExcel();
    String sheetName = namaSurveyTEC.text;
    Sheet sheetObject = excel[sheetName];
    excel.setDefaultSheet(sheetName);

    // style
    CellStyle cellStyle = CellStyle(
        backgroundColorHex: "#FF7562",
        fontFamily: getFontFamily(FontFamily.Calibri));
    cellStyle.isBold = true;

    // table jawaban_survey
    // print header table jawaban_survey

    var nomorField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    nomorField.cellStyle = cellStyle;
    nomorField.value = 'no';

    var soalIdField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0));
    soalIdField.cellStyle = cellStyle;
    soalIdField.value = 'soal_id';

    var kodeUnikSurveyField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0));
    kodeUnikSurveyField.cellStyle = cellStyle;
    kodeUnikSurveyField.value = 'kode_unik_survey';

    var kategoriSoalField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0));
    kategoriSoalField.cellStyle = cellStyle;
    kategoriSoalField.value = 'kategori_soal_id';

    var jawabanSoalField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0));
    jawabanSoalField.cellStyle = cellStyle;
    jawabanSoalField.value = 'jawaban_soal_id';

    var jawabanLainnyaField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0));
    jawabanLainnyaField.cellStyle = cellStyle;
    jawabanLainnyaField.value = 'jawaban_lainnya';

    // print value jawaban_survey
    int rowIndex = 0;
    for (var s in surveys) {
      // await getJawabanSurvey(surveyId: s.id.toString());
      await getJawabanSurvey(kodeUnikSurvey: s.kodeUnik.toString());
      for (var jawaban in jawabanSurvey) {
        sheetObject
            .cell(CellIndex.indexByColumnRow(
                columnIndex: 0, rowIndex: 1 + rowIndex))
            .value = rowIndex + 1;

        sheetObject
            .cell(CellIndex.indexByColumnRow(
                columnIndex: 1, rowIndex: 1 + rowIndex))
            .value = jawaban.soalId;

        sheetObject
            .cell(CellIndex.indexByColumnRow(
                columnIndex: 2, rowIndex: 1 + rowIndex))
            .value = jawaban.kodeUnikSurvey;

        sheetObject
            .cell(CellIndex.indexByColumnRow(
                columnIndex: 3, rowIndex: 1 + rowIndex))
            .value = jawaban.kategoriSoalId;

        sheetObject
            .cell(CellIndex.indexByColumnRow(
                columnIndex: 4, rowIndex: 1 + rowIndex))
            .value = jawaban.jawabanSoalId;

        sheetObject
            .cell(CellIndex.indexByColumnRow(
                columnIndex: 5, rowIndex: 1 + rowIndex))
            .value = jawaban.jawabanLainnya;
        rowIndex++;
      }
    }
    //! web version
    // const filename = 'tableJawabanSurvey.xlsx';
    // excel.save(fileName: filename);
    //? mobile version
    final String path = (await getApplicationSupportDirectory()).path;
    final String filename = '$path/$namaSurvey.xlsx';
    final List<int>? mBytes = excel.save(fileName: filename);
    final Uint8List bytes = Uint8List.fromList(mBytes!);

    await saveFile("jawaban_survey", bytes, "xlsx");
    // OpenFile.open(filename);
  }

  Future exportResponden() async {
    var excel = Excel.createExcel();
    String sheetName = namaSurveyTEC.text;
    Sheet sheetObject = excel[sheetName];
    excel.setDefaultSheet(sheetName);

    // style
    CellStyle cellStyle = CellStyle(
        backgroundColorHex: "#FF7562",
        fontFamily: getFontFamily(FontFamily.Calibri));
    cellStyle.isBold = true;

    // table responden
    // print header table responden

    var nomorField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    nomorField.cellStyle = cellStyle;
    nomorField.value = 'no';

    var kartuKeluargaField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0));
    kartuKeluargaField.cellStyle = cellStyle;
    kartuKeluargaField.value = 'kartu_keluarga';

    var kepalaKeluargaField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0));
    kepalaKeluargaField.cellStyle = cellStyle;
    kepalaKeluargaField.value = 'nama_kepala_keluarga';

    var alamatField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0));
    alamatField.cellStyle = cellStyle;
    alamatField.value = 'alamat';

    var provinsiIdField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0));
    provinsiIdField.cellStyle = cellStyle;
    provinsiIdField.value = 'provinsi_id';

    var kabupatenField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0));
    kabupatenField.cellStyle = cellStyle;
    kabupatenField.value = 'kabupaten_kota_id';

    var kecamatanField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0));
    kecamatanField.cellStyle = cellStyle;
    kecamatanField.value = 'kecamatan_id';

    var kelurahanField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0));
    kelurahanField.cellStyle = cellStyle;
    kelurahanField.value = 'desa_kelurahan_id';

    var nomorHpField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 0));
    nomorHpField.cellStyle = cellStyle;
    nomorHpField.value = 'nomor_hp';

    var kodeUnikField = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 0));
    kodeUnikField.cellStyle = cellStyle;
    kodeUnikField.value = 'kode_unik';

    int rowIndex = 0;
    for (var s in surveys) {
      sheetObject
          .cell(CellIndex.indexByColumnRow(
              columnIndex: 0, rowIndex: 1 + rowIndex))
          .value = rowIndex + 1;

      sheetObject
          .cell(CellIndex.indexByColumnRow(
              columnIndex: 1, rowIndex: 1 + rowIndex))
          .value = s.responden!.kartuKeluarga;

      sheetObject
          .cell(CellIndex.indexByColumnRow(
              columnIndex: 2, rowIndex: 1 + rowIndex))
          .value = s.responden!.namaKepalaKeluarga;

      sheetObject
          .cell(CellIndex.indexByColumnRow(
              columnIndex: 3, rowIndex: 1 + rowIndex))
          .value = s.responden!.alamat;

      sheetObject
          .cell(CellIndex.indexByColumnRow(
              columnIndex: 4, rowIndex: 1 + rowIndex))
          .value = s.responden!.provinsiId;

      sheetObject
          .cell(CellIndex.indexByColumnRow(
              columnIndex: 5, rowIndex: 1 + rowIndex))
          .value = s.responden!.kabupatenKotaId;

      sheetObject
          .cell(CellIndex.indexByColumnRow(
              columnIndex: 6, rowIndex: 1 + rowIndex))
          .value = s.responden!.kecamatanId;

      sheetObject
          .cell(CellIndex.indexByColumnRow(
              columnIndex: 7, rowIndex: 1 + rowIndex))
          .value = s.responden!.desaKelurahanId;

      sheetObject
          .cell(CellIndex.indexByColumnRow(
              columnIndex: 8, rowIndex: 1 + rowIndex))
          .value = s.responden!.nomorHp;

      sheetObject
          .cell(CellIndex.indexByColumnRow(
              columnIndex: 9, rowIndex: 1 + rowIndex))
          .value = s.responden!.kodeUnik;

      rowIndex++;
    }
    //! web version
    // const filename = 'tableResponden.xlsx';
    // excel.save(fileName: filename);
    //? mobile version
    final String path = (await getApplicationSupportDirectory()).path;
    final String filename = '$path/$namaSurvey.xlsx';
    final List<int>? mBytes = excel.save(fileName: filename);
    final Uint8List bytes = Uint8List.fromList(mBytes!);

    await saveFile("responden", bytes, "xlsx");
    // OpenFile.open(filename);
  }

  Future exportToExcelNew() async {
    if (validate()) {
      // get nama survey (Params nama_survey_id)
      if (surveys.isNotEmpty) {
        exportStatus.value = '';

        await exportSurvey();
        await exportJawabanSurvey();
        await exportResponden();
        exportStatus.value = 'completed';
        if (exportStatus.value == 'completed') {
          successScackbar(
              'Export berhasil, Lokasi : /Android/data/com.pkg.name/files/');
        }
      }
    } else {
      debugPrint('validation failed');
    }
  }

  Future exportToExcel() async {
    if (validate()) {
      var excel = Excel.createExcel();

      String sheetName = namaSurveyTEC.text;

      Sheet sheetObject = excel[sheetName];
      excel.setDefaultSheet(sheetName);

      // get nama survey (Params nama_survey_id)
      if (surveys.isNotEmpty) {
        exportStatus.value = '';
        await getKategoriSoal();
        // await getJawabanSurvey();
        await getJawabanSoal();
        await getSoal();

        // print header table
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 4))
            .value = 'No.';
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 4))
            .value = 'Tanggal';
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 4))
            .value = 'Desa';
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 4))
            .value = 'Kecamatan';
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 4))
            .value = 'Kabupaten';
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 4))
            .value = 'Provinsi';
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 4))
            .value = 'Kartu Keluarga';

        // print kategori soal dan soal dari setiap kategori
        int i = 0;
        int j = 0;
        for (var kategori in kategoriSoal) {
          // print kategori soal to excel
          sheetObject
              .cell(CellIndex.indexByColumnRow(columnIndex: 9 + i, rowIndex: 4))
              .value = kategori.nama;

          // count soal by kategori
          List<Soal> _soal = soal
              .where(
                  (element) => int.parse(element.kategoriSoalId) == kategori.id)
              .toList();

          for (var soal in _soal) {
            sheetObject
                .cell(
                    CellIndex.indexByColumnRow(columnIndex: 9 + j, rowIndex: 5))
                .value = soal.soal;
            j++;
          }
          i += _soal.length;
        }

        // print nama survey
        String namaSurvey = surveys[0].namaSurvey!.nama;
        sheetObject.cell(CellIndex.indexByString("B2")).value = "Nama Survey :";
        sheetObject.cell(CellIndex.indexByString("D2")).value = namaSurvey;

        // print data responden
        int y = 0;
        for (var s in surveys) {
          sheetObject
              .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 6 + y))
              .value = y + 1;

          sheetObject
              .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 6 + y))
              // .value = s.responden!.createdAt;
              .value = s.createdAt;

          sheetObject
              .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 6 + y))
              .value = s.responden!.desaKelurahanId;

          sheetObject
              .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 6 + y))
              .value = s.responden!.kecamatanId;

          sheetObject
              .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 6 + y))
              .value = s.responden!.kecamatanId;

          sheetObject
              .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 6 + y))
              .value = s.responden!.provinsiId;

          sheetObject
              .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 6 + y))
              .value = s.responden!.kartuKeluarga;

          // await getJawabanSurvey(surveyId: s.id.toString());
          await getJawabanSurvey(kodeUnikSurvey: s.kodeUnik.toString());

          var getListJawaban =
              jawabanSoal.where((element) => element.soalId == "14").toList();

          for (var i in getListJawaban) {
            debugPrint(i.jawaban);
          }

          //print jawaban survey
          int x = 0;
          for (var jawaban = 0; jawaban < jawabanSurvey.length; jawaban++) {
            String? currentJawaban = '';
            if (jawabanSurvey[jawaban].jawabanLainnya != null) {
              currentJawaban = jawabanSurvey[jawaban].jawabanLainnya;
            } else {
              // cek, jika soal id == soal id sebelumnya,
              // print jawaban soal pada cell yang sama
              // buat variable untuk tampung jawaban dari soal yang sama
              var tempJawaban = [];
              if (jawabanSurvey[jawaban].soalId ==
                  jawabanSurvey[jawaban + 1].soalId) {
                x -= 1;
                // soal sama seperti soal sebelumnya

                // tambahkan jawaban sebelumnya dengan jawaban saat ini kedalam
                // array tempJawaban
                var getJawaban = jawabanSurvey
                    .where((element) =>
                        element.soalId == jawabanSurvey[jawaban].soalId)
                    .toList();

                for (var j in getJawaban) {
                  var jawaban = jawabanSoal
                      .singleWhere(
                          (element) => element.id.toString() == j.jawabanSoalId)
                      .jawaban
                      .toString();

                  tempJawaban.add(jawaban);
                }
                currentJawaban = tempJawaban.toString();
              } else {
                currentJawaban = jawabanSoal
                    .singleWhere((element) =>
                        element.id ==
                        int.parse(jawabanSurvey[jawaban].jawabanSoalId!))
                    .jawaban
                    .toString();
              }
            }
            sheetObject
                .cell(CellIndex.indexByColumnRow(
                    columnIndex: 9 + x, rowIndex: 6 + y))
                .value = currentJawaban;
            x++;
          }
          y++;
        }

        //! web version
        const filename = 'Stunting.xlsx';
        exportStatus.value = 'completed';
        excel.save(fileName: filename);
        //? mobile version
        // final String path = (await getApplicationSupportDirectory()).path;
        // final String filename = '$path/$namaSurvey.xlsx';
        // final File file = File(filename);
        // final List<int>? bytes = excel.save(fileName: filename);
        // await file.writeAsBytes(bytes!, flush: true);
        // exportStatus.value = 'completed';
        // OpenFile.open(filename);
      }
    } else {
      debugPrint('Export validation failed');
    }
  }

  Future getKategoriSoal() async {
    if (isConnect) {
      debugPrint('get kategori soal online');
      try {
        List<KategoriSoal>? response = await DioClient()
            .getKategoriSoal(token: token, namaSurveyId: namaSurveyId);
        kategoriSoal = response!;
        debugPrint(response.toString());
      } on DioError catch (e) {
        if (e.response?.statusCode == 404) {
          kategoriSoal = [];
        } else {
          handleError(error: e);
        }
      }
    } else {
      debugPrint('get kategori soal offline');
      List<KategoriSoalModel>? kategoriSoalLocal =
          await DbHelper.getKategoriSoalByNamaSurveyId(Objectbox.store_,
              namaSurveyId: int.parse(namaSurveyId));
      kategoriSoal = kategoriSoalLocal
          .map((e) => KategoriSoal.fromJson(e.toJson()))
          .toList();
    }
  }

  Future getSoal() async {
    if (isConnect) {
      debugPrint('get soal online');
      try {
        List<Soal>? response = await DioClient().getSoal(token: token);
        soal = response!;
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      debugPrint('get soal offline');
      List<SoalModel> soalLocal = await DbHelper.getSoal(Objectbox.store_);
      soal = soalLocal.map((e) => Soal.fromJson(e.toJson())).toList();
    }
  }

  Future getJawabanSurvey({required String kodeUnikSurvey}) async {
    if (jawabanSurvey.isNotEmpty) {
      jawabanSurvey.clear();
    }
    if (isConnect) {
      debugPrint('get jawaban survey online');
      try {
        List<JawabanSurvey>? response = await DioClient()
            .getJawabanSurvey(token: token, kodeUnikSurvey: kodeUnikSurvey);
        jawabanSurvey = response!;
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      debugPrint('get jawaban survey offline');
      List<JawabanSurveyModel>? jawabanSurveyLocal =
          await DbHelper.getJawabanSurveyByKodeUnikSurveyId(Objectbox.store_,
              kodeUnikSurveyId: int.parse(kodeUnikSurvey));
      jawabanSurvey = jawabanSurveyLocal
          .map((e) => JawabanSurvey.fromJson(e.toJson()))
          .toList();
    }
  }

  Future getJawabanSoal() async {
    if (isConnect) {
      debugPrint('get jawaban soal online');
      try {
        List<JawabanSoal>? response =
            await DioClient().getJawabanSoal(token: token);
        jawabanSoal = response!;
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      debugPrint('get jawaban soal offline');
      List<JawabanSoalModel>? jawabanSoalLocal =
          await DbHelper.getJawabanSoal(Objectbox.store_);
      jawabanSoal = jawabanSoalLocal
          .map((e) => JawabanSoal.fromJson(e.toJson()))
          .toList();
    }
  }

  Future getNamaSurvey() async {
    namaSurvey.value = [];
    if (isConnect) {
      debugPrint('get nama survey online');
      try {
        List<NamaSurvey>? nResponse =
            await DioClient().getNamaSurvey(token: token);
        if (nResponse != null) {
          List<NamaSurvey> response =
              nResponse.where((element) => element.isAktif == 1).toList();
          namaSurvey.value = response;
        }
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      debugPrint('get nama survey offline');
      List<NamaSurveyModel>? nLocalNamaSurvey =
          await DbHelper.getNamaSurvey(Objectbox.store_);
      List<NamaSurveyModel> localNamaSurvey =
          nLocalNamaSurvey.where((element) => element.isAktif == 1).toList();
      namaSurvey.value = localNamaSurvey;
    }
  }

  Future checkConnection() async {
    isConnect = await global.isConnected();
  }

  @override
  void onInit() async {
    await checkConnection();
    await getSurvey(namaSurveyId: namaSurveyId);
    await getNamaSurvey();
    await _checkPermission();
    super.onInit();
  }

  @override
  void dispose() {
    namaSurveyTEC.dispose();
    super.dispose();
  }
}
