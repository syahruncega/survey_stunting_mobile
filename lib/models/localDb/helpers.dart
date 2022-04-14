import 'dart:developer';

import 'package:survey_stunting/models/localDb/objectBox_generated_files/objectbox.g.dart';
import 'package:survey_stunting/models/localDb/profile_model.dart';

import 'jawaban_soal_model.dart';
import 'jawaban_survey_model.dart';
import 'kategori_soal_model.dart';
import 'nama_survey_mode.dart';
import 'soal_model.dart';
import 'user_model.dart';

class Objectbox {
  late final Store store;
  late final Admin admin;

  Objectbox._create(this.store) {
    if (Admin.isAvailable()) {
      admin = Admin(store);
    }
  }

  static Future<Objectbox> create() async {
    final store = await openStore();
    return Objectbox._create(store);
  }
}

class DbHelper {
  //? Profile
  /// Params:
  /// - store (ObjextBoxStore)
  /// - ProfileData (ProfileModel)
  /// - id (int) - id of profile optional only if you want to update profile
  static Future<int> putProfile(Store store, ProfileModel profile) async {
    profile.user.targetId = profile.userId;
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
    return profiles.singleWhere((profile) => profile.user.targetId == userId);
  }

  /// param :
  /// id (int) - id of profile
  /// return :
  /// true if profile is deleted
  static Future<bool> deleteProfile(Store store, int id) async {
    return store.box<ProfileModel>().remove(id);
  }

  //? User
  /// Params:
  /// - store (ObjextBoxStore)
  /// - UserData (UserModel)
  /// - id (int) - id of the user optional only if you want to update the user
  static Future<int> putUser(Store store, UserModel user) async {
    user.profile.targetId = user.profileId;
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

  /// get user by profileId
  static Future<UserModel?> getUserByProfileId(Store store,
      {required int profileId}) async {
    final users = await getUser(store);
    return users.firstWhere((user) => user.profile.targetId == profileId);
  }

  /// param :
  /// id (int) - id of the user
  /// return :
  /// true if user is deleted
  static Future<bool> deleteUser(Store store, {required int id}) async {
    return store.box<UserModel>().remove(id);
  }

  //? Soal
  /// Params:
  /// - store (ObjextBoxStore)
  /// - SoalData (SoalModel)
  /// - id (int) - id of the soal optional only if you want to update the soal
  static Future<int> putSoal(Store store, SoalModel soal) async {
    soal.kategoriSoal.targetId = soal.kategoriSoalId;
    return store.box<SoalModel>().put(soal);
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

  //? Kategori Soal
  /// Params:
  /// - store (ObjextBoxStore)
  /// - KategoriSoalData (KategoriSoalModel)
  /// - id (int) - id of the kategori soal optional only if you want to update the kategori soal
  static Future<int> putKategoriSoal(
      Store store, KategoriSoalModel kategoriSoal) async {
    kategoriSoal.namaSurvey.targetId = kategoriSoal.namaSurveyId;
    return store.box<KategoriSoalModel>().put(kategoriSoal);
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

  //? Nama Survey
  /// Params:
  /// - store (ObjextBoxStore)
  /// - NamaSurveyData (NamaSurveyModel)
  /// - id (int) - id of the nama survey optional only if you want to update the nama survey
  static Future<int> putNamaSurvey(
      Store store, NamaSurveyModel namaSurvey) async {
    return store.box<NamaSurveyModel>().put(namaSurvey);
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

  // create function jawabanSoal same as kategori soal
  //? Jawaban Soal
  /// Params:
  /// - store (ObjextBoxStore)
  /// - JawabanSoalData (JawabanSoalModel)
  /// - id (int) - id of the jawaban soal optional only if you want to update the jawaban soal
  static Future<int> putJawabanSoal(
      Store store, JawabanSoalModel jawabanSoal) async {
    jawabanSoal.soal.targetId = jawabanSoal.soalId;
    jawabanSoal.jawabanSurvey.targetId = jawabanSoal.jawabanSurveyId;
    return store.box<JawabanSoalModel>().put(jawabanSoal);
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

  /// Get jawabanSoal by jawabanSurveyId
  static Future<List<JawabanSoalModel>> getJawabanSoalByJawabanSurveyId(
    Store store, {
    required int jawabanSurveyId,
  }) async {
    final jawabanSoals = await getJawabanSoal(store);
    return jawabanSoals
        .where((jawabanSoal) =>
            jawabanSoal.jawabanSurvey.targetId == jawabanSurveyId)
        .toList();
  }

  // create function jawabanSurvey same as jawaban soal
  //? Jawaban Survey
  /// Params:
  /// - store (ObjextBoxStore)
  /// - JawabanSurveyData (JawabanSurveyModel)
  /// - id (int) - id of the jawaban survey optional only if you want to update the jawaban survey
  static Future<int> putJawabanSurvey(
      Store store, JawabanSurveyModel jawabanSurvey) async {
    jawabanSurvey.soal.targetId = jawabanSurvey.soalId;
    jawabanSurvey.kodeUnikSurvey.targetId = jawabanSurvey.kodeUnikSurveyId;
    jawabanSurvey.kategoriSoal.targetId = jawabanSurvey.kategoriSoalId;
    return store.box<JawabanSurveyModel>().put(jawabanSurvey);
  }
}
