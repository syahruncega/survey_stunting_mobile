import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:survey_stunting/models/auth.dart';
import 'package:survey_stunting/models/kabupaten.dart';
import 'package:survey_stunting/models/kecamatan.dart';
import 'package:survey_stunting/models/kelurahan.dart';
import 'package:survey_stunting/models/provinsi.dart';
import 'package:survey_stunting/models/raw_response.dart';
import 'package:survey_stunting/models/session.dart';
import 'package:survey_stunting/models/survey.dart';
import 'package:survey_stunting/models/survey_parameters.dart';
import 'package:survey_stunting/models/total_survey.dart';
import 'package:survey_stunting/models/user_profile.dart';
import 'package:survey_stunting/services/logging.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "${dotenv.env['BASE_URL']!}/api",
    ),
  )..interceptors.add(Logging());

  Future<Session?> login({required Auth loginInfo}) async {
    Session? session;

    try {
      Response response = await _dio.post(
        "/login",
        data: loginInfo.toJson(),
        options: Options(
          responseType: ResponseType.plain,
        ),
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
        options: Options(responseType: ResponseType.plain, headers: {
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
        options: Options(responseType: ResponseType.plain, headers: {
          "authorization": "Bearer $token",
        }),
      );
      return listSurveyFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error get all survey: $e');
      rethrow;
    }
  }

  Future<List<Survey>?> getSurveyByStatus({
    required String token,
    required bool isCompleted,
  }) async {
    try {
      Response response = await _dio.get(
        "/surveyor/survey?status=${isCompleted ? 'selesai' : 'belum_selesai'}",
        options: Options(responseType: ResponseType.plain, headers: {
          "authorization": "Bearer $token",
        }),
      );
      return listSurveyFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error get all survey: $e');
      rethrow;
    }
  }

  Future<TotalSurvey?> getTotalSurvey({
    required String token,
  }) async {
    try {
      Response response = await _dio.get(
        "/surveyor/survey/count",
        options: Options(responseType: ResponseType.plain, headers: {
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

  Future getProfile({required String token}) async {
    try {
      Response response = await _dio.get("/dashboard/profile",
          options: Options(responseType: ResponseType.plain, headers: {
            "authorization": "Bearer $token",
          }));
      return profileFromJson(response.data);
    } on DioError catch (e) {
      log('failed to get profile data, $e');
      rethrow;
    }
  }

  Future<Provinsi> getProvinsi({required String token}) async {
    try {
      Response response = await _dio.get("/provinsi",
          options: Options(responseType: ResponseType.plain, headers: {
            "authorization": "Bearer $token",
          }));
      return provinsiFromJson(response.data);
    } on DioError catch (e) {
      log('failed to get data provinsi : $e');
      rethrow;
    }
  }

  Future<Kabupaten> getKabupaten({required String token}) async {
    try {
      Response response = await _dio.get("/kabupaten_kota",
          options: Options(responseType: ResponseType.plain, headers: {
            "authorization": "Bearer $token",
          }));
      return kabupatenFromJson(response.data);
    } on DioError catch (e) {
      log('failed to get data kabupaten $e');
      rethrow;
    }
  }

  Future<Kecamatan> getKecamatan({required String token}) async {
    try {
      Response response = await _dio.get("/kecamatan",
          options: Options(responseType: ResponseType.plain, headers: {
            "authorization": "Bearer $token",
          }));
      return kecamatanFromJson(response.data);
    } on DioError catch (e) {
      log('failed to get data kecamatan $e');
      rethrow;
    }
  }

  Future<Kelurahan> getKelurahan({required String token}) async {
    try {
      Response response = await _dio.get("/desa_kelurahan",
          options: Options(responseType: ResponseType.plain, headers: {
            "authorization": "Bearer $token",
          }));
      return kelurahanFromJson(response.data);
    } on DioError catch (e) {
      log('failed to get kelurahan data $e');
      rethrow;
    }
  }
}
