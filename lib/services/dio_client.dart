import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:survey_stunting/models/akun.dart';
import 'package:survey_stunting/models/auth.dart';
import 'package:survey_stunting/models/jawaban_soal.dart';
import 'package:survey_stunting/models/jawaban_survey.dart';
import 'package:survey_stunting/models/kabupaten.dart';
import 'package:survey_stunting/models/kategori_soal.dart';
import 'package:survey_stunting/models/kecamatan.dart';
import 'package:survey_stunting/models/kelurahan.dart';
import 'package:survey_stunting/models/nama_survey.dart';
import 'package:survey_stunting/models/provinsi.dart';
import 'package:survey_stunting/models/raw_response.dart';
import 'package:survey_stunting/models/responden.dart';
import 'package:survey_stunting/models/session.dart';
import 'package:survey_stunting/models/soal.dart';
import 'package:survey_stunting/models/survey.dart';
import 'package:survey_stunting/models/survey_parameters.dart';
import 'package:survey_stunting/models/total_survey.dart';
import 'package:survey_stunting/models/user_profile.dart';
import 'package:survey_stunting/services/logging.dart';

class DioClient {
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

  Future<List<Survey>?> createSurvey({
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
      return listSurveyFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error create survey: $e');
      rethrow;
    }
  }

  Future<List<Survey>>? updateSurvey({
    required String token,
    required Object data,
  }) async {
    try {
      Response response = await _dio.put(
        "/surveyor/survey",
        data: jsonEncode(data),
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
      return listSurveyFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error update survey: $e');
      rethrow;
    }
  }

  Future deleteSurvey({
    required String token,
    required dynamic kodeUnik,
  }) async {
    try {
      await _dio.delete(
        "/surveyor/survey",
        data: {"kode_unik": kodeUnik},
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

  Future<List<NamaSurvey>?> getNamaSurvey({
    required String token,
  }) async {
    try {
      Response response = await _dio.get(
        "/nama_survey",
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
      log("${response.data}");
      return respondenFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error create responden: $e');
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

  Future<List<KategoriSoal>?> getKategoriSoal({
    required String token,
    required String namaSurveyId,
  }) async {
    try {
      Response response = await _dio.get(
        "/kategori_soal",
        queryParameters: {"nama_survey_id": int.parse(namaSurveyId)},
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
      return listKategoriSoalFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error get kategori soal: $e');
      rethrow;
    }
  }

  Future<List<Soal>?> getSoal({
    required String token,
    String? kategoriSoalId,
  }) async {
    try {
      Response response = await _dio.get(
        "/soal",
        queryParameters: {
          "kategori_soal_id":
              kategoriSoalId != null ? int.parse(kategoriSoalId) : null
        },
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
      return listSoalFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error get soal: $e');
      rethrow;
    }
  }

  Future<List<JawabanSoal>?> getJawabanSoal({
    required String token,
    String? id,
    String? soalId,
  }) async {
    try {
      Response response = await _dio.get(
        "/jawaban_soal",
        queryParameters: {
          "id": id != null ? int.parse(id) : null,
          "soal_id": soalId != null ? int.parse(soalId) : null
        },
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
      return listJawabanSoalFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error get jawaban soal: $e');
      rethrow;
    }
  }

  Future<List<JawabanSurvey>?> getJawabanSurvey({
    required String token,
    required String kodeUnikSurvey,
    String? soalId,
    String? kategoriSoalId,
  }) async {
    try {
      Response response = await _dio.get(
        "/jawaban_survey",
        queryParameters: {
          "kode_unik_survey": int.parse(kodeUnikSurvey),
          "kategori_soal_id":
              kategoriSoalId != null ? int.parse(kategoriSoalId) : null,
          "soal_id": soalId != null ? int.parse(soalId) : null,
        },
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
      return listJawabanSurveyFromJson(getData(response.data));
    } on DioError catch (e) {
      log('Error get jawaban survey: $e');
      rethrow;
    }
  }

  Future<JawabanSurvey>? createJawabanSurvey({
    required String token,
    required JawabanSurvey data,
  }) async {
    try {
      Response response = await _dio.post(
        "/jawaban_survey",
        data: jawabanSurveyToJson(data),
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
      log("$response");
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
        "/jawaban_survey",
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

  Future deleteJawabanSurvey({
    required String token,
    required String id,
  }) async {
    try {
      await _dio.delete(
        "/jawaban_survey",
        data: {"id": id},
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
    } on DioError catch (e) {
      log('Error delete jawaban survey: $e');
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

  Future getAkun({required String token}) async {
    try {
      Response response = await _dio.get("/dashboard/akun",
          options: Options(responseType: ResponseType.plain, headers: {
            "authorization": "Bearer $token",
          }));
      return akunFromJson(response.data);
    } on DioError catch (e) {
      log('failed to get account data $e');
      rethrow;
    }
  }

  Future updateAkun(
      {required String token,
      required String username,
      String? password}) async {
    try {
      Response response = await _dio.put("/dashboard/akun",
          options: Options(responseType: ResponseType.plain, headers: {
            "authorization": "Bearer $token",
          }),
          data: jsonEncode({'username': username, 'password': password}));
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 422) {
        return false;
      }
    } on DioError catch (e) {
      log('failed to update akun : $e');
      rethrow;
    }
  }

  Future updateProfile(
      {required String token,
      required String nama,
      required String jenisKelamin,
      required String tempatLahir,
      required String tglLahir,
      required String alamat,
      required String provinsi,
      required String kabupaten,
      required String kecamatan,
      required String kelurahan,
      required String nomorHp,
      required String email}) async {
    try {
      Response response = await _dio.put("/dashboard/profile",
          options: Options(responseType: ResponseType.plain, headers: {
            "authorization": "Bearer $token",
          }),
          data: jsonEncode({
            'nama_lengkap': nama,
            'jenis_kelamin': jenisKelamin,
            'tempat_lahir': tempatLahir,
            'tanggal_lahir': tglLahir,
            'alamat': alamat,
            'provinsi': provinsi,
            'kabupaten_kota': kabupaten,
            'kecamatan': kecamatan,
            'desa_kelurahan': kelurahan,
            'nomor_hp': nomorHp,
            'email': email
          }));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      log('failed to update profile data : $e');
      rethrow;
    }
  }
}
