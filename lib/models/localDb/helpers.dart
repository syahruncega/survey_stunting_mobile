import 'dart:convert';
import 'dart:developer';

import 'package:get/state_manager.dart';
import 'package:survey_stunting/models/detail_survey.dart';
import 'package:survey_stunting/models/localDb/institusi_model.dart';
import 'package:survey_stunting/models/localDb/objectBox_generated_files/objectbox.g.dart';
import 'package:survey_stunting/models/localDb/profile_model.dart';
import 'package:survey_stunting/models/localDb/responden_model.dart';
import 'package:survey_stunting/models/total_survey.dart';
import '../soal.dart';
import 'jawaban_soal_model.dart';
import 'jawaban_survey_model.dart';
import 'kabupaten_model.dart';
import 'kategori_soal_model.dart';
import 'kecamatan_model.dart';
import 'kelurahan_model.dart';
import 'nama_survey_mode.dart';
import 'provinsi_model.dart';
import 'soal_model.dart';
import 'survey_model.dart';
import 'user_model.dart';

class Objectbox {
  late final Store store;
  late final Admin admin;
  static late Store store_;
  static var init = false.obs;

  Objectbox._create(this.store) {
    store_ = store;
    if (Admin.isAvailable()) {
      admin = Admin(store_);
    }
    init.value = true;
    log('store is opened');
  }

  static Future<Objectbox> create() async {
    if (await isStoreOpen()) {
      store_.close();
      log('store closed');
    }
    final store = await openStore();
    log('opening store...');
    return Objectbox._create(store);
  }

  static Future<bool> isStoreOpen() async {
    log('is store open');
    if (init.value) {
      log('store is open');
      return true;
    }
    log('store is not open');
    return false;
  }
}

class DbHelper {
  /// delete all data in database
  static Future deleteAll(Store store) async {
    // await deleteAllUser(store);
    // await deleteAllProfile(store);
    // await deleteAllProvinsi(store);
    // await deleteAllKabupaten(store);
    // await deleteAllKecamatan(store);
    // await deleteAllKelurahan(store);
    // await deleteAllNamaSurvey(store);
    // await deleteAllKategoriSoal(store);
    // await deleteAllSoal(store);
    // await deleteAllJawabanSoal(store);
    // await deleteAllResponden(store);
    // await deleteAllSurvey(store);
    // await deleteAllJawabanSurvey(store);
  }

  //? Institusi
  /// Get all institusi
  static Future<List<InstitusiModel>> getInstitusi(Store store) async {
    return store.box<InstitusiModel>().getAll();
  }

  /// Params:
  /// - store (ObjextBoxStore)
  /// - InstitusiData (InstitusiModel)
  /// - id (int) - id of institusi optional only if you want to update institusi
  static Future<List<int>> putInstitusi(
      Store store, List<InstitusiModel> institusi) async {
    return store.box<InstitusiModel>().putMany(institusi);
  }

  /// param :
  /// id (int) - id of institusi
  /// return :
  /// true if institusi is deleted
  static Future<bool> deleteInstitusi(Store store, int id) async {
    return store.box<InstitusiModel>().remove(id);
  }

  static Future<int> deleteAllInstitusi(Store store) async {
    return store.box<InstitusiModel>().removeAll();
  }

  //? Profile
  /// Params:
  /// - store (ObjextBoxStore)
  /// - ProfileData (ProfileModel)
  /// - id (int) - id of profile optional only if you want to update profile
  static Future<int> putProfile(Store store, ProfileModel profile) async {
    profile.user.targetId = profile.userId;
    profile.institusi.targetId = int.parse(profile.institusiId!);
    return store.box<ProfileModel>().put(profile);
  }

  /// Get all profile data
  static Future<List<ProfileModel>> getProfile(Store store) async {
    return store.box<ProfileModel>().getAll();
  }

  /// Get profile by id
  static Future<ProfileModel?> getProfileById(Store store,
      {required int id}) async {
    return store.box<ProfileModel>().get(id);
  }

  /// Get profile by userId
  static Future<ProfileModel?> getProfileByUserId(Store store,
      {required int userId}) async {
    var profiles = await getProfile(store);
    return profiles.lastWhere((profile) => profile.user.targetId == userId);
  }

