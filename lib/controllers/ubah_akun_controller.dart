import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_stunting/components/error_scackbar.dart';
import 'package:survey_stunting/components/success_scackbar.dart';
import 'package:survey_stunting/models/akun.dart';
import 'package:survey_stunting/models/localDb/helpers.dart';
import 'package:survey_stunting/models/localDb/user_model.dart';
import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';
import '../consts/globals_lib.dart' as global;

class UbahAkunController extends GetxController {
  String token = GetStorage().read("token");
  int userId = GetStorage().read("userId");
  late bool isConnect;

  final username = TextEditingController();
  final password = TextEditingController();
  final passwordConfirm = TextEditingController();
  final usernameError = "".obs;
  final passwordError = "".obs;
  final passwordConfirmError = "".obs;
  final showPassword = false.obs;

  Rx<Akun> akunData = Akun().obs;

  var isLoading = true.obs;
  var akunUpdateStatus = ''.obs;

  bool validate() {
    usernameError.value = "";
    passwordError.value = "";
    passwordConfirmError.value = "";

    if (username.text.trim().isEmpty) {
      usernameError.value = 'Nama pengguna wajib diisi';
    }
    if (password.text.trim().isNotEmpty) {
      if (password.text.length < 8) {
        passwordError.value = "Kata sandi minimal 8 karakter";
      } else if (passwordConfirm.text.trim().isEmpty) {
        passwordConfirmError.value = 'Mohon konfirmasi kata sandi';
      } else if (passwordConfirm.text.trim() != password.text.trim()) {
        passwordConfirmError.value = 'Kata sandi tidak cocok';
      }
    }

    if (usernameError.value.isNotEmpty ||
        passwordError.value.isNotEmpty ||
        passwordConfirmError.value.isNotEmpty) {
      return false;
    }
    return true;
  }

  Future updateAkun({required String username, String? password}) async {
    if (validate()) {
      if (isConnect) {
        debugPrint('update akun online');
        try {
          akunUpdateStatus.value = 'waiting';
          bool response = await DioClient().updateAkun(
            token: token,
            username: username,
            password: password,
            updatedAt: DateTime.now().toString(),
          );
          if (response) {
            akunUpdateStatus.value = 'successful';
            successScackbar("Akun berhasil diupdate");
          } else {
            akunUpdateStatus.value = 'failed';
            errorScackbar('Update akun gagal, Username sudah ada.');
          }
        } on DioError catch (e) {
          handleError(error: e);
        }
      } else {
        debugPrint('update akun local');
        errorScackbar('Update akun hanya dapat dilakukan saat online');
      }
    } else {
      debugPrint('update akun validation failed');
    }
  }

  Future getUserAkun() async {
    isLoading.value = true;
    if (isConnect) {
      debugPrint('get user online');
      try {
        Akun response = await DioClient().getAkun(token: token);
        akunData.value = response;
        if (akunData.value.data != null) {
          username.text = akunData.value.data!.username;
        }
        isLoading.value = false;
      } on DioError catch (e) {
        handleError(error: e);
      }
    } else {
      debugPrint('get user local');
      UserModel? localUser =
          await DbHelper.getUserById(Objectbox.store_, id: userId);
      if (localUser != null) {
        akunData.value = Akun.fromJson(localUser.toJson());
        username.text = akunData.value.data!.username;
      }
      isLoading.value = false;
    }
  }

  Future checkConnection() async {
    isConnect = await global.isConnected();
  }

  @override
  void onInit() async {
    await checkConnection();
    await getUserAkun();
    super.onInit();
  }
}
