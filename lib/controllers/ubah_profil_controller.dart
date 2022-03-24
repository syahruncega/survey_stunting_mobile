import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:survey_stunting/models/user_profile.dart';
import 'package:survey_stunting/services/dio_client.dart';
import 'package:survey_stunting/services/handle_errors.dart';

class UbahProfilController extends GetxController {
  final jenisKelamin = TextEditingController();
  final provinsi = TextEditingController();
  final kabupatan = TextEditingController();
  final kecamatan = TextEditingController();
  final kelurahan = TextEditingController();

  Rx<UserProfile> profileData = UserProfile().obs;
  String token = GetStorage().read("token");

  final maskFormatter = MaskTextInputFormatter(
    mask: '##-##-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  Future getUserProfile() async {
    try {
      UserProfile? response = await DioClient().getProfile(token: token);
      profileData.value = response!;
    } on DioError catch (e) {
      handleError(error: e);
    }
  }

  @override
  void onInit() async {
    await getUserProfile();
    super.onInit();
  }
}
