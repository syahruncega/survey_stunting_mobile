import 'dart:developer';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_stunting/components/success_scackbar.dart';
import 'package:survey_stunting/models/nama_survey.dart';
import 'package:survey_stunting/models/responden.dart';
import 'package:survey_stunting/models/session.dart';
import 'package:survey_stunting/models/survey.dart';
import 'package:survey_stunting/models/survey_parameters.dart';
import 'package:survey_stunting/routes/route_name.dart';
import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';

import '../models/localDb/helpers.dart';
import '../models/localDb/nama_survey_mode.dart';
import '../models/localDb/responden_model.dart';
import '../models/localDb/survey_model.dart';

class SurveyController extends GetxController {
  final typeSurveyEditingController = TextEditingController();
  final statusSurveyEditingController = TextEditingController();
  final searchSurveyEditingController = TextEditingController();
  final respondenTEC = TextEditingController();
  final namaSurveyTEC = TextEditingController();
  final respondenError = "".obs;
  final namaSurveyError = "".obs;
  var isLoading = false.obs;
  var isLoadingFilter = false.obs;
  String typeSurvey = "";
  String statusSurvey = "";
  late int kodeUnikResponden;
  late int namaSurveyId;
  List<Survey> surveys = [];
  List<Responden> responden = [];
  List<NamaSurvey> namaSurvey = [];
  String token = GetStorage().read("token");
  Session session = sessionFromJson(GetStorage().read("session"));
  int userId = GetStorage().read("userId");

