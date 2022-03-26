import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_stunting/models/auth.dart';
import 'package:survey_stunting/models/jawaban_survey.dart';
import 'package:survey_stunting/models/kabupaten.dart';
import 'package:survey_stunting/models/kecamatan.dart';
import 'package:survey_stunting/models/kelurahan.dart';
import 'package:survey_stunting/models/nama_survey.dart';
import 'package:survey_stunting/models/provinsi.dart';
import 'package:survey_stunting/models/raw_response.dart';
import 'package:survey_stunting/models/responden.dart';
import 'package:survey_stunting/models/session.dart';
import 'package:survey_stunting/models/survey.dart';
import 'package:survey_stunting/models/survey_parameters.dart';
import 'package:survey_stunting/models/total_survey.dart';
import 'package:survey_stunting/services/logging.dart';

class DioClient {
  final String token = GetStorage().read("token");
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "${dotenv.env['BASE_URL']!}/api",
      responseType: ResponseType.plain,
    ),
  )..interceptors.add(Logging());

  Future<Session?> login({required Auth loginInfo}) async {
    Session? session;

    try {
      Response response = await _dio.post(
        "/login",
        data: loginInfo.toJson(),
      );

      session = sessionFromJson(response.data);
    } on DioError catch (e) {
      log('Error Login: $e');
      rethrow;
    }
    return session;
  }

  Future logout({required String token}) async {
    try {
      Response response = await _dio.get(
        "/logout",
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );

      log('${response.data}');
    } on DioError catch (e) {
      log('Error Logout: $e');
      rethrow;
    }
  }

  Future<List<Survey>?> getSurvey({
    required String token,
    SurveyParameters? queryParameters,
  }) async {
    try {
      Response response = await _dio.get(
        "/surveyor/survey",
        queryParameters: queryParameters?.toJson(),
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
      return listSurveyFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error get survey: $e');
      rethrow;
    }
  }

  Future<List<NamaSurvey>?> getNamaSurvey({
    required String token,
  }) async {
    try {
      Response response = await _dio.get(
        "/surveyor/survey/nama",
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
      return listNamaSurveyFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error get nama survey: $e');
      rethrow;
    }
  }

  Future<List<Responden>?> getResponden({
    required String token,
  }) async {
    try {
      Response response = await _dio.get(
        "/responden",
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
      return listRespondenFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error get responden: $e');
      rethrow;
    }
  }

  Future<TotalSurvey?> getTotalSurvey({
    required String token,
  }) async {
    try {
      Response response = await _dio.get(
        "/surveyor/survey/count",
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
      log('${response.data}');
      return totalSurveyFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error get total survey: $e');
      rethrow;
    }
  }

  Future deleteSurvey({
    required String token,
    required int id,
  }) async {
    try {
      await _dio.delete(
        "/surveyor/survey",
        data: {"id": id},
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
      // return listSurveyFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error get all survey: $e');
      rethrow;
    }
  }

  Future<List<Provinsi>?> getProvinsi({
    required String token,
  }) async {
    try {
      Response response = await _dio.get(
        "/provinsi",
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
      return listProvinsiFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error get provinsi: $e');
      rethrow;
    }
  }

  Future<List<Kabupaten>?> getKabupaten({
    required String token,
    required String provinsiId,
  }) async {
    try {
      Response response = await _dio.get(
        "/kabupaten_kota",
        queryParameters: {"provinsi_id": provinsiId},
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
      return listKabupatenFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error get kabupaten kota: $e');
      rethrow;
    }
  }

  Future<List<Kecamatan>?> getKecamatan({
    required String token,
    required String kabupatenId,
  }) async {
    try {
      Response response = await _dio.get(
        "/kecamatan",
        queryParameters: {"kabupaten_id": kabupatenId},
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
      return listKecamatanFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error get kecamatan: $e');
      rethrow;
    }
  }

  Future<List<Kelurahan>?> getKelurahan({
    required String token,
    required String kecamatanId,
  }) async {
    try {
      Response response = await _dio.get(
        "/desa_kelurahan",
        queryParameters: {"kecamatan_id": kecamatanId},
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
      return listKelurahanFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error get kelurahan: $e');
      rethrow;
    }
  }

  Future<Responden>? createResponden({
    required String token,
    required Responden data,
  }) async {
    try {
      Response response = await _dio.post(
        "/responden",
        data: respondenToJson(data),
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
      return respondenFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error create responden: $e');
      rethrow;
    }
  }

  Future<Survey>? createSurvey({
    required String token,
    required Survey data,
  }) async {
    try {
      Response response = await _dio.post(
        "/surveyor/survey",
        data: surveyToJson(data),
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
      return surveyFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error create survey: $e');
      rethrow;
    }
  }

  Future<JawabanSurvey>? createJawabanSurvey({
    required String token,
    required JawabanSurvey data,
  }) async {
    try {
      Response response = await _dio.post(
        "/surveyor/survey/jawaban",
        data: jawabanSurveyToJson(data),
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
      return jawabanSurveyFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error create jawaban survey: $e');
      rethrow;
    }
  }

  Future<JawabanSurvey>? updateJawabanSurvey({
    required String token,
    required JawabanSurvey data,
  }) async {
    try {
      Response response = await _dio.put(
        "/surveyor/survey",
        data: jawabanSurveyToJson(data),
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
      return jawabanSurveyFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error create jawaban survey: $e');
      rethrow;
    }
  }
}
