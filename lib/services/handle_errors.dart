import 'package:dio/dio.dart';
import 'package:survey_stunting/components/error_scackbar.dart';

handleError({required DioError error}) {
  if (error.type == DioErrorType.other) {
    errorScackbar('Anda tidak terhubung dengan internet');
  } else {
    errorScackbar('Sedang terjadi masalah, coba lagi beberapa saat');
  }
}
