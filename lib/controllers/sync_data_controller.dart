import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/akun.dart';

import '../components/error_scackbar.dart';
import '../components/success_scackbar.dart';
import '../models/localDb/helpers.dart';
import '../models/localDb/profile_model.dart';
import '../models/localDb/user_model.dart';
import '../models/user_profile.dart';
import '../services/dio_client.dart';
import '../services/handle_errors.dart';

class SyncDataController {
  Store store_;
  String token = GetStorage().read("token");

  SyncDataController({required this.store_});

  Future syncDataFromServer() async {
    await syncDataProfile();
    await syncDataUser();
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

  // create function synchDataUser to sync data user
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

  void pullProfile(UserProfile serverProfile) async {
    var profileData = serverProfile.data!;
    //remove profile before pull
    await DbHelper.deleteAllProfile(store_);
    ProfileModel profile = ProfileModel(
      id: 1,
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
      userId: 1,
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
      id: 1,
      username: userData.username,
      password: userData.password,
      status: userData.status,
      role: userData.role,
      profileId: 1,
      lastModified: DateTime.now().toString(),
    );
    await DbHelper.putUser(store_, user);
    debugPrint("user data has been pulled from server to local");
  }

  // create function pushUser to push data user
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