  /// param :
  /// id (int) - id of profile
  /// return :
  /// true if profile is deleted
  static Future<bool> deleteProfile(Store store, int id) async {
    return store.box<ProfileModel>().remove(id);
  }

  static Future<int> deleteAllProfile(Store store) async {
    return store.box<ProfileModel>().removeAll();
  }

  //? User
  /// Params:
  /// - store (ObjextBoxStore)
  /// - UserData (UserModel)
  /// - id (int) - id of the user optional only if you want to update the user
  static Future<int> putUser(Store store, UserModel user) async {
    // user.profile.targetId = user.profileId;
    return store.box<UserModel>().put(user);
  }

  /// Get all user
  static Future<List<UserModel>> getUser(Store store) async {
    return store.box<UserModel>().getAll();
  }

  /// Get user by id
  static Future<UserModel?> getUserById(Store store, {required int id}) async {
    return store.box<UserModel>().get(id);
  }

  /// param :
  /// id (int) - id of the user
  /// return :
  /// true if user is deleted
  static Future<bool> deleteUser(Store store, {required int id}) async {
    return store.box<UserModel>().remove(id);
  }

  static Future<int> deleteAllUser(Store store) async {
    return store.box<UserModel>().removeAll();
  }

  //? Soal
  /// Params:
  /// - store (ObjextBoxStore)
  /// - SoalData (SoalModel)
  /// - id (int) - id of the soal optional only if you want to update the soal
  static Future<List<int>> putSoal(Store store, List<SoalModel> soal) async {
    for (var soal_ in soal) {
      soal_.kategoriSoal.targetId = soal_.kategoriSoalId;
    }
    return store.box<SoalModel>().putMany(soal);
  }

  /// Get all soal
  /// return :
  /// List<SoalModel>
  static Future<List<SoalModel>> getSoal(Store store) async {
    return store.box<SoalModel>().getAll();
  }

  /// Get soal by id
  static Future<SoalModel?> getSoalById(Store store, {required int id}) async {
    return store.box<SoalModel>().get(id);
  }

  /// Get soal by kategoriSoalId.
  ///
  /// return :
  /// List<SoalModel>
  static Future<List<SoalModel>> getSoalByKategoriSoalId(
    Store store, {
    required int kategoriSoalId,
  }) async {
    final soals = await getSoal(store);
    return soals
        .where((soal) => soal.kategoriSoal.targetId == kategoriSoalId)
        .toList();
  }

  /// delete soal
  /// param :
  ///
  /// return :
  /// true if soal is deleted
  static Future<bool> deleteSoal(Store store, {required int id}) async {
    return store.box<SoalModel>().remove(id);
  }

  /// delete all soal
  static Future<int> deleteAllSoal(Store store) async {
    return store.box<SoalModel>().removeAll();
  }

  //? Kategori Soal
  /// Params:
  /// - store (ObjextBoxStore)
  /// - KategoriSoalData (KategoriSoalModel)
  /// - id (int) - id of the kategori soal optional only if you want to update the kategori soal
  static Future<List<int>> putKategoriSoal(
      Store store, List<KategoriSoalModel> kategoriSoal) async {
    for (var kategori in kategoriSoal) {
      kategori.namaSurvey.targetId = kategori.namaSurveyId;
    }
    return store.box<KategoriSoalModel>().putMany(kategoriSoal);
  }

  /// get all kategori soal
  static Future<List<KategoriSoalModel>> getKategoriSoal(Store store) async {
    return store.box<KategoriSoalModel>().getAll();
  }

  /// get kategori soal by id
  static Future<KategoriSoalModel?> getKategoriSoalById(Store store,
      {required int id}) async {
    return store.box<KategoriSoalModel>().get(id);
  }

  /// Get kategoriSoal by namaSurveyId
  static Future<List<KategoriSoalModel>> getKategoriSoalByNamaSurveyId(
    Store store, {
    required int namaSurveyId,
  }) async {
    final kategoriSoals = await getKategoriSoal(store);
    return kategoriSoals
        .where(
            (kategoriSoal) => kategoriSoal.namaSurvey.targetId == namaSurveyId)
        .toList();
  }