  Future getSurvey({SurveyParameters? queryParameters}) async {
    final prefs = await SharedPreferences.getInstance();
    bool offlineMode = prefs.getBool('offline_mode') ?? false;
    isLoading.value = true;
    if (!offlineMode) {
      debugPrint('get online survey');
      try {
        List<Survey>? response = await DioClient().getSurvey(
          token: token,
          queryParameters: queryParameters,
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
      debugPrint('get local survey');
      var profileData =
          await DbHelper.getProfileByUserId(Objectbox.store_, userId: userId);
      int profileId = profileData!.id!;
      List<SurveysModel>? localSurveys_ = await DbHelper.getDetailSurvey(
        Objectbox.store_,
        profileId: profileId,
        isSelesai: (statusSurvey == "selesai")
            ? 1
            : (statusSurvey == "belum_selesai")
                ? 0
                : null,
        namaSurveyId: (typeSurvey == "pre")
            ? "2"
            : (typeSurvey == "post")
                ? "1"
                : null,
        keyword: searchSurveyEditingController.text == ""
            ? null
            : searchSurveyEditingController.text,
      );
      inspect(localSurveys_);
      surveys = localSurveys_.map((e) => Survey.fromJson(e.toJson())).toList();
    }
    isLoading.value = false;
  }

  Future getResponden() async {
    final prefs = await SharedPreferences.getInstance();
    bool offlineMode = prefs.getBool('offline_mode') ?? false;
    if (!offlineMode) {
      debugPrint('get online responden');
      try {
        List<Responden>? response = await DioClient().getResponden(
          token: token,
        );
        responden = response!;
      } on DioError catch (e) {
        if (e.response?.statusCode == 404) {
          responden = [];
        } else {
          handleError(error: e);
        }
      }
    } else {
      debugPrint('get local responden');
      List<RespondenModel>? localResponden =
          await DbHelper.getResponden(Objectbox.store_);
      responden =
          localResponden.map((e) => Responden.fromJson(e.toJson())).toList();
    }
  }

  Future getNamaSurvey() async {
    final prefs = await SharedPreferences.getInstance();
    bool offlineMode = prefs.getBool('offline_mode') ?? false;
    if (!offlineMode) {
      debugPrint('get online nama survey');
      try {
        List<NamaSurvey>? response = await DioClient().getNamaSurvey(
          token: token,
        );
        namaSurvey = response!;
      } on DioError catch (e) {
        if (e.response?.statusCode == 404) {
          namaSurvey = [];
        } else {
          handleError(error: e);
        }
      }
    } else {
      debugPrint('message: get local nama survey');
      List<NamaSurveyModel>? localNamaSurvey =
          await DbHelper.getNamaSurvey(Objectbox.store_);
      namaSurvey =
          localNamaSurvey.map((e) => NamaSurvey.fromJson(e.toJson())).toList();
    }
  }

  bool validate() {
    respondenError.value = "";
    namaSurveyError.value = "";
    if (respondenTEC.text.trim() == "") {
      respondenError.value = "Responden wajib diisi";
    }
    if (namaSurveyTEC.text.trim() == "") {
      namaSurveyError.value = "Nama survey wajib diisi";
    }
    if (respondenError.value.isNotEmpty || namaSurveyError.value.isNotEmpty) {
      return false;
    }
    return true;
  }

  Future submitForm() async {
    final prefs = await SharedPreferences.getInstance();
    bool offlineMode = prefs.getBool('offline_mode') ?? false;
    var profileData =
        await DbHelper.getProfileByUserId(Objectbox.store_, userId: userId);
    int profileId = profileData!.id!;
    if (validate()) {
      if (!offlineMode) {
        debugPrint('create survey online');
        try {
          Survey data = Survey(
            kodeUnikResponden: kodeUnikResponden.toString(),
            namaSurveyId: namaSurveyId.toString(),
            profileId: profileId.toString(),
            isSelesai: "0",
          );
          List<Survey>? response =
              await DioClient().createSurvey(token: token, data: data);
          isLoading.value = false;
          Get.toNamed(RouteName.isiSurvey, arguments: response![0]);
          successScackbar("Survey berhasil disimpan");
        } on DioError catch (e) {
          handleError(error: e);
        }
      } else {
        debugPrint('create form offline');
        int uniqueCode = await generateUniqueCode();
        SurveyModel data = SurveyModel(
          kodeUnik: uniqueCode,
          kodeUnikRespondenId: kodeUnikResponden,
          namaSurveyId: namaSurveyId,
          profileId: profileId,
          isSelesai: 0,
          kategoriSelanjutnya: 11,
          lastModified: DateTime.now().toString(),
        );
        await DbHelper.putSurvey(Objectbox.store_, data);
        isLoading.value = false;
        Get.toNamed(RouteName.isiSurvey, arguments: data);
        successScackbar("Survey berhasil disimpan");
      }
    }
  }

  Future deleteSurvey({required int id}) async {
    final prefs = await SharedPreferences.getInstance();
    bool offlineMode = prefs.getBool('offline_mode') ?? false;
    isLoading.value = true;
    if (!offlineMode) {
      debugPrint('delete online survey');
      try {
        await DioClient().deleteSurvey(
          token: token,
          id: id,
        );
        surveys.removeWhere((element) => element.id == id);
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      debugPrint('delete local survey' + id.toString());
      // await DbHelper.deleteSurvey(Objectbox.store_, id: id);
    }
    isLoading.value = false;
  }

  void _setToEmpty() {
    if (statusSurveyEditingController.text == "") {
      statusSurvey = statusSurveyEditingController.text;
    }
    if (typeSurveyEditingController.text == "") {
      typeSurvey = "";
    }
  }

  Future<int> generateUniqueCode() async {
    debugPrint('get data list survey local');
    List<SurveyModel>? localSurvey = await DbHelper.getSurvey(Objectbox.store_);
    late int uniqueCode;
    late List kodeUnik;
    do {
      debugPrint('generate random number');
      uniqueCode = Random.secure().nextInt(89999999) + 10000000;
      kodeUnik =
          localSurvey.where((survey) => survey.kodeUnik == uniqueCode).toList();
    } while (kodeUnik.isNotEmpty);
    return uniqueCode;
  }

  @override
  void onInit() async {
    await getSurvey();
    statusSurveyEditingController.addListener(_setToEmpty);
    typeSurveyEditingController.addListener(_setToEmpty);
    super.onInit();
  }

  @override
  void dispose() {
    statusSurveyEditingController.dispose();
    typeSurveyEditingController.dispose();
    respondenTEC.dispose();
    namaSurveyTEC.dispose();
    super.dispose();
  }
}
