import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_stunting/models/survey.dart';
import 'package:survey_stunting/models/survey_parameters.dart';
import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';

class ExportSurveyController extends GetxController {
  final jenisSurveyEditingController = TextEditingController(text: "Pre");
  var isLoaded = false.obs;
  String namaSurveyId = "2";
  List<Survey> surveys = [];
  String token = GetStorage().read("token");

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

  Future exportToExcel() async {
    var excel = Excel.createExcel();

    Sheet sheetObject = excel['Survey Stunting'];
    excel.setDefaultSheet('Survey Stunting');

    // get nama survey (Params nama_survey_id)
    if (surveys.isNotEmpty) {
      String namaSurvey = surveys[0].namaSurvey!.nama;
      sheetObject.cell(CellIndex.indexByString("B2")).value = "Nama Survey :";
      sheetObject.cell(CellIndex.indexByString("D2")).value = namaSurvey;
    }

    // looping kategori soal by nama_survey_id

    //print kategori soal to excel

    // looping soal berdasarkan kategori_soal_id
    // looping jawaban soal

    sheetObject.cell(CellIndex.indexByString("B4")).value = "No.";
    sheetObject.cell(CellIndex.indexByString("C4")).value = "Tanggal";
    sheetObject.cell(CellIndex.indexByString("D4")).value = "Desa";
    sheetObject.cell(CellIndex.indexByString("E4")).value = "Kecamatan";
    sheetObject.cell(CellIndex.indexByString("F4")).value = "Kabupaten";
    sheetObject.cell(CellIndex.indexByString("G4")).value = "Kartu Keluarga";
    sheetObject.cell(CellIndex.indexByString("H4")).value = "Demografi";
    sheetObject.cell(CellIndex.indexByString("H5")).value = "Nama Responden";
    sheetObject.cell(CellIndex.indexByString("I5")).value =
        "Nomor Telepon/Handphone";
    sheetObject.cell(CellIndex.indexByString("J5")).value = "Nama Ayah";

    // var namaSurvey1 = sheetObject
    //     .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 2))
    //     .value = 'cell value';

    String filename = DateTime.now().toString();
    excel.save(fileName: filename + ".xlsx");
  }

  @override
  void onInit() async {
    await getSurvey(namaSurveyId: namaSurveyId);
    super.onInit();
  }

  @override
  void dispose() {
    jenisSurveyEditingController.dispose();
    super.dispose();
  }
}
