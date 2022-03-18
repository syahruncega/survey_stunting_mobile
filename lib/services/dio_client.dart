import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:survey_stunting/models/auth.dart';
import 'package:survey_stunting/models/raw_response.dart';
import 'package:survey_stunting/models/session.dart';
import 'package:survey_stunting/models/survey.dart';
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

  Future<List<Survey>?> getAllSurvey({required String token}) async {
    List<Survey>? allSurvey;

    try {
      Response response = await _dio.get(
        "/surveyor/survey",
        options: Options(responseType: ResponseType.plain, headers: {
          "authorization": "Bearer $token",
        }),
      );

      log('${response.data}');
      allSurvey = listSurveyFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error get all survey: $e');
      rethrow;
    }
    return allSurvey;
  }
}
