import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/akun.dart';
import 'package:survey_stunting/models/localDb/provinsi_model.dart';
import 'package:survey_stunting/models/provinsi.dart';
import 'package:survey_stunting/models/responden.dart';

import '../components/error_scackbar.dart';
import '../components/success_scackbar.dart';
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

  Future syncData() async {
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
  }

  Future pullDataFromServer() async {
    pullUser();
    pullProfile();
    pullProvinsi();
    pullKabupaten();
    pullKecamatan();
    pullKelurahan();
    pullNamaSurvey();
    pullKategoriSoal();
    pullSoal();
    pullJawabanSoal();
    pullResponden();
    pullSurvey();
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
            pullProfile();
          } else {
            // local data is equal to server data
            debugPrint("Local data is equal to server data");
          }
        } else {
          // local profile not exist
          // pull data from server
          debugPrint("local data not exist. pull data from server");
          pullProfile();
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
            pushUser(localUser);
            return;
          }
          // compare local user with server user
          debugPrint("local user exist. compare local with server data");
          DateTime localTime = DateTime.parse(localUser.lastModified);
          DateTime serverTime = DateTime.parse(userData.updatedAt);
          int time = compareTime(localTime, serverTime);
          if (time == 1) {
            // local data is greater than server data
            debugPrint("Local data is greater than server data");
            pushUser(localUser);
          } else if (time == -1) {
            // local data is less than server data
            debugPrint("Local data is less than server data");
            pullUser();
          } else {
            // local data is equal to server data
            debugPrint("Local data is equal to server data");
          }
        } else {
          // local user not exist
          // pull data from server
          debugPrint("local data not exist. pull data from server");
          pullUser();
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
      if (provinsi != null) {
        pullProvinsi(provinsiData: provinsi);
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
      if (kabupaten != null) {
        pullKabupaten(kabupatenData: kabupaten);
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
      if (kecamatan != null) {
        pullKecamatan(kecamatanData: kecamatan);
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
      if (kelurahan != null) {
        pullKelurahan(kelurahanData: kelurahan);
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
        pullJawabanSoal(jawabanSoalData: jawabanSoal);
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
      if (soal != null) {
        pullSoal(soalData: soal);
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
      if (kategoriSoal != null) {
        pullKategoriSoal(kategoriSoalData: kategoriSoal);
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
      if (namaSurvey != null) {
        pullNamaSurvey(namaSurveyData: namaSurvey);
      } else {
        debugPrint("namaSurvey data not found on server");
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future syncResponden() async {
    try {
      // Get responden form server
      List<Responden>? responden = await DioClient().getResponden(token: token);
      if (responden != null) {
        pullResponden(respondenData: responden);
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
      List<SurveyModel> serverToPull = [];
      List<Survey> localToPush = [];

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
              // compare local user with server user
              debugPrint("local survey exist. compare local with server data");
              DateTime localTime = DateTime.parse(nLocalSurvey.lastModified);
              DateTime serverTime = survey.updatedAt!;
              int time = compareTime(localTime, serverTime);
              if (time == 1) {
                // local data is greater than server data
                debugPrint("Local data is greater than server data");
                localToPush.add(Survey.fromJson(nLocalSurvey.toJson()));
              } else if (time == -1) {
                // local data is less than server data
                debugPrint("Local data is less than server data");
                serverToPull.add(SurveyModel.fromJson(survey.toJson()));
              } else {
                // local data is equal to server data
                debugPrint("Local data is equal to server data");
              }
            } catch (e) {
              serverToPull.add(SurveyModel.fromJson(survey.toJson()));
              continue;
            }
          }

          for (var localSurvey in localSurveys) {
            try {
              Survey? nServerSurvey = surveys.singleWhere((element) =>
                  element.kodeUnik == localSurvey.kodeUnik.toString());
              // compare local user with server user
              debugPrint("server survey exist. compare server with local data");
              DateTime localTime = DateTime.parse(localSurvey.lastModified);
              DateTime serverTime = nServerSurvey.updatedAt!;
              int time = compareTime(localTime, serverTime);
              if (time == 1) {
                // local data is greater than server data
                debugPrint("Local data is greater than server data");
                localToPush.add(Survey.fromJson(localSurvey.toJson()));
              } else if (time == -1) {
                // local data is less than server data
                debugPrint("Local data is less than server data");
                serverToPull.add(SurveyModel.fromJson(nServerSurvey.toJson()));
              } else {
                // local data is equal to server data
                debugPrint("Local data is equal to server data");
              }
            } catch (e) {
              localToPush.add(Survey.fromJson(localSurvey.toJson()));
              continue;
            }
          }

          if (localToPush.isNotEmpty) {
            pushSurvey(localToPush.toSet().toList());
          }

          if (serverToPull.isNotEmpty) {
            pullSurvey(surveyData: serverToPull.toSet().toList());
          }
        } else {
          // local user not exist
          // pull data from server
          debugPrint("local data not exist. pull data from server");
          pullSurvey();
        }
      } else {
        debugPrint("survey data not found on server");
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  Future syncJawabanSurvey() async {
    try {
      // get survey from local
      var surveys = await DbHelper.getSurvey(store_);
      if (surveys.isNotEmpty) {
        for (var s in surveys) {
          // Get jawabanSurvey form server
          List<JawabanSurvey>? jawabanSurvey = await DioClient()
              .getJawabanSurvey(
                  token: token, kodeUnikSurvey: s.kodeUnik.toString());
          if (jawabanSurvey != null) {
            pullJawabanSurvey(jawabanSurvey);
          } else {
            debugPrint('jawaban survey not found on server');
          }
        }
      } else {
        debugPrint('local survey is empty');
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  void pullProfile() async {
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
    // var profileData = serverProfile.data!;
    // //remove profile before pull
    // await DbHelper.deleteAllProfile(store_);
    // ProfileModel profile = ProfileModel(
    //   id: profileData.id,
    //   namaLengkap: profileData.namaLengkap,
    //   jenisKelamin: profileData.jenisKelamin,
    //   tempatLahir: profileData.tempatLahir,
    //   tanggalLahir: profileData.tanggalLahir,
    //   alamat: profileData.alamat,
    //   provinsiId: profileData.provinsi,
    //   kabupatenId: profileData.kabupatenKota,
    //   kecamatanId: profileData.kecamatan,
    //   kelurahanId: profileData.desaKelurahan,
    //   nomorHp: profileData.nomorHp,
    //   email: profileData.email,
    //   userId: int.parse(profileData.userId),
    //   lastModified: DateTime.now().toString(),
    // );
    // await DbHelper.putProfile(store_, profile);
    // debugPrint("profile data has been pulled from server to local");
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
      updatedAt: localProfile.lastModified,
    );

    if (response) {
      successScackbar('Sync Data profile selesai.');
    } else {
      errorScackbar('Sync data profile Gagal.');
    }
  }

  void pushSurvey(List<Survey> surveyData) async {
    for (var survey in surveyData) {
      await DioClient().createSurvey(token: token, data: survey);
    }
    successScackbar('Sync Data Survey selesai.');
  }

  /// Pull data user from server
  /// Params : userAkun , id to update(only if update data)
  void pullUser() async {
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
    // var userData = serverAkun.data!;
    // // delete user berfore pull
    // DbHelper.deleteAllUser(store_);
    // UserModel user = UserModel(
    //   id: userData.id,
    //   username: userData.username,
    //   password: userData.password,
    //   status: userData.status,
    //   role: userData.role,
    //   lastModified: DateTime.now().toString(),
    // );
    // await DbHelper.putUser(store_, user);
    // debugPrint("user data has been pulled from server to local");
  }

  void pushUser(UserModel localUser) async {
    bool response = await DioClient().updateAkun(
      token: token,
      username: localUser.username!,
      password: localUser.password,
      updatedAt: localUser.lastModified,
    );

    if (response) {
      successScackbar('Sync Data user selesai.');
    } else {
      errorScackbar('Sync data user Gagal.');
    }
  }

  void pullProvinsi({List<Provinsi>? provinsiData}) async {
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
    // // delete provinsi berfore pull
    // await DbHelper.deleteAllProvinsi(store_);
    // for (var prov in provinsi) {
    //   ProvinsiModel provinsiModel = ProvinsiModel(
    //     id: prov.id,
    //     nama: prov.nama,
    //     lastModified: DateTime.now().toString(),
    //   );
    //   await DbHelper.putProvinsi(store_, provinsiModel);
    // }
    // debugPrint("provinsi data has been pulled from server to local");
  }

  void pullKabupaten({List<Kabupaten>? kabupatenData}) async {
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

  void pullKecamatan({List<Kecamatan>? kecamatanData}) async {
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

  void pullKelurahan({List<Kelurahan>? kelurahanData}) async {
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

  void pullJawabanSoal({List<JawabanSoal>? jawabanSoalData}) async {
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

  void pullSoal({List<Soal>? soalData}) async {
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

  void pullKategoriSoal({List<KategoriSoal>? kategoriSoalData}) async {
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
      await DbHelper.deleteAllKategoriSoal(store_);
      await DbHelper.putKategoriSoal(store_, nKategoriSoal);
      debugPrint("kategori soal data has been pulled from server to local");
    }
  }

  void pullNamaSurvey({List<NamaSurvey>? namaSurveyData}) async {
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
          lastModified: DateTime.now().toString(),
        );
        nNamaSurvey.add(namaSurveyModel);
      }
      await DbHelper.deleteAllNamaSurvey(store_);
      await DbHelper.putNamaSurvey(store_, nNamaSurvey);
      debugPrint("nama survey data has been pulled from server to local");
    }
  }

  void pullResponden({List<Responden>? respondenData}) async {
    List<RespondenModel> nResponden = [];
    if (respondenData == null) {
      try {
        // Get responden form server
        List<Responden>? responden =
            await DioClient().getResponden(token: token);
        if (responden != null) {
          for (var resp in responden) {
            RespondenModel respondenModel = RespondenModel(
              id: resp.id,
              kodeUnik: int.parse(resp.kodeUnik!),
              kartuKeluarga: int.parse(resp.kartuKeluarga),
              alamat: resp.alamat,
              nomorHp: resp.nomorHp.toString(),
              provinsiId: int.parse(resp.provinsiId),
              kabupatenId: int.parse(resp.kabupatenKotaId),
              kecamatanId: int.parse(resp.kecamatanId),
              kelurahanId: int.parse(resp.desaKelurahanId),
              lastModified: DateTime.now().toString(),
            );
            nResponden.add(respondenModel);
          }
          await DbHelper.deleteAllResponden(store_);
          await DbHelper.putResponden(store_, nResponden);
          debugPrint("responden data has been pulled from server to local");
        } else {
          debugPrint("responden data not found on server");
        }
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      for (var resp in respondenData) {
        RespondenModel respondenModel = RespondenModel(
          id: resp.id,
          kodeUnik: int.parse(resp.kodeUnik!),
          kartuKeluarga: int.parse(resp.kartuKeluarga),
          alamat: resp.alamat,
          nomorHp: resp.nomorHp.toString(),
          provinsiId: int.parse(resp.provinsiId),
          kabupatenId: int.parse(resp.kabupatenKotaId),
          kecamatanId: int.parse(resp.kecamatanId),
          kelurahanId: int.parse(resp.desaKelurahanId),
          lastModified: DateTime.now().toString(),
        );
        nResponden.add(respondenModel);
      }
      await DbHelper.deleteAllResponden(store_);
      await DbHelper.putResponden(store_, nResponden);
      debugPrint("responden data has been pulled from server to local");
    }
  }

  void pullSurvey({List<SurveyModel>? surveyData}) async {
    List<SurveyModel> nSurvey = [];
    if (surveyData == null) {
      try {
        // Get responden form server
        List<Survey>? survey = await DioClient().getSurvey(token: token);
        if (survey != null) {
          for (var surv in survey) {
            SurveyModel surveyModel = SurveyModel(
              id: surv.id,
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
      for (var s in surveyData) {
        SurveyModel surveyModel = SurveyModel(
          id: s.id,
          kodeUnik: s.kodeUnik,
          kategoriSelanjutnya: s.kategoriSelanjutnya,
          isSelesai: s.isSelesai,
          namaSurveyId: s.namaSurveyId,
          profileId: s.profileId,
          kodeUnikRespondenId: s.kodeUnikRespondenId,
          lastModified: s.lastModified,
        );
        nSurvey.add(surveyModel);
      }
      await DbHelper.putSurvey(store_, nSurvey);
      debugPrint("survey data has been pulled from server to local");
      await syncJawabanSurvey();
    }
  }

  void pullJawabanSurvey(List<JawabanSurvey> jawabanSurvey) async {
    // delete jawaban survey berfore pull
    await DbHelper.deleteAllJawabanSurvey(store_);
    List<JawabanSurveyModel> nJawabanSurvey = [];
    for (var jawaban in jawabanSurvey) {
      JawabanSurveyModel jawabanSurveyModel = JawabanSurveyModel(
        id: jawaban.id,
        jawabanLainnya:
            jawaban.jawabanLainnya != null ? jawaban.jawabanLainnya! : null,
        soalId: int.parse(jawaban.soalId),
        kategoriSoalId: int.parse(jawaban.kategoriSoalId),
        jawabanSoalId: jawaban.jawabanSoalId != null
            ? int.parse(jawaban.jawabanSoalId!)
            : null,
        kodeUnikSurveyId: int.parse(jawaban.kodeUnikSurvey),
        lastModified: DateTime.now().toString(),
      );
      nJawabanSurvey.add(jawabanSurveyModel);
    }
    await DbHelper.putJawabanSurvey(store_, nJawabanSurvey);
    debugPrint("jawaban survey data has been pulled from server to local");
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