  /// delete kategori soal
  static Future<bool> deleteKategoriSoal(Store store, {required int id}) async {
    return store.box<KategoriSoalModel>().remove(id);
  }

  /// delete all kategori soal
  static Future<int> deleteAllKategoriSoal(Store store) async {
    return store.box<KategoriSoalModel>().removeAll();
  }

  //? Nama Survey
  /// Params:
  /// - store (ObjextBoxStore)
  /// - NamaSurveyData (NamaSurveyModel)
  /// - id (int) - id of the nama survey optional only if you want to update the nama survey
  static Future<List<int>> putNamaSurvey(
      Store store, List<NamaSurveyModel> namaSurvey) async {
    return store.box<NamaSurveyModel>().putMany(namaSurvey);
  }

  /// get all nama survey
  /// return :
  /// List<NamaSurveyModel>
  static Future<List<NamaSurveyModel>> getNamaSurvey(Store store) async {
    return store.box<NamaSurveyModel>().getAll();
  }

  /// get nama survey by id
  static Future<NamaSurveyModel?> getNamaSurveyById(Store store,
      {required int id}) async {
    return store.box<NamaSurveyModel>().get(id);
  }

  /// delete nama survey
  static Future<bool> deleteNamaSurvey(Store store, {required int id}) async {
    return store.box<NamaSurveyModel>().remove(id);
  }

  /// delete all namaSurvey
  static Future<int> deleteAllNamaSurvey(Store store) async {
    return store.box<NamaSurveyModel>().removeAll();
  }

  // create function jawabanSoal same as kategori soal
  //? Jawaban Soal
  /// Params:
  /// - store (ObjextBoxStore)
  /// - JawabanSoalData (JawabanSoalModel)
  /// - id (int) - id of the jawaban soal optional only if you want to update the jawaban soal
  static Future<List<int>> putJawabanSoal(
      Store store, List<JawabanSoalModel> jawabanSoal) async {
    for (var jawaban in jawabanSoal) {
      jawaban.soal.targetId = jawaban.soalId;
    }
    return store.box<JawabanSoalModel>().putMany(jawabanSoal);
  }

  /// get all jawaban soal
  static Future<List<JawabanSoalModel>> getJawabanSoal(Store store) async {
    return store.box<JawabanSoalModel>().getAll();
  }

  /// get jawaban soal by id
  static Future<JawabanSoalModel?> getJawabanSoalById(Store store,
      {required int id}) async {
    return store.box<JawabanSoalModel>().get(id);
  }

  /// Get jawabanSoal by soalId
  static Future<List<JawabanSoalModel>> getJawabanSoalBySoalId(
    Store store, {
    required int soalId,
  }) async {
    final jawabanSoals = await getJawabanSoal(store);
    return jawabanSoals
        .where((jawabanSoal) => jawabanSoal.soal.targetId == soalId)
        .toList();
  }

  /// delete all jawabanSoal
  static Future<int> deleteAllJawabanSoal(Store store) async {
    return store.box<JawabanSoalModel>().removeAll();
  }

  // create function jawabanSurvey same as jawaban soal
  //? Jawaban Survey
  /// Params:
  /// - store (ObjextBoxStore)
  /// - JawabanSurveyData (JawabanSurveyModel)
  /// - id (int) - id of the jawaban survey optional only if you want to update the jawaban survey
  static Future<List<int>> putJawabanSurvey(
      Store store, List<JawabanSurveyModel> jawabanSurvey) async {
    for (var jawaban in jawabanSurvey) {
      jawaban.soal.targetId = jawaban.soalId;
      jawaban.kodeUnikSurvey.targetId = jawaban.kodeUnikSurveyId;
      jawaban.kategoriSoal.targetId = jawaban.kategoriSoalId;
    }
    return store.box<JawabanSurveyModel>().putMany(jawabanSurvey);
  }

  /// get all jawaban survey
  static Future<List<JawabanSurveyModel>> getJawabanSurvey(Store store) async {
    return store.box<JawabanSurveyModel>().getAll();
  }

