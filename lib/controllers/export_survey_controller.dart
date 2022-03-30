import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_stunting/models/jawaban_soal.dart';
import 'package:survey_stunting/models/jawaban_survey.dart';
import 'package:survey_stunting/models/kategori_soal.dart';
import 'package:survey_stunting/models/nama_survey.dart';
import 'package:survey_stunting/models/soal.dart';
import 'package:survey_stunting/models/survey.dart';
import 'package:survey_stunting/models/survey_parameters.dart';
import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';

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

  final namaSurveyIdError = "".obs;

  Future getSurvey({required dynamic namaSurveyId}) async {
    isLoaded.value = false;
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

          await getJawabanSurvey(surveyId: s.id.toString());

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
                  jawabanSurvey[jawaban - 1].soalId) {
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
  }

  Future getSoal() async {
    try {
      List<Soal>? response = await DioClient().getSoal(token: token);
      soal = response!;
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future getJawabanSurvey({required String surveyId}) async {
    if (jawabanSurvey.isNotEmpty) {
      jawabanSurvey.clear();
    }
    try {
      List<JawabanSurvey>? response =
          await DioClient().getJawabanSurvey(token: token, surveyId: surveyId);
      jawabanSurvey = response!;
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future getJawabanSoal() async {
    try {
      List<JawabanSoal>? response =
          await DioClient().getJawabanSoal(token: token);
      jawabanSoal = response!;
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future getNamaSurvey() async {
    namaSurvey.value = [];
    try {
      List<NamaSurvey>? response =
          await DioClient().getNamaSurvey(token: token);
      namaSurvey.value = response!;
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  @override
  void onInit() async {
    await getSurvey(namaSurveyId: namaSurveyId);
    await getNamaSurvey();
    super.onInit();
  }

  @override
  void dispose() {
    namaSurveyTEC.dispose();
    super.dispose();
  }
}
