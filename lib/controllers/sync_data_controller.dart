import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/akun.dart';
import 'package:survey_stunting/models/localDb/provinsi_model.dart';
import 'package:survey_stunting/models/provinsi.dart';

import '../components/error_scackbar.dart';
import '../components/success_scackbar.dart';
import '../models/jawaban_soal.dart';
import '../models/kabupaten.dart';
import '../models/kategori_soal.dart';
import '../models/kecamatan.dart';
import '../models/kelurahan.dart';
import '../models/localDb/helpers.dart';
import '../models/localDb/jawaban_soal_model.dart';
import '../models/localDb/kabupaten_model.dart';
import '../models/localDb/kategori_soal_model.dart';
import '../models/localDb/kecamatan_model.dart';
import '../models/localDb/kelurahan_model.dart';
import '../models/localDb/nama_survey_mode.dart';
import '../models/localDb/profile_model.dart';
import '../models/localDb/soal_model.dart';
import '../models/localDb/user_model.dart';
import '../models/nama_survey.dart';
import '../models/soal.dart';
import '../models/user_profile.dart';
import '../services/dio_client.dart';
import '../services/handle_errors.dart';

class SyncDataController {
  Store store_;
  String token = GetStorage().read("token");

  SyncDataController({required this.store_});

  Future syncDataFromServer() async {
    // await syncDataUser();
    // await syncDataProfile();
    // await syncDataProvinsi();
    // await syncDataKabupaten();
    // await syncDataKecamatan();
    // await syncDataKelurahan();
    // await syncNamaSurvey();
    // await syncKategoriSoal();
    // await syncSoal();
    // await syncJawabanSoal();
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
            pullProfile(userProfile);
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
            pullProfile(userProfile);
          } else {
            // local data is equal to server data
            debugPrint("Local data is equal to server data");
          }
        } else {
          // local profile not exist
          // pull data from server
          debugPrint("local data not exist. pull data from server");
          pullProfile(userProfile);
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
            pullUser(userAkun);
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
            pullUser(userAkun);
          } else {
            // local data is equal to server data
            debugPrint("Local data is equal to server data");
          }
        } else {
          // local user not exist
          // pull data from server
          debugPrint("local data not exist. pull data from server");
          pullUser(userAkun);
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
        pullProvinsi(provinsi);
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
        pullKabupaten(kabupaten);
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
        pullKecamatan(kecamatan);
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
        pullKelurahan(kelurahan);
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
          await DioClient().getAllJawabanSoal(token: token);
      if (jawabanSoal != null) {
        pullJawabanSoal(jawabanSoal);
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
        pullSoal(soal);
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
        pullKategoriSoal(kategoriSoal);
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
        pullNamaSurvey(namaSurvey);
      } else {
        debugPrint("namaSurvey data not found on server");
      }
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  void pullProfile(UserProfile serverProfile) async {
    var profileData = serverProfile.data!;
    //remove profile before pull
    await DbHelper.deleteAllProfile(store_);
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

  /// Pull data user from server
  /// Params : userAkun , id to update(only if update data)
  void pullUser(Akun serverAkun) async {
    var userData = serverAkun.data!;
    // delete user berfore pull
    DbHelper.deleteAllUser(store_);
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

  void pullProvinsi(List<Provinsi> provinsi) async {
    // delete provinsi berfore pull
    await DbHelper.deleteAllProvinsi(store_);
    for (var prov in provinsi) {
      ProvinsiModel provinsiModel = ProvinsiModel(
        id: prov.id,
        nama: prov.nama,
        lastModified: DateTime.now().toString(),
      );
      await DbHelper.putProvinsi(store_, provinsiModel);
    }
    debugPrint("provinsi data has been pulled from server to local");
  }

  void pullKabupaten(List<Kabupaten> kabupaten) async {
    // delete kabupaten berfore pull
    await DbHelper.deleteAllKabupaten(store_);
    for (var kab in kabupaten) {
      KabupatenModel kabupatenModel = KabupatenModel(
        id: kab.id,
        nama: kab.nama,
        provinsiId: int.parse(kab.provinsiId),
        lastModified: DateTime.now().toString(),
      );
      await DbHelper.putKabupaten(store_, kabupatenModel);
    }
    debugPrint("kabupaten data has been pulled from server to local");
  }

  void pullKecamatan(List<Kecamatan> kecamatan) async {
    // delete kecamatan berfore pull
    await DbHelper.deleteAllKecamatan(store_);
    for (var kec in kecamatan) {
      KecamatanModel kecamatanModel = KecamatanModel(
        id: kec.id,
        nama: kec.nama,
        kabupatenId: int.parse(kec.kabupatenKotaId),
        lastModified: DateTime.now().toString(),
      );
      await DbHelper.putKecamatan(store_, kecamatanModel);
    }
    debugPrint("kecamatan data has been pulled from server to local");
  }

  void pullKelurahan(List<Kelurahan> kelurahan) async {
    // delete kelurahan berfore pull
    await DbHelper.deleteAllKelurahan(store_);
    for (var kel in kelurahan) {
      KelurahanModel kelurahanModel = KelurahanModel(
        id: kel.id,
        nama: kel.nama,
        kecamatanId: int.parse(kel.kecamatanId),
        lastModified: DateTime.now().toString(),
      );
      await DbHelper.putKelurahan(store_, kelurahanModel);
    }
    debugPrint("kelurahan data has been pulled from server to local");
  }

  void pullJawabanSoal(List<JawabanSoal> jawabanSoal) async {
    // delete jawaban berfore pull
    await DbHelper.deleteAllJawabanSoal(store_);
    for (var jawaban in jawabanSoal) {
      JawabanSoalModel jawabanSoalModel = JawabanSoalModel(
        id: jawaban.id,
        isLainnya: int.parse(jawaban.isLainnya),
        soalId: int.parse(jawaban.soalId),
        jawaban: jawaban.jawaban,
        lastModified: DateTime.now().toString(),
      );
      await DbHelper.putJawabanSoal(store_, jawabanSoalModel);
    }
    debugPrint("jawaban soal data has been pulled from server to local");
  }

  void pullSoal(List<Soal> soal) async {
    // delete soal berfore pull
    await DbHelper.deleteAllSoal(store_);
    for (var soal in soal) {
      SoalModel soalModel = SoalModel(
        id: soal.id,
        soal: soal.soal,
        urutan: int.parse(soal.urutan),
        tipeJawaban: soal.tipeJawaban,
        isNumerik: int.parse(soal.isNumerik),
        kategoriSoalId: int.parse(soal.kategoriSoalId),
        lastModified: DateTime.now().toString(),
      );
      await DbHelper.putSoal(store_, soalModel);
    }
    debugPrint("soal data has been pulled from server to local");
  }

  void pullKategoriSoal(List<KategoriSoal> kategoriSoal) async {
    // delete kategori berfore pull
    await DbHelper.deleteAllKategoriSoal(store_);
    for (var kategori in kategoriSoal) {
      KategoriSoalModel kategoriSoalModel = KategoriSoalModel(
        id: kategori.id,
        urutan: int.parse(kategori.urutan),
        nama: kategori.nama,
        namaSurveyId: int.parse(kategori.namaSurveyId),
        lastModified: DateTime.now().toString(),
      );
      await DbHelper.putKategoriSoal(store_, kategoriSoalModel);
    }
    debugPrint("kategori soal data has been pulled from server to local");
  }

  void pullNamaSurvey(List<NamaSurvey> namaSurvey) async {
    // delete nama survey berfore pull
    await DbHelper.deleteAllNamaSurvey(store_);
    for (var nama in namaSurvey) {
      NamaSurveyModel namaSurveyModel = NamaSurveyModel(
        id: nama.id,
        nama: nama.nama,
        tipe: nama.tipe,
        lastModified: DateTime.now().toString(),
      );
      await DbHelper.putNamaSurvey(store_, namaSurveyModel);
    }
    debugPrint("nama survey data has been pulled from server to local");
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