  /// get jawaban survey by id
  static Future<JawabanSurveyModel?> getJawabanSurveyById(Store store,
      {required int id}) async {
    return store.box<JawabanSurveyModel>().get(id);
  }

  /// Get jawabanSurvey by soalId
  static Future<List<JawabanSurveyModel>> getJawabanSurveyBySoalId(
    Store store, {
    required int soalId,
  }) async {
    final jawabanSurveys = await getJawabanSurvey(store);
    return jawabanSurveys
        .where((jawabanSurvey) => jawabanSurvey.soal.targetId == soalId)
        .toList();
  }

  /// Get jawabanSurvey by kodeUnikSurveyId
  static Future<List<JawabanSurveyModel>> getJawabanSurveyByKodeUnikSurveyId(
    Store store, {
    required int kodeUnikSurveyId,
    int? kategoriSoalId,
  }) async {
    final jawabanSurveys = await getJawabanSurvey(store);
    if (kategoriSoalId == null) {
      return jawabanSurveys
          .where((jawabanSurvey) =>
              jawabanSurvey.kodeUnikSurvey.targetId == kodeUnikSurveyId)
          .toList();
    } else {
      return jawabanSurveys
          .where((jawabanSurvey) =>
              jawabanSurvey.kodeUnikSurvey.targetId == kodeUnikSurveyId &&
              jawabanSurvey.kategoriSoal.targetId == kategoriSoalId)
          .toList();
    }
  }

  /// Get jawabanSurvey by kategoriSoalId
  static Future<List<JawabanSurveyModel>> getJawabanSurveyByKategoriSoalId(
      Store store,
      {required int kategoriSoalId,
      int? kodeUnikSurvey}) async {
    final jawabanSurveys = await getJawabanSurvey(store);
    if (kodeUnikSurvey != null) {
      return jawabanSurveys
          .where((jawabanSurvey) =>
              jawabanSurvey.kategoriSoal.targetId == kategoriSoalId &&
              jawabanSurvey.kodeUnikSurvey.targetId == kodeUnikSurvey)
          .toList();
    } else {
      return jawabanSurveys
          .where((jawabanSurvey) =>
              jawabanSurvey.kategoriSoal.targetId == kategoriSoalId)
          .toList();
    }
  }

  /// Get jawabanSurvey by jawabanSoalId
  static Future<List<JawabanSurveyModel>> getJawabanSurveyByJawabanSoalId(
    Store store, {
    required int jawabanSoalId,
  }) async {
    final jawabanSurveys = await getJawabanSurvey(store);
    return jawabanSurveys
        .where((jawabanSurvey) => jawabanSurvey.jawabanSoalId == jawabanSoalId)
        .toList();
  }

  /// delete jawaban survey
  static Future<bool> deleteJawabanSurvey(Store store,
      {required int id}) async {
    return store.box<JawabanSurveyModel>().remove(id);
  }

  /// delete jawaban survey
  static Future<int> deleteJawabanSurveyByKodeUnikSurvey(Store store,
      {required int kodeUnikSurvey}) async {
    List<int> ids = [];
    final jawabanSurvey = await getJawabanSurveyByKodeUnikSurveyId(store,
        kodeUnikSurveyId: kodeUnikSurvey);
    if (jawabanSurvey.isNotEmpty) {
      for (var item in jawabanSurvey) {
        ids.add(item.id!);
      }
    }
    return store.box<JawabanSurveyModel>().removeMany(ids);
  }

  /// delete all jawaban survey
  static Future<int> deleteAllJawabanSurvey(Store store) async {
    return store.box<JawabanSurveyModel>().removeAll();
  }

  // create function Survey same as jawaban survey
  //? Survey
  /// Params:
  /// - store (ObjextBoxStore)
  /// - SurveyData (SurveyModel)
  /// - id (int) - id of the survey optional only if you want to update the survey
  static Future<List<int>> putSurvey(
      Store store, List<SurveyModel> survey) async {
    for (var surv in survey) {
      surv.id = surv.id;
      surv.namaSurvey.targetId = surv.namaSurveyId;
      surv.profile.targetId = surv.profileId;
      surv.kodeUnikResponden.targetId = surv.kodeUnikRespondenId;
    }
    return store.box<SurveyModel>().putMany(survey);
  }

