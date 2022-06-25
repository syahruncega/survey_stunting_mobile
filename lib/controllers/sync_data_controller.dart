import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/akun.dart';
import 'package:survey_stunting/models/localDb/institusi_model.dart';
import 'package:survey_stunting/models/localDb/provinsi_model.dart';
import 'package:survey_stunting/models/provinsi.dart';
import 'package:survey_stunting/models/responden.dart';

import '../components/error_scackbar.dart';
import '../components/success_scackbar.dart';
import '../models/institusi.dart';
import '../models/jawaban_soal.dart';
import '../models/jawaban_survey.dart';
import '../models/kabupaten.dart';
import '../models/kategori_soal.dart';
import '../models/kecamatan.dart';
import '../models/kelurahan.dart';
import '../models/localDb/helpers.dart';
import '../models/localDb/jawaban_soal_model.dart';
import '../models/localDb/jawaban_survey_model.dart';
import '../models/localDb/kabupaten_model.dart';
import '../models/localDb/kategori_soal_model.dart';
import '../models/localDb/kecamatan_model.dart';
import '../models/localDb/kelurahan_model.dart';
import '../models/localDb/nama_survey_mode.dart';
import '../models/localDb/profile_model.dart';
import '../models/localDb/responden_model.dart';
import '../models/localDb/soal_model.dart';
import '../models/localDb/survey_model.dart';
import '../models/localDb/user_model.dart';
import '../models/nama_survey.dart';
import '../models/soal.dart';
import '../models/survey.dart';
import '../models/user_profile.dart';
import '../services/dio_client.dart';
import '../services/handle_errors.dart';

class SyncDataController {
  Store store_;
  String token = GetStorage().read("token");
  int userId = GetStorage().read("userId");

  SyncDataController({required this.store_});

  Future syncData({required bool syncAll}) async {
    if (syncAll) {
      await syncDataInstitusi();
      await syncDataUser();
      await syncDataProfile();
      await syncDataProvinsi();
      await syncDataKabupaten();
      await syncDataKecamatan();
      await syncDataKelurahan();
      await syncNamaSurvey();
      await syncKategoriSoal();
      await syncSoal();
      await syncJawabanSoal();
      await syncResponden();
      await syncSurvey();
    } else {
      await syncDataInstitusi();
      await syncDataUser();
      await syncDataProfile();
      await syncNamaSurvey();
      await syncKategoriSoal();
      await syncSoal();
      await syncJawabanSoal();
      await syncResponden();
      await syncSurvey();
    }
  }

  Future pullDataFromServer() async {
    await pullInstitusi();
    await pullUser();
    await pullProfile();
    await pullProvinsi();
    await pullKabupaten();
    await pullKecamatan();
    await pullKelurahan();
    await pullNamaSurvey();
    await pullKategoriSoal();
    await pullSoal();
    await pullJawabanSoal();
    await pullResponden(isCreate: true);
    await pullSurvey(isCreate: true);
    await pullJawabanSurvey();
  }

