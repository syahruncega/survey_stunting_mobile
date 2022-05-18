// To parse this JSON data, do
//
//     final detailSurvey = detailSurveyFromJson(jsonString);

import 'dart:convert';
import 'package:survey_stunting/models/jawaban_survey.dart';
import 'package:survey_stunting/models/soal.dart';

List<DetailSurvey> detailSurveyFromJson(String str) => List<DetailSurvey>.from(
    json.decode(str).map((x) => DetailSurvey.fromJson(x)));

String detailSurveyToJson(List<DetailSurvey> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DetailSurvey {
  DetailSurvey({
    required this.id,
    required this.urutan,
    required this.nama,
    required this.namaSurveyId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    required this.soal,
    required this.jawabanSurvey,
  });

  int id;
  String urutan;
  String nama;
  String namaSurveyId;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Soal> soal;
  List<JawabanSurvey> jawabanSurvey;

  factory DetailSurvey.fromJson(Map<String, dynamic> json) => DetailSurvey(
        id: json["id"],
        urutan: json["urutan"],
        nama: json["nama"],
        namaSurveyId: json["nama_survey_id"],
        deletedAt: json["deleted_at"] != null
            ? DateTime.parse(json["deleted_at"])
            : null,
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        soal: List<Soal>.from(json["soal"].map((x) => Soal.fromJson(x))),
        jawabanSurvey: List<JawabanSurvey>.from(
            json["jawaban_survey"].map((x) => JawabanSurvey.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "urutan": urutan,
        "nama": nama,
        "nama_survey_id": namaSurveyId,
        "deleted_at": deletedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "soal": List<dynamic>.from(soal.map((x) => x.toJson())),
        "jawaban_survey":
            List<dynamic>.from(jawabanSurvey.map((x) => x.toJson())),
      };
}