  /// get all survey
  static Future<List<SurveyModel>> getSurvey(Store store) async {
    return store.box<SurveyModel>().getAll();
  }

  /// get survey by id
  static Future<SurveyModel?> getSurveyById(Store store,
      {required int id}) async {
    return store.box<SurveyModel>().get(id);
  }

  /// Get survey by namaSurveyId
  static Future<List<SurveyModel>> getSurveyByNamaSurveyId(
    Store store, {
    required int namaSurveyId,
  }) async {
    final surveys = await getSurvey(store);
    return surveys
        .where((survey) => survey.namaSurvey.targetId == namaSurveyId)
        .toList();
  }

  /// Get survey by profileId
  static Future<List<SurveyModel>> getSurveyByProfileId(
    Store store, {
    required int profileId,
    int? isSelesai,
    String? namaSurveyId,
    String? keyword,
  }) async {
    final surveys = await getSurvey(store);

    if (namaSurveyId != null && namaSurveyId != "") {
      if (isSelesai != null) {
        if (keyword != null && keyword != "") {
          List<SurveyModel> filteredSurveys = surveys
              .where((survey) =>
                  survey.profile.targetId == profileId &&
                  survey.isSelesai == isSelesai &&
                  survey.namaSurvey.targetId == int.parse(namaSurveyId))
              .toList();

          filteredSurveys.retainWhere((survey) =>
              survey.namaSurvey.target!.nama
                  .toString()
                  .toLowerCase()
                  .contains(keyword.toString().toLowerCase()) ||
              survey.profile.target!.namaLengkap
                  .toString()
                  .toLowerCase()
                  .contains(keyword.toString().toLowerCase()) ||
              survey.kodeUnikResponden.target!.kartuKeluarga
                  .toString()
                  .toLowerCase()
                  .contains(keyword.toString().toLowerCase()));
          return filteredSurveys;
        } else {
          return surveys
              .where((survey) =>
                  survey.profile.targetId == profileId &&
                  survey.namaSurvey.targetId == int.parse(namaSurveyId) &&
                  survey.isSelesai == isSelesai)
              .toList();
        }
      } else {
        return surveys
            .where((survey) =>
                survey.profile.targetId == profileId &&
                survey.namaSurvey.targetId == int.parse(namaSurveyId))
            .toList();
      }
    } else if (isSelesai != null) {
      if (keyword != null && keyword != "") {
        List<SurveyModel> filteredSurveys = surveys
            .where((survey) =>
                survey.profile.targetId == profileId &&
                survey.isSelesai == isSelesai)
            .toList();

        filteredSurveys.retainWhere((survey) =>
            survey.namaSurvey.target!.nama
                .toString()
                .toLowerCase()
                .contains(keyword.toString().toLowerCase()) ||
            survey.profile.target!.namaLengkap
                .toString()
                .toLowerCase()
                .contains(keyword.toString().toLowerCase()) ||
            survey.kodeUnikResponden.target!.kartuKeluarga
                .toString()
                .toLowerCase()
                .contains(keyword.toString().toLowerCase()));
        return filteredSurveys;
      } else {
        return surveys
            .where((survey) =>
                survey.profile.targetId == profileId &&
                survey.isSelesai == isSelesai)
            .toList();
      }
    } else if (keyword != null && keyword != "") {
      List<SurveyModel> filteredSurveys = surveys
          .where((survey) => survey.profile.targetId == profileId)
          .toList();

      filteredSurveys.retainWhere((survey) =>
          survey.namaSurvey.target!.nama
              .toString()
              .toLowerCase()
              .contains(keyword.toString().toLowerCase()) ||
          survey.profile.target!.namaLengkap
              .toString()
              .toLowerCase()
              .contains(keyword.toString().toLowerCase()) ||
          survey.kodeUnikResponden.target!.kartuKeluarga
              .toString()
              .toLowerCase()
              .contains(keyword.toString().toLowerCase()));
      return filteredSurveys;
    } else {
      return surveys
          .where((survey) => survey.profile.targetId == profileId)
          .toList();
    }
  }