  Future syncDataInstitusi() async {
    try {
      // Get institusi form server
      List<Institusi>? institusi = await DioClient().getInstitusi(token: token);
      // Get institusi local
      List<InstitusiModel> localInstitusi = await DbHelper.getInstitusi(store_);
      if (institusi != null) {
        if (localInstitusi.isNotEmpty) {
          int index = 0;
          for (var item in institusi) {
            if (item.id != localInstitusi[index].id) {
              await pullInstitusi(institusiData: [item]);
            }
            index += 1;
          }
        } else {
          await pullInstitusi(institusiData: institusi);
        }
      } else {
        debugPrint("institusi data not found on server");
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future syncDataProfile() async {
    try {
      // Get profile form server
      UserProfile userProfile = await DioClient().getProfile(token: token);
      var profileData = userProfile.data;
      if (profileData != null) {
        // Get local profile
        var localProfile =
            await DbHelper.getProfileById(store_, id: profileData.id);
        if (localProfile != null) {
          // local profile exist
          // check, if server profileData not updated yet
          if (profileData.updatedAt == null) {
            pushProfile(localProfile);
            return;
          }

          // compare local profile with server profile
          debugPrint("local profile exist. compare local with server data");
          DateTime localTime = DateTime.parse(localProfile.lastModified);
          DateTime serverTime = DateTime.parse(profileData.updatedAt);
          int time = compareTime(localTime, serverTime);
          if (time == 1) {
            // local data is greater than server data
            debugPrint("Local data is greater than server data");
            pushProfile(localProfile);
          } else if (time == -1) {
            // local data is less than server data
            debugPrint("Local data is less than server data");
            await pullProfile();
          }
        } else {
          // local profile not exist
          // pull data from server
          debugPrint("local data not exist. pull data from server");
          await pullProfile();
        }
      } else {
        debugPrint("profile data not found on server");
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future syncDataUser() async {
    try {
      // Get user form server
      Akun userAkun = await DioClient().getAkun(token: token);
      var userData = userAkun.data;
      if (userData != null) {
        // Get local user
        var localUser = await DbHelper.getUserById(store_, id: userData.id);
        if (localUser != null) {
          // local user exist
          // check, if server profileData not updated yet
          if (userData.updatedAt == null) {
            return;
          }
          // compare local user with server user
          debugPrint("local user exist. compare local with server data");
          DateTime localTime = DateTime.parse(localUser.lastModified);
          DateTime serverTime = DateTime.parse(userData.updatedAt);
          int time = compareTime(localTime, serverTime);
          if (time == -1) {
            // local data is less than server data
            debugPrint("Local data is less than server data");
            await pullUser();
          }
        } else {
          // local user not exist
          // pull data from server
          debugPrint("local data not exist. pull data from server");
          await pullUser();
        }
      } else {
        debugPrint("user data not found on server");
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future syncDataProvinsi() async {
    try {
      // Get provinsi form server
      List<Provinsi>? provinsi = await DioClient().getProvinsi(token: token);
      // Get provinsi local
      List<ProvinsiModel> localProvinsi = await DbHelper.getProvinsi(store_);
      if (provinsi != null) {
        if (localProvinsi.isNotEmpty) {
          int index = 0;
          for (var item in provinsi) {
            if (item.id != localProvinsi[index].id) {
              await pullProvinsi(provinsiData: [item]);
            }
            index += 1;
          }
        } else {
          await pullProvinsi(provinsiData: provinsi);
        }
      } else {
        debugPrint("provinsi data not found on server");
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future syncDataKabupaten() async {
    try {
      // Get kabupaten form server
      List<Kabupaten>? kabupaten =
          await DioClient().getAllKabupaten(token: token);
      // Get local kabupaten
      List<KabupatenModel> localKabupaten = await DbHelper.getKabupaten(store_);
      if (kabupaten != null) {
        if (localKabupaten.isNotEmpty) {
          int index = 0;
          for (var item in kabupaten) {
            if (item.id != localKabupaten[index].id) {
              await pullKabupaten(kabupatenData: [item]);
            }
            index += 1;
          }
        } else {
          await pullKabupaten(kabupatenData: kabupaten);
        }
      } else {
        debugPrint("kabupaten data not found on server");
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future syncDataKecamatan() async {
    try {
      // Get kecamatan form server
      List<Kecamatan>? kecamatan =
          await DioClient().getAllKecamatan(token: token);
      // Get local kecamatan
      List<KecamatanModel> localKecamatan = await DbHelper.getKecamatan(store_);
      if (kecamatan != null) {
        if (localKecamatan.isNotEmpty) {
          int index = 0;
          for (var item in kecamatan) {
            if (item.id != localKecamatan[index].id) {
              await pullKecamatan(kecamatanData: [item]);
            }
            index += 1;
          }
        } else {
          await pullKecamatan(kecamatanData: kecamatan);
        }
      } else {
        debugPrint("kecamatan data not found on server");
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future syncDataKelurahan() async {
    try {
      // Get kelurahan form server
      List<Kelurahan>? kelurahan =
          await DioClient().getAllKelurahan(token: token);
      // Get local kelurahan
      List<KelurahanModel> localKelurahan = await DbHelper.getKelurahan(store_);
      if (kelurahan != null) {
        if (localKelurahan.isNotEmpty) {
          int index = 0;
          for (var item in kelurahan) {
            if (item.id != localKelurahan[index].id) {
              await pullKelurahan(kelurahanData: [item]);
            }
            index += 1;
          }
        } else {
          await pullKelurahan(kelurahanData: kelurahan);
        }
      } else {
        debugPrint("kelurahan data not found on server");
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  // sync jawabanSoal
  Future syncJawabanSoal() async {
    try {
      // Get jawabanSoal form server
      List<JawabanSoal>? jawabanSoal =
          await DioClient().getJawabanSoal(token: token);
      if (jawabanSoal != null) {
        await pullJawabanSoal(jawabanSoalData: jawabanSoal);
      } else {
        debugPrint("jawabanSoal data not found on server");
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future syncSoal() async {
    try {
      // Get soal form server
      List<Soal>? soal = await DioClient().getAllSoal(token: token);
      // Get soal local
      List<SoalModel> localSoal = await DbHelper.getSoal(store_);
      if (soal != null) {
        if (localSoal.isNotEmpty) {
          int index = 0;
          for (var item in soal) {
            if (item.id != localSoal[index].id) {
              await pullSoal(soalData: [item]);
            }
            index += 1;
          }
        } else {
          await pullSoal(soalData: soal);
        }
      } else {
        debugPrint("soal data not found on server");
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future syncKategoriSoal() async {
    try {
      // Get kategoriSoal form server
      List<KategoriSoal>? kategoriSoal =
          await DioClient().getAllKategoriSoal(token: token);
      // Get kategori soal local
      List<KategoriSoalModel> localKategoriSoal =
          await DbHelper.getKategoriSoal(store_);
      if (kategoriSoal != null) {
        if (localKategoriSoal.isNotEmpty) {
          int index = 0;
          for (var item in kategoriSoal) {
            if (item.id != localKategoriSoal[index].id) {
              await pullKategoriSoal(kategoriSoalData: [item]);
            }
            index += 1;
          }
        } else {
          await pullKategoriSoal(kategoriSoalData: kategoriSoal);
        }
      } else {
        debugPrint("kategoriSoal data not found on server");
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future syncNamaSurvey() async {
    try {
      // Get namaSurvey form server
      List<NamaSurvey>? namaSurvey =
          await DioClient().getNamaSurvey(token: token);
      // get local data namaSurvey
      List<NamaSurveyModel>? localNamaSurvey =
          await DbHelper.getNamaSurvey(store_);
      if (namaSurvey != null) {
        if (localNamaSurvey.isNotEmpty) {
          int index = 0;
          for (var item in namaSurvey) {
            if (item.id != localNamaSurvey[index].id) {
              await pullNamaSurvey(namaSurveyData: [item]);
            }
            index += 1;
          }
        } else {
          await pullNamaSurvey(namaSurveyData: namaSurvey);
        }
      } else {
        debugPrint("namaSurvey data not found on server");
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future syncResponden() async {
    try {
      List<RespondenModel> serverToPullCreate = [];
      List<RespondenModel> serverToPullUpdate = [];
      List<Responden> localToPushCreate = [];
      List<Responden> localToPushUpdate = [];
      // List<RespondenModel> localToKeep = [];

      // Get user form server
      List<Responden>? respondens =
          await DioClient().getResponden(token: token, withTrashed: true);
      List<RespondenModel> localResponden = await DbHelper.getResponden(store_);

      if (respondens != null) {
        if (localResponden.isNotEmpty) {
          for (var responden in respondens) {
            try {
              RespondenModel? nLocalResponden = localResponden.singleWhere(
                  (element) =>
                      element.kodeUnik == int.parse(responden.kodeUnik!));
              // check, if responden on server not updated yet
              if (responden.updatedAt == null) {
                // skip this responden
                continue;
              }
              // compare local responden with server responden
              debugPrint(
                  "local responden exist. compare local with server data[loop server]");
              DateTime localTime = DateTime.parse(nLocalResponden.lastModified);
              DateTime serverTime = responden.updatedAt!;
              int time = compareTime(localTime, serverTime);
              if (time == 1) {
                // local data is greater than server data
                debugPrint(
                    "Local data is greater than server data[loop server]");
                localToPushUpdate
                    .add(Responden.fromJson(nLocalResponden.toJson()));
              } else if (time == -1) {
                // local data is less than server data
                debugPrint("Local data is less than server data[loop server]");
                serverToPullUpdate
                    .add(RespondenModel.fromJson(responden.toJson()));
              }
            } catch (e) {
              serverToPullCreate
                  .add(RespondenModel.fromJson(responden.toJson()));
              continue;
            }
          }

          for (var _localResponden in localResponden) {
            try {
              Responden? nServerResponden = respondens.singleWhere((element) =>
                  element.kodeUnik == _localResponden.kodeUnik.toString());
              // check, if responden on local not updated yet
              if (nServerResponden.updatedAt == null) {
                // check if server responden has deleted
                if (nServerResponden.deletedAt != null) {
                  if (_localResponden.deletedAt == "null" ||
                      _localResponden.deletedAt == null) {
                    log('server responden deleted, update deleted status in local');
                    serverToPullUpdate.add(
                        RespondenModel.fromJson(nServerResponden.toJson()));
                  } else {
                    continue;
                  }
                } else {
                  // skip this responden
                  continue;
                }
              }
              // compare local user with server user
              debugPrint(
                  "server responden exist. compare server with local data[loop local]");
              DateTime localTime = DateTime.parse(_localResponden.lastModified);
              DateTime serverTime = nServerResponden.updatedAt!;
              int time = compareTime(localTime, serverTime);
              if (time == 1) {
                // local data is greater than server data
                debugPrint(
                    "Local data is greater than server data[loop local]");
                localToPushUpdate
                    .add(Responden.fromJson(_localResponden.toJson()));
              } else if (time == -1) {
                // local data is less than server data
                debugPrint("Local data is less than server data[loop local]");
                serverToPullUpdate
                    .add(RespondenModel.fromJson(nServerResponden.toJson()));
              }
            } catch (e) {
              localToPushCreate
                  .add(Responden.fromJson(_localResponden.toJson()));
              continue;
            }
          }

          if (localToPushCreate.isNotEmpty) {
            pushResponden(localToPushCreate.toSet().toList(), isCreate: true);
          }

          if (localToPushUpdate.isNotEmpty) {
            pushResponden(localToPushUpdate.toSet().toList(), isCreate: false);
          }

          if (serverToPullCreate.isNotEmpty) {
            await pullResponden(
                respondenData: serverToPullCreate.toSet().toList(),
                isCreate: true);
          }

          if (serverToPullUpdate.isNotEmpty) {
            await pullResponden(
                respondenData: serverToPullUpdate.toSet().toList(),
                isCreate: false);
          }
        } else {
          // local user not exist
          // pull data from server
          debugPrint("local data responden not exist. pull data from server");
          await pullResponden(isCreate: true);
        }
      } else {
        debugPrint("responden data not found on server");
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future syncSurvey() async {
    var profileData =
        await DbHelper.getProfileByUserId(Objectbox.store_, userId: userId);
    int userProfileId = profileData!.id!;

    try {
      List<SurveyModel> serverToPullCreate = [];
      List<SurveyModel> serverToPullUpdate = [];
      List<Survey> localToPushCreate = [];
      List<Survey> localToPushUpdate = [];

      // Get user form server
      List<Survey>? surveys = await DioClient().getSurvey(token: token);
      List<SurveyModel> localSurveys =
          await DbHelper.getSurveyByProfileId(store_, profileId: userProfileId);

      if (surveys != null) {
        if (localSurveys.isNotEmpty) {
          for (var survey in surveys) {
            try {
              SurveyModel? nLocalSurvey = localSurveys.singleWhere(
                  (element) => element.kodeUnik == int.parse(survey.kodeUnik!));
              if (survey.updatedAt == null) {
                localToPushUpdate.add(Survey.fromJson(nLocalSurvey.toJson()));
                continue;
              }
              // compare local user with server user
              debugPrint("local survey exist. compare local with server data");
              DateTime localTime = DateTime.parse(nLocalSurvey.lastModified);
              DateTime serverTime = survey.updatedAt!;
              int time = compareTime(localTime, serverTime);
              if (time == 1) {
                // local data is greater than server data
                debugPrint("Local data is greater than server data");
                localToPushUpdate.add(Survey.fromJson(nLocalSurvey.toJson()));
              } else if (time == -1) {
                // local data is less than server data
                debugPrint("Local data is less than server data");
                serverToPullUpdate.add(SurveyModel.fromJson(survey.toJson()));
              }
            } catch (e) {
              serverToPullCreate.add(SurveyModel.fromJson(survey.toJson()));
              continue;
            }
          }

          for (var localSurvey in localSurveys) {
            try {
              Survey? nServerSurvey = surveys.singleWhere((element) =>
                  element.kodeUnik == localSurvey.kodeUnik.toString());
              if (nServerSurvey.updatedAt == null) {
                localToPushUpdate.add(Survey.fromJson(localSurvey.toJson()));
                continue;
              }
              // compare local user with server user
              debugPrint("server survey exist. compare server with local data");
              DateTime localTime = DateTime.parse(localSurvey.lastModified);
              DateTime serverTime = nServerSurvey.updatedAt!;
              int time = compareTime(localTime, serverTime);
              if (time == 1) {
                // local data is greater than server data
                debugPrint("Local data is greater than server data");
                localToPushUpdate.add(Survey.fromJson(localSurvey.toJson()));
              } else if (time == -1) {
                // local data is less than server data
                debugPrint("Local data is less than server data");
                serverToPullUpdate
                    .add(SurveyModel.fromJson(nServerSurvey.toJson()));
              }
            } catch (e) {
              localToPushCreate.add(Survey.fromJson(localSurvey.toJson()));
              continue;
            }
          }

          if (localToPushCreate.isNotEmpty) {
            pushSurvey(localToPushCreate.toSet().toList(), isCreate: true);
          }

          if (localToPushUpdate.isNotEmpty) {
            pushSurvey(localToPushUpdate.toSet().toList(), isCreate: false);
          }

          if (serverToPullCreate.isNotEmpty) {
            pullSurvey(
                surveyData: serverToPullCreate.toSet().toList(),
                isCreate: true);
          }

          if (serverToPullUpdate.isNotEmpty) {
            pullSurvey(
                surveyData: serverToPullUpdate.toSet().toList(),
                isCreate: false);
          }
        } else {
          // local user not exist
          // pull data from server
          debugPrint("local data not exist. pull data from server");
          pullSurvey(isCreate: true);
        }
      } else {
        debugPrint("survey data not found on server");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode != 404) {
        handleError(error: e);
      }
    }
  }

  Future pullProfile() async {
    try {
      // Get profile form server
      UserProfile userProfile = await DioClient().getProfile(token: token);
      var profileData = userProfile.data;
      if (profileData != null) {
        // pull data from server
        ProfileModel profile = ProfileModel(
          id: profileData.id,
          namaLengkap: profileData.namaLengkap,
          jenisKelamin: profileData.jenisKelamin,
          tempatLahir: profileData.tempatLahir,
          tanggalLahir: profileData.tanggalLahir,
          alamat: profileData.alamat,
          provinsiId: profileData.provinsi,
          kabupatenId: profileData.kabupatenKota,
          kecamatanId: profileData.kecamatan,
          kelurahanId: profileData.desaKelurahan,
          nomorHp: profileData.nomorHp,
          email: profileData.email,
          userId: int.parse(profileData.userId),
          institusiId: profileData.institusiId,
          lastModified: DateTime.now().toString(),
        );
        await DbHelper.putProfile(store_, profile);
        debugPrint("profile data has been pulled from server to local");
      } else {
        debugPrint("profile data not found on server");
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  void pushProfile(ProfileModel localProfile) async {
    bool response = await DioClient().updateProfile(
      token: token,
      nama: localProfile.namaLengkap,
      jenisKelamin: localProfile.jenisKelamin,
      tempatLahir: localProfile.tempatLahir,
      tglLahir: localProfile.tanggalLahir,
      alamat: localProfile.alamat,
      provinsi: localProfile.provinsiId,
      kabupaten: localProfile.kabupatenId,
      kecamatan: localProfile.kecamatanId,
      kelurahan: localProfile.kelurahanId,
      nomorHp: localProfile.nomorHp,
      email: localProfile.email,
      institusiId: localProfile.institusi.targetId.toString(),
      updatedAt: localProfile.lastModified,
    );

    if (!response) {
      errorScackbar('Sync data profile Gagal.');
    }
  }

  void pushSurvey(List<Survey> surveyData, {required bool isCreate}) async {
    List<int> kodeUnik = [];
    for (var survey in surveyData) {
      kodeUnik.add(int.parse(survey.kodeUnik!));
      RespondenModel responden = await DbHelper.getRespondenByKodeUnik(store_,
          kodeUnik: int.parse(survey.kodeUnikResponden));
      await DioClient().createSurvey(
        token: token,
        data: survey,
        sync: true,
        kartuKeluarga: responden.kartuKeluarga,
      );
    }
    pushJawabanSurvey(kodeUnikSurvey: kodeUnik.toSet().toList());
  }

  void pushJawabanSurvey({required List<int> kodeUnikSurvey}) async {
    List<JawabanSurvey> nJawabanSurveyData = [];

    for (var kodeUnik in kodeUnikSurvey) {
      List<JawabanSurveyModel> jawabanSurveyLocal =
          await DbHelper.getJawabanSurveyByKodeUnikSurveyId(store_,
              kodeUnikSurveyId: kodeUnik);

      if (jawabanSurveyLocal.isNotEmpty) {
        for (var item in jawabanSurveyLocal) {
          nJawabanSurveyData.add(JawabanSurvey(
            jawabanLainnya: item.jawabanLainnya,
            jawabanSoalId:
                item.jawabanSoalId != null ? item.jawabanSoalId.toString() : '',
            soalId: item.soal.targetId.toString(),
            kodeUnikSurvey: item.kodeUnikSurvey.targetId.toString(),
            kategoriSoalId: item.kategoriSoal.targetId.toString(),
          ));
        }
        if (nJawabanSurveyData.isNotEmpty) {
          List<int> tempKategoriSoal = [];
          for (var jawaban in nJawabanSurveyData) {
            tempKategoriSoal.add(int.parse(jawaban.kategoriSoalId));
          }
          List<int> kategoriSoalToDelete = tempKategoriSoal.toSet().toList();
          for (var kategori in kategoriSoalToDelete) {
            await DioClient().deleteJawabanSurvey(
                token: token,
                kodeUnikSurvey: kodeUnik,
                kategoriSoalId: kategori);
          }

          await DioClient()
              .createJawabanSurvey(token: token, data: nJawabanSurveyData);
        }
      }
    }
  }

  void pushResponden(List<Responden> respondenData,
      {required bool isCreate}) async {
    if (isCreate) {
      for (var responden in respondenData) {
        var result =
            await DioClient().createResponden(token: token, data: responden);
        if (result == null) {
          continue;
        }
      }
    }
  }

  Future pullInstitusi({List<Institusi>? institusiData}) async {
    List<InstitusiModel> nInstitusi = [];
    if (institusiData == null) {
      try {
        // Get institusi form server
        List<Institusi>? institusi =
            await DioClient().getInstitusi(token: token);
        if (institusi != null) {
          for (var item in institusi) {
            InstitusiModel institusiModel = InstitusiModel(
              id: item.id,
              nama: item.nama,
              alamat: item.alamat,
              lastModified: DateTime.now().toString(),
            );
            nInstitusi.add(institusiModel);
          }
          await DbHelper.deleteAllInstitusi(store_);
          await DbHelper.putInstitusi(store_, nInstitusi);
          debugPrint("institusi data has been pulled from server to local");
        } else {
          debugPrint("institusi data not found on server");
        }
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      for (var ins in institusiData) {
        InstitusiModel institusiModel = InstitusiModel(
          id: ins.id,
          nama: ins.nama,
          alamat: ins.alamat,
          lastModified: DateTime.now().toString(),
        );
        nInstitusi.add(institusiModel);
      }
      await DbHelper.putInstitusi(store_, nInstitusi);
      debugPrint("institusi data has been pulled from server to local");
    }
  }

  /// Pull data user from server
  /// Params : userAkun , id to update(only if update data)
  Future pullUser() async {
    try {
      Akun? userAkun = await DioClient().getAkun(token: token);
      var userData = userAkun?.data;
      if (userData != null) {
        UserModel user = UserModel(
          id: userData.id,
          username: userData.username,
          password: userData.password,
          status: userData.status,
          role: userData.role,
          lastModified: DateTime.now().toString(),
        );

        await DbHelper.putUser(store_, user);
        debugPrint("user data has been pulled from server to local");
      } else {
        debugPrint("user data not found on server");
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future pullProvinsi({List<Provinsi>? provinsiData}) async {
    List<ProvinsiModel> nProvinsi = [];
    if (provinsiData == null) {
      try {
        // Get provinsi form server
        List<Provinsi>? provinsi = await DioClient().getProvinsi(token: token);
        if (provinsi != null) {
          for (var prov in provinsi) {
            ProvinsiModel provinsiModel = ProvinsiModel(
              id: prov.id,
              nama: prov.nama,
              lastModified: DateTime.now().toString(),
            );
            nProvinsi.add(provinsiModel);
          }
          await DbHelper.deleteAllProvinsi(store_);
          await DbHelper.putProvinsi(store_, nProvinsi);
          debugPrint("provinsi data has been pulled from server to local");
        } else {
          debugPrint("provinsi data not found on server");
        }
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      for (var prov in provinsiData) {
        ProvinsiModel provinsiModel = ProvinsiModel(
          id: prov.id,
          nama: prov.nama,
          lastModified: DateTime.now().toString(),
        );
        nProvinsi.add(provinsiModel);
      }
      await DbHelper.deleteAllProvinsi(store_);
      await DbHelper.putProvinsi(store_, nProvinsi);
      debugPrint("provinsi data has been pulled from server to local");
    }
  }

  Future pullKabupaten({List<Kabupaten>? kabupatenData}) async {
    List<KabupatenModel> nKabupaten = [];
    if (kabupatenData == null) {
      try {
        // Get kabupaten form server
        List<Kabupaten>? kabupaten =
            await DioClient().getAllKabupaten(token: token);
        if (kabupaten != null) {
          for (var kab in kabupaten) {
            KabupatenModel kabupatenModel = KabupatenModel(
              id: kab.id,
              nama: kab.nama,
              provinsiId: int.parse(kab.provinsiId),
              lastModified: DateTime.now().toString(),
            );
            nKabupaten.add(kabupatenModel);
          }
          await DbHelper.deleteAllKabupaten(store_);
          await DbHelper.putKabupaten(store_, nKabupaten);
          debugPrint("kabupaten data has been pulled from server to local");
        } else {
          debugPrint("kabupaten data not found on server");
        }
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      for (var kab in kabupatenData) {
        KabupatenModel kabupatenModel = KabupatenModel(
          id: kab.id,
          nama: kab.nama,
          provinsiId: int.parse(kab.provinsiId),
          lastModified: DateTime.now().toString(),
        );
        nKabupaten.add(kabupatenModel);
      }
      await DbHelper.deleteAllKabupaten(store_);
      await DbHelper.putKabupaten(store_, nKabupaten);
      debugPrint("kabupaten data has been pulled from server to local");
    }
  }

  Future pullKecamatan({List<Kecamatan>? kecamatanData}) async {
    List<KecamatanModel> nKecamatan = [];
    if (kecamatanData == null) {
      try {
        // Get kecamatan form server
        List<Kecamatan>? kecamatan =
            await DioClient().getAllKecamatan(token: token);
        if (kecamatan != null) {
          for (var kec in kecamatan) {
            KecamatanModel kecamatanModel = KecamatanModel(
              id: kec.id,
              nama: kec.nama,
              kabupatenId: int.parse(kec.kabupatenKotaId),
              lastModified: DateTime.now().toString(),
            );
            nKecamatan.add(kecamatanModel);
          }
          await DbHelper.deleteAllKecamatan(store_);
          await DbHelper.putKecamatan(store_, nKecamatan);
          debugPrint("kecamatan data has been pulled from server to local");
        } else {
          debugPrint("kecamatan data not found on server");
        }
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      for (var kec in kecamatanData) {
        KecamatanModel kecamatanModel = KecamatanModel(
          id: kec.id,
          nama: kec.nama,
          kabupatenId: int.parse(kec.kabupatenKotaId),
          lastModified: DateTime.now().toString(),
        );
        nKecamatan.add(kecamatanModel);
      }
      await DbHelper.deleteAllKecamatan(store_);
      await DbHelper.putKecamatan(store_, nKecamatan);
      debugPrint("kecamatan data has been pulled from server to local");
    }
  }

  Future pullKelurahan({List<Kelurahan>? kelurahanData}) async {
    List<KelurahanModel> nKelurahan = [];
    if (kelurahanData == null) {
      try {
        // Get kelurahan form server
        List<Kelurahan>? kelurahan =
            await DioClient().getAllKelurahan(token: token);
        if (kelurahan != null) {
          for (var kel in kelurahan) {
            KelurahanModel kelurahanModel = KelurahanModel(
              id: kel.id,
              nama: kel.nama,
              kecamatanId: int.parse(kel.kecamatanId),
              lastModified: DateTime.now().toString(),
            );
            nKelurahan.add(kelurahanModel);
          }
          await DbHelper.deleteAllKelurahan(store_);
          await DbHelper.putKelurahan(store_, nKelurahan);
          debugPrint("kelurahan data has been pulled from server to local");
        } else {
          debugPrint("kelurahan data not found on server");
        }
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      for (var kel in kelurahanData) {
        KelurahanModel kelurahanModel = KelurahanModel(
          id: kel.id,
          nama: kel.nama,
          kecamatanId: int.parse(kel.kecamatanId),
          lastModified: DateTime.now().toString(),
        );
        nKelurahan.add(kelurahanModel);
      }
      await DbHelper.deleteAllKelurahan(store_);
      await DbHelper.putKelurahan(store_, nKelurahan);
      debugPrint("kelurahan data has been pulled from server to local");
    }
  }

  Future pullJawabanSoal({List<JawabanSoal>? jawabanSoalData}) async {
    List<JawabanSoalModel> nJawabanSoal = [];
    if (jawabanSoalData == null) {
      try {
        // Get jawabanSoal form server
        List<JawabanSoal>? jawabanSoal =
            await DioClient().getJawabanSoal(token: token);
        if (jawabanSoal != null) {
          for (var jawaban in jawabanSoal) {
            JawabanSoalModel jawabanSoalModel = JawabanSoalModel(
              id: jawaban.id,
              isLainnya: int.parse(jawaban.isLainnya),
              soalId: int.parse(jawaban.soalId),
              jawaban: jawaban.jawaban,
              lastModified: DateTime.now().toString(),
            );
            nJawabanSoal.add(jawabanSoalModel);
          }
          await DbHelper.deleteAllJawabanSoal(store_);
          await DbHelper.putJawabanSoal(store_, nJawabanSoal);
          debugPrint("jawaban soal data has been pulled from server to local");
        } else {
          debugPrint("jawabanSoal data not found on server");
        }
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      for (var jawaban in jawabanSoalData) {
        JawabanSoalModel jawabanSoalModel = JawabanSoalModel(
          id: jawaban.id,
          isLainnya: int.parse(jawaban.isLainnya),
          soalId: int.parse(jawaban.soalId),
          jawaban: jawaban.jawaban,
          lastModified: DateTime.now().toString(),
        );
        nJawabanSoal.add(jawabanSoalModel);
      }
      await DbHelper.deleteAllJawabanSoal(store_);
      await DbHelper.putJawabanSoal(store_, nJawabanSoal);
      debugPrint("jawaban soal data has been pulled from server to local");
    }
  }

  Future pullSoal({List<Soal>? soalData}) async {
    List<SoalModel> nSoal = [];
    if (soalData == null) {
      try {
        // Get soal form server
        List<Soal>? soal_ = await DioClient().getAllSoal(token: token);
        if (soal_ != null) {
          for (var soal in soal_) {
            SoalModel soalModel = SoalModel(
              id: soal.id,
              soal: soal.soal,
              urutan: int.parse(soal.urutan),
              tipeJawaban: soal.tipeJawaban,
              isNumerik: int.parse(soal.isNumerik),
              kategoriSoalId: int.parse(soal.kategoriSoalId),
              lastModified: DateTime.now().toString(),
            );
            nSoal.add(soalModel);
          }
          await DbHelper.deleteAllSoal(store_);
          await DbHelper.putSoal(store_, nSoal);
          debugPrint("soal data has been pulled from server to local");
        } else {
          debugPrint("soal data not found on server");
        }
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      for (var soal in soalData) {
        SoalModel soalModel = SoalModel(
          id: soal.id,
          soal: soal.soal,
          urutan: int.parse(soal.urutan),
          tipeJawaban: soal.tipeJawaban,
          isNumerik: int.parse(soal.isNumerik),
          kategoriSoalId: int.parse(soal.kategoriSoalId),
          lastModified: DateTime.now().toString(),
        );
        nSoal.add(soalModel);
      }
      await DbHelper.deleteAllSoal(store_);
      await DbHelper.putSoal(store_, nSoal);
      debugPrint("soal data has been pulled from server to local");
    }
  }

  Future pullKategoriSoal({List<KategoriSoal>? kategoriSoalData}) async {
    List<KategoriSoalModel> nKategoriSoal = [];
    if (kategoriSoalData == null) {
      try {
        // Get kategoriSoal form server
        List<KategoriSoal>? kategoriSoal =
            await DioClient().getAllKategoriSoal(token: token);
        if (kategoriSoal != null) {
          for (var kategori in kategoriSoal) {
            KategoriSoalModel kategoriSoalModel = KategoriSoalModel(
              id: kategori.id,
              urutan: int.parse(kategori.urutan),
              nama: kategori.nama,
              namaSurveyId: int.parse(kategori.namaSurveyId),
              lastModified: DateTime.now().toString(),
            );
            nKategoriSoal.add(kategoriSoalModel);
          }
          await DbHelper.deleteAllKategoriSoal(store_);
          await DbHelper.putKategoriSoal(store_, nKategoriSoal);
          debugPrint("kategori soal data has been pulled from server to local");
        } else {
          debugPrint("kategoriSoal data not found on server");
        }
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      for (var kategori in kategoriSoalData) {
        KategoriSoalModel kategoriSoalModel = KategoriSoalModel(
          id: kategori.id,
          urutan: int.parse(kategori.urutan),
          nama: kategori.nama,
          namaSurveyId: int.parse(kategori.namaSurveyId),
          lastModified: DateTime.now().toString(),
        );
        nKategoriSoal.add(kategoriSoalModel);
      }
      await DbHelper.putKategoriSoal(store_, nKategoriSoal);
      debugPrint("kategori soal data has been pulled from server to local");
    }
  }

  Future pullNamaSurvey({List<NamaSurvey>? namaSurveyData}) async {
    List<NamaSurveyModel> nNamaSurvey = [];
    if (namaSurveyData == null) {
      try {
        // Get namaSurvey form server
        List<NamaSurvey>? namaSurvey =
            await DioClient().getNamaSurvey(token: token);
        if (namaSurvey != null) {
          for (var nama in namaSurvey) {
            NamaSurveyModel namaSurveyModel = NamaSurveyModel(
              id: nama.id,
              nama: nama.nama,
              tipe: nama.tipe,
              isAktif: nama.isAktif,
              lastModified: DateTime.now().toString(),
            );
            nNamaSurvey.add(namaSurveyModel);
          }
          await DbHelper.deleteAllNamaSurvey(store_);
          await DbHelper.putNamaSurvey(store_, nNamaSurvey);
          debugPrint("nama survey data has been pulled from server to local");
        } else {
          debugPrint("namaSurvey data not found on server");
        }
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      for (var nama in namaSurveyData) {
        NamaSurveyModel namaSurveyModel = NamaSurveyModel(
          id: nama.id,
          nama: nama.nama,
          tipe: nama.tipe,
          isAktif: nama.isAktif,
          lastModified: DateTime.now().toString(),
        );
        nNamaSurvey.add(namaSurveyModel);
      }
      await DbHelper.putNamaSurvey(store_, nNamaSurvey);
      debugPrint("nama survey data has been pulled from server to local");
    }
  }

  Future pullResponden(
      {List<RespondenModel>? respondenData, required bool isCreate}) async {
    int id = await getIdResponden();
    List<RespondenModel> nResponden = [];
    if (respondenData == null) {
      try {
        // Get responden form server
        List<Responden>? responden =
            await DioClient().getResponden(token: token, withTrashed: true);
        if (responden != null) {
          for (var resp in responden) {
            RespondenModel respondenModel = RespondenModel(
              id: id,
              kodeUnik: int.parse(resp.kodeUnik!),
              kartuKeluarga: int.parse(resp.kartuKeluarga),
              namaKepalaKeluarga: resp.namaKepalaKeluarga,
              alamat: resp.alamat,
              nomorHp: resp.nomorHp.toString(),
              provinsiId: int.parse(resp.provinsiId),
              kabupatenId: int.parse(resp.kabupatenKotaId),
              kecamatanId: int.parse(resp.kecamatanId),
              kelurahanId: int.parse(resp.desaKelurahanId),
              lastModified: DateTime.now().toString(),
              deletedAt: resp.deletedAt.toString(),
            );
            nResponden.add(respondenModel);
            id += 1;
          }
          await DbHelper.putResponden(store_, nResponden);
          debugPrint("responden data has been pulled from server to local");
        } else {
          debugPrint("responden data not found on server");
        }
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      if (isCreate) {
        for (var resp in respondenData) {
          RespondenModel respondenModel = RespondenModel(
            id: id,
            kodeUnik: resp.kodeUnik,
            kartuKeluarga: resp.kartuKeluarga,
            namaKepalaKeluarga: resp.namaKepalaKeluarga,
            alamat: resp.alamat,
            nomorHp: resp.nomorHp.toString(),
            provinsiId: resp.provinsiId,
            kabupatenId: resp.kabupatenId,
            kecamatanId: resp.kecamatanId,
            kelurahanId: resp.kelurahanId,
            lastModified: DateTime.now().toString(),
            deletedAt: resp.deletedAt,
          );
          nResponden.add(respondenModel);
          id += 1;
        }
        await DbHelper.putResponden(store_, nResponden);
        debugPrint(
            "responden data has been pulled(created) from server to local");
      } else {
        // get id of local responden
        for (var item in respondenData) {
          int idToUpdate = await getCurrentRespondenId(kodeUnik: item.kodeUnik);
          RespondenModel respondenModel = RespondenModel(
            id: idToUpdate,
            kodeUnik: item.kodeUnik,
            kartuKeluarga: item.kartuKeluarga,
            namaKepalaKeluarga: item.namaKepalaKeluarga,
            alamat: item.alamat,
            nomorHp: item.nomorHp,
            provinsiId: item.provinsiId,
            kabupatenId: item.kabupatenId,
            kecamatanId: item.kecamatanId,
            kelurahanId: item.kelurahanId,
            lastModified: DateTime.now().toString(),
            deletedAt: item.deletedAt,
          );
          nResponden.add(respondenModel);
        }
        // update data
        await DbHelper.putResponden(store_, nResponden);
        debugPrint(
            "responden data has been pulled(updated) from server to local");
      }
    }
  }

  Future pullSurvey(
      {List<SurveyModel>? surveyData, required bool isCreate}) async {
    int id = await getIdSurvey();
    List<SurveyModel> nSurvey = [];
    if (surveyData == null) {
      try {
        // Get responden form server
        List<Survey>? survey = await DioClient().getSurvey(token: token);
        if (survey != null) {
          for (var surv in survey) {
            SurveyModel surveyModel = SurveyModel(
              id: id,
              kodeUnik: int.parse(surv.kodeUnik!),
              kategoriSelanjutnya: surv.kategoriSelanjutnya != null
                  ? int.parse(surv.kategoriSelanjutnya!)
                  : null,
              // kategoriSelanjutnya: int.tryParse(surv.kategoriSelanjutnya!),
              isSelesai: int.parse(surv.isSelesai),
              kodeUnikRespondenId: int.tryParse(surv.kodeUnikResponden),
              namaSurveyId: int.tryParse(surv.namaSurveyId),
              profileId: int.tryParse(surv.profileId),
              lastModified: surv.updatedAt.toString(),
            );
            nSurvey.add(surveyModel);
            id += 1;
          }
          await DbHelper.putSurvey(store_, nSurvey);
          debugPrint("survey data has been pulled from server to local");
        } else {
          debugPrint("survey data not found on server");
        }
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      if (isCreate) {
        for (var s in surveyData) {
          SurveyModel surveyModel = SurveyModel(
            id: id,
            kodeUnik: s.kodeUnik,
            kategoriSelanjutnya: s.kategoriSelanjutnya,
            isSelesai: s.isSelesai,
            namaSurveyId: s.namaSurveyId,
            profileId: s.profileId,
            kodeUnikRespondenId: s.kodeUnikRespondenId,
            lastModified: s.lastModified,
          );
          nSurvey.add(surveyModel);
          id += 1;
        }
        await DbHelper.putSurvey(store_, nSurvey);
        debugPrint("survey data has been pulled from server to local[create]");
      } else {
        for (var item in surveyData) {
          int idToUpdate = await getCurrentSurveyId(kodeUnik: item.kodeUnik);
          if (idToUpdate != -1) {
            SurveyModel surveyModel = SurveyModel(
              id: idToUpdate,
              kodeUnik: item.kodeUnik,
              kategoriSelanjutnya: item.kategoriSelanjutnya,
              isSelesai: item.isSelesai,
              namaSurveyId: item.namaSurveyId,
              profileId: item.profileId,
              kodeUnikRespondenId: item.kodeUnikRespondenId,
              lastModified: item.lastModified,
            );
            nSurvey.add(surveyModel);
          } else {
            errorScackbar('Survey tidak ditemukan');
          }
        }
        await DbHelper.putSurvey(store_, nSurvey);
        debugPrint("survey data has been pulled from server to local[update]");
      }
      // Pull JawabanSurvey (Delete current and change with new data)
      List<int> kodeUnikSurvey = [];
      for (var kode in surveyData) {
        kodeUnikSurvey.add(kode.kodeUnik);
      }
      await pullJawabanSurvey(kodeUnik: kodeUnikSurvey);
    }
  }

  Future pullJawabanSurvey({List<int>? kodeUnik}) async {
    int id = await getIdJawabanSurvey();
    List<JawabanSurveyModel> nJawabanSurvey = [];
    if (kodeUnik == null) {
      // get local survey
      List<SurveyModel> localSurveys = await DbHelper.getSurvey(store_);
      for (var survey in localSurveys) {
        // Get jawabanSurvey form server
        List<JawabanSurvey>? jawabanSurvey = await DioClient().getJawabanSurvey(
            token: token, kodeUnikSurvey: survey.kodeUnik.toString());

        if (jawabanSurvey != null) {
          for (var item in jawabanSurvey) {
            nJawabanSurvey.add(JawabanSurveyModel(
              id: id,
              jawabanLainnya: item.jawabanLainnya,
              soalId: int.parse(item.soalId),
              jawabanSoalId: item.jawabanSoalId != null
                  ? int.parse(item.jawabanSoalId!)
                  : null,
              kategoriSoalId: int.parse(item.kategoriSoalId),
              kodeUnikSurveyId: int.parse(item.kodeUnikSurvey),
              lastModified: DateTime.now().toString(),
            ));
            id += 1;
          }
          await DbHelper.putJawabanSurvey(store_, nJawabanSurvey);
          debugPrint(
              "jawaban survey data has been pulled from server to local[fresh create]");
        } else {
          debugPrint('jawaban survey not found on server');
        }
      }
    } else {
      // delete jawaban survey by kodeUnik before pull
      for (var nKodeUnik in kodeUnik) {
        await DbHelper.deleteJawabanSurveyByKodeUnikSurvey(store_,
            kodeUnikSurvey: nKodeUnik);

        // Get jawabanSurvey form server
        List<JawabanSurvey>? jawabanSurvey = await DioClient().getJawabanSurvey(
            token: token, kodeUnikSurvey: nKodeUnik.toString());
        int diman = id;
        if (jawabanSurvey != null) {
          for (var item in jawabanSurvey) {
            nJawabanSurvey.add(JawabanSurveyModel(
              // id: id,
              id: diman,
              jawabanLainnya: item.jawabanLainnya,
              jawabanSoalId: item.jawabanSoalId != null
                  ? int.parse(item.jawabanSoalId!)
                  : null,
              kategoriSoalId: int.parse(item.kategoriSoalId),
              kodeUnikSurveyId: int.parse(item.kodeUnikSurvey),
              soalId: int.parse(item.soalId),
              lastModified: DateTime.now().toString(),
            ));
            diman += 1;
            // id += 1;
          }
          await DbHelper.putJawabanSurvey(store_, nJawabanSurvey);
          debugPrint(
              "jawaban survey data has been pulled from server to local[refresh]");
        } else {
          debugPrint('jawaban survey not found on server');
        }
      }
    }
  }

  Future<int> getIdResponden() async {
    List<RespondenModel>? localResponden =
        await DbHelper.getResponden(Objectbox.store_);
    if (localResponden.isEmpty) {
      return 1;
    }
    int id = localResponden[localResponden.length - 1].id!;
    return id + 1;
  }

  Future<int> getCurrentRespondenId({required int kodeUnik}) async {
    RespondenModel responden = await DbHelper.getRespondenByKodeUnik(
        Objectbox.store_,
        kodeUnik: kodeUnik);
    int id = responden.id!;
    return id;
  }

  Future<int> getIdSurvey() async {
    List<SurveyModel>? localSurvey = await DbHelper.getSurvey(Objectbox.store_);
    if (localSurvey.isEmpty) {
      return 1;
    }
    int id = localSurvey[localSurvey.length - 1].id!;
    return id + 1;
  }

  Future<int> getCurrentSurveyId({required int kodeUnik}) async {
    SurveyModel? survey = await DbHelper.getSurveyByKodeUnik(Objectbox.store_,
        kodeUnik: kodeUnik);
    if (survey != null) {
      int id = survey.id!;
      return id;
    } else {
      return -1;
    }
  }

  Future<int> getIdJawabanSurvey() async {
    List<JawabanSurveyModel>? localJawabanSurvey =
        await DbHelper.getJawabanSurvey(Objectbox.store_);
    if (localJawabanSurvey.isEmpty) {
      return 1;
    }
    int id = localJawabanSurvey[localJawabanSurvey.length - 1].id!;
    return id + 1;
  }

  /// Comparing between two dates
  ///
  /// Params :
  /// localDate : DateTime
  ///
  /// serverDate : DateTime
  ///
  /// Return :
  /// 1 : localDate is greater than serverDate
  ///
  /// 0 : localDate is equal to serverDate
  ///
  /// -1 : localDate is less than serverDate
  int compareTime(DateTime local, DateTime server) {
    if (local.compareTo(server) > 0) {
      return 1;
    } else if (local.compareTo(server) == 0) {
      return 0;
    } else {
      return -1;
    }
  }
}
