import 'package:dio/dio.dart';
import 'package:survey_stunting/components/error_scackbar.dart';
import '../consts/globals_lib.dart' as global;

handleError({required DioError error}) {
  if (!global.offlineMode.value) {
    if (error.type == DioErrorType.other) {
      errorScackbar('Anda tidak terhubung dengan internet');
    } else {
      errorScackbar('Sedang terjadi masalah, coba lagi beberapa saat');
    }
  }
}