  /// Get survey by kodeUnikRespondenId
  static Future<List<SurveyModel>> getSurveyByKodeUnikRespondenId(
    Store store, {
    required int kodeUnikRespondenId,
  }) async {
    final surveys = await getSurvey(store);
    return surveys
        .where((survey) =>
            survey.kodeUnikResponden.targetId == kodeUnikRespondenId)
        .toList();
  }

  /// Get survey with isSelesai = 0
  /// - isSelesai = 0 means that the survey is not finished yet
  /// - isSelesai = 1 means that the survey is finished
  static Future<List<SurveyModel>> getSurveyByIsSelesai(
    Store store, {
    required int isSelesai,
  }) async {
    final surveys = await getSurvey(store);
    return surveys.where((survey) => survey.isSelesai == isSelesai).toList();
  }

  /// Get Survey by kodeUnik
  /// - kodeUnik is the unique code of the survey
  /// - kodeUnik is generated by the system
  static Future<SurveyModel?> getSurveyByKodeUnik(
    Store store, {
    required int kodeUnik,
  }) async {
    try {
      final surveys = await getSurvey(store);
      return surveys.firstWhere((survey) => survey.kodeUnik == kodeUnik);
    } catch (e) {
      return null;
    }
    // final surveys = await getSurvey(store);
    // return surveys.firstWhere((survey) => survey.kodeUnik == kodeUnik);
  }

  // Get detail survey
  /// Params:
  /// - store (ObjextBoxStore)
  /// - kodeUnik (int)
  static Future<List<SurveyModel>> getDetailSurvey(Store store,
      {required int profileId,
      int? isSelesai,
      String? namaSurveyId,
      String? keyword}) async {
    List<SurveyModel> allSurveys = [];
    List<SurveyModel> surveys = await getSurveyByProfileId(store,
        profileId: profileId,
        isSelesai: isSelesai,
        namaSurveyId: namaSurveyId,
        keyword: keyword);
    for (var survey in surveys) {
      RespondenModel? responden = await getRespondenByKodeUnik(store,
          kodeUnik: survey.kodeUnikResponden.targetId);
      NamaSurveyModel? namaSurvey =
          await getNamaSurveyById(store, id: survey.namaSurvey.targetId);
      ProfileModel? profile =
          await getProfileById(store, id: survey.profile.targetId);

      allSurveys.add(SurveyModel(
        id: survey.id!,
        kodeUnik: survey.kodeUnik,
        kategoriSelanjutnya: survey.kategoriSelanjutnya,
        isSelesai: survey.isSelesai,
        kodeUnikRespondenId: survey.kodeUnikResponden.targetId,
        namaSurveyId: survey.namaSurvey.targetId,
        profileId: survey.profile.targetId,
        lastModified: survey.lastModified,
        respondenModel: responden,
        namaSurveyModel: namaSurvey,
        profileModel: profile,
      ));
    }
    return allSurveys;
  }

  static Future<List<DetailSurvey>> getDetailSurveyByKodeUnik(Store store,
      {required int kodeUnik, required int namaSurveyId}) async {
    List<DetailSurvey> detailSurvey = [];

    //Get Kategori soal
    List<KategoriSoalModel> kategoriSoal =
        await getKategoriSoalByNamaSurveyId(store, namaSurveyId: namaSurveyId);
    //Get Soal by kategori soal id
    for (var kategori in kategoriSoal) {
      List<SoalModel> _soal =
          await getSoalByKategoriSoalId(store, kategoriSoalId: kategori.id!);

      //Get Jawaban Survey
      List<JawabanSurveyModel> _jawabanSurvey =
          await getJawabanSurveyByKategoriSoalId(
        store,
        kategoriSoalId: kategori.id!,
        kodeUnikSurvey: kodeUnik,
      );

      List<JawabanSurveyy> jawabanSurvey = [];
      dynamic jawabanSoal;

      for (var jawaban in _jawabanSurvey) {
        if (jawaban.jawabanSoalId != null) {
          //Get Jawaban Soal
          JawabanSoalModel? _jawabanSoal =
              await getJawabanSoalById(store, id: jawaban.jawabanSoalId!);
          jawabanSoal = _jawabanSoal?.toJson();
        }
        jawabanSurvey.add(
          JawabanSurveyy(
            id: jawaban.id,
            soalId: jawaban.soal.targetId.toString(),
            kodeUnikSurvey: jawaban.kodeUnikSurvey.targetId.toString(),
            kategoriSoalId: jawaban.kategoriSoal.targetId.toString(),
            jawabanSoalId: jawaban.jawabanSoalId.toString(),
            jawabanLainnya: jawaban.jawabanLainnya,
            jawabanSoal: jawabanSoal,
          ),
        );
      }

      detailSurvey.add(
        DetailSurvey(
            id: kategori.id!,
            urutan: kategori.urutan.toString(),
            nama: kategori.nama,
            namaSurveyId: kategori.namaSurvey.targetId.toString(),
            soal: _soal.map((e) => Soal.fromJson(e.toJson())).toList(),
            jawabanSurvey: jawabanSurvey),
      );
    }
    return detailSurvey;
  }

