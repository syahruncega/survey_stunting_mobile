import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UbahProfilController extends GetxController {
  final provinsi = TextEditingController();
  final kabupatan = TextEditingController();
  final kecamatan = TextEditingController();
  final kelurahan = TextEditingController();

  final maskFormatter = MaskTextInputFormatter(
    mask: '##-##-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
}