  static Future<TotalSurvey> getTotalSurvey(
    Store store, {
    required int profileId,
  }) async {
    final surveys = await getSurveyByProfileId(
      store,
      profileId: profileId,
    );
    final totalSurvey = TotalSurvey(
      respondenPost:
          surveys.where((survey) => survey.namaSurvey.targetId == 1).length,
      respondenPre:
          surveys.where((survey) => survey.namaSurvey.targetId == 2).length,
      totalResponden: surveys.toSet().toList().length,
    );
    return totalSurvey;
  }

  /// delete survey
  static Future<bool> deleteSurvey(Store store, {required int kodeUnik}) async {
    final survey = await getSurveyByKodeUnik(store, kodeUnik: kodeUnik);
    if (survey != null) {
      int id = survey.id!;
      final jawabanSurvey = await getJawabanSurveyByKodeUnikSurveyId(store,
          kodeUnikSurveyId: kodeUnik);
      if (jawabanSurvey.isNotEmpty) {
        for (var jawaban in jawabanSurvey) {
          await deleteJawabanSurvey(store, id: jawaban.id!);
        }
      }
      return store.box<SurveyModel>().remove(id);
    } else {
      return false;
    }
  }

  /// delete all survey
  static Future<int> deleteAllSurvey(Store store) async {
    return store.box<SurveyModel>().removeAll();
  }

  //? Responden
  /// Params:
  /// - store (ObjextBoxStore)
  /// - RespondenData (RespondenModel)
  /// - id (int) - id of the survey optional only if you want to update the survey
  static Future<List<int>> putResponden(
      Store store, List<RespondenModel> responden) async {
    for (var res in responden) {
      res.id = res.id;
      res.provinsi.targetId = res.provinsiId;
      res.kabupaten.targetId = res.kabupatenId;
      res.kecamatan.targetId = res.kecamatanId;
      res.kelurahan.targetId = res.kelurahanId;
    }
    return store.box<RespondenModel>().putMany(responden);
  }

  /// Get responden
  static Future<List<RespondenModel>> getResponden(Store store) async {
    return store.box<RespondenModel>().getAll();
  }

  /// Get responden by id
  static Future<RespondenModel?> getRespondenById(
    Store store, {
    required int id,
  }) async {
    return store.box<RespondenModel>().get(id);
  }

  /// Get responden by kodeUnik
  static Future<RespondenModel> getRespondenByKodeUnik(
    Store store, {
    required int kodeUnik,
  }) async {
    final respondens = await getResponden(store);
    return respondens.firstWhere((responden) => responden.kodeUnik == kodeUnik);
  }

  /// Delete responden
  static Future<bool> deleteResponden(Store store, {required int id}) async {
    return store.box<RespondenModel>().remove(id);
  }

  /// delete all responden
  static Future<int> deleteAllResponden(Store store) async {
    return store.box<RespondenModel>().removeAll();
  }

  //? Provinsi
  /// Get all provinsi
  static Future<List<ProvinsiModel>> getProvinsi(Store store) async {
    return store.box<ProvinsiModel>().getAll();
  }

  /// put provinsi
  static Future<List<int>> putProvinsi(
      Store store, List<ProvinsiModel> provinsi) async {
    return store.box<ProvinsiModel>().putMany(provinsi);
  }

  /// Get provinsi by id
  static Future<ProvinsiModel?> getProvinsiById(
    Store store, {
    required int id,
  }) async {
    return store.box<ProvinsiModel>().get(id);
  }

  /// Delete all provinsi
  static Future<int> deleteAllProvinsi(Store store) async {
    return store.box<RespondenModel>().removeAll();
  }

  //? Kabupaten
  /// Get all kabupaten
  static Future<List<KabupatenModel>> getKabupaten(Store store) async {
    return store.box<KabupatenModel>().getAll();
  }

  /// put kabupaten
  static Future<List<int>> putKabupaten(
      Store store, List<KabupatenModel> kabupaten) async {
    for (var kab in kabupaten) {
      kab.provinsi.targetId = kab.provinsiId;
    }
    return store.box<KabupatenModel>().putMany(kabupaten);
  }

  /// delete all kabupaten
  static Future<int> deleteAllKabupaten(Store store) async {
    return store.box<KabupatenModel>().removeAll();
  }

  /// Get kabupaten by id
  static Future<KabupatenModel?> getKabupatenById(
    Store store, {
    required int id,
  }) async {
    return store.box<KabupatenModel>().get(id);
  }

  /// Get kabupaten by provinsiId
  static Future<List<KabupatenModel>> getKabupatenByProvinsiId(
    Store store, {
    required int provinsiId,
  }) async {
    final kabupatens = await getKabupaten(store);
    return kabupatens
        .where((kabupaten) => kabupaten.provinsi.targetId == provinsiId)
        .toList();
  }

  //? Kecamatan
  /// Get all kecamatan
  static Future<List<KecamatanModel>> getKecamatan(Store store) async {
    return store.box<KecamatanModel>().getAll();
  }

  /// Get kecamatan by id
  static Future<KecamatanModel?> getKecamatanById(
    Store store, {
    required int id,
  }) async {
    return store.box<KecamatanModel>().get(id);
  }

  /// Get kecamatan by kabupatenId
  /// - kabupatenId (int)
  static Future<List<KecamatanModel>> getKecamatanByKabupatenId(
    Store store, {
    required int kabupatenId,
  }) async {
    final kecamatans = await getKecamatan(store);
    return kecamatans
        .where((kecamatan) => kecamatan.kabupaten.targetId == kabupatenId)
        .toList();
  }

  /// put kecamatan
  static Future<List<int>> putKecamatan(
      Store store, List<KecamatanModel> kecamatan) async {
    for (var kec in kecamatan) {
      kec.kabupaten.targetId = kec.kabupatenId;
    }
    return store.box<KecamatanModel>().putMany(kecamatan);
  }

  /// delete all kecamatan
  static Future<int> deleteAllKecamatan(Store store) async {
    return store.box<KecamatanModel>().removeAll();
  }

  //? Kelurahan
  /// Get all kelurahan
  static Future<List<KelurahanModel>> getKelurahan(Store store) async {
    return store.box<KelurahanModel>().getAll();
  }

  /// Get kelurahan by id
  static Future<KelurahanModel?> getKelurahanById(
    Store store, {
    required int id,
  }) async {
    return store.box<KelurahanModel>().get(id);
  }

  /// Get kelurahan by kecamatanId
  /// - kecamatanId (int)
  static Future<List<KelurahanModel>> getKelurahanByKecamatanId(
    Store store, {
    required int kecamatanId,
  }) async {
    final kelurahans = await getKelurahan(store);
    return kelurahans
        .where((kelurahan) => kelurahan.kecamatan.targetId == kecamatanId)
        .toList();
  }

  /// put kelurahan
  static Future<List<int>> putKelurahan(
      Store store, List<KelurahanModel> kelurahan) async {
    for (var kel in kelurahan) {
      kel.kecamatan.targetId = kel.kecamatanId;
    }
    return store.box<KelurahanModel>().putMany(kelurahan);
  }

  /// delete all kelurahan
  static Future<int> deleteAllKelurahan(Store store) async {
    return store.box<KelurahanModel>().removeAll();
  }
}
