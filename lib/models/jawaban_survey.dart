// To parse this JSON data, do
//
//     final jawabanSurvey = jawabanSurveyFromJson(jsonString);

import 'dart:convert';

List<JawabanSurvey> listJawabanSurveyFromJson(String str) =>
    List<JawabanSurvey>.from(
        json.decode(str).map((x) => JawabanSurvey.fromJson(x)));

String listJawabanSurveyToJson(List<JawabanSurvey> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

JawabanSurvey jawabanSurveyFromJson(String str) =>
    JawabanSurvey.fromJson(json.decode(str));

String jawabanSurveyToJson(JawabanSurvey data) => json.encode(data.toJson());

class JawabanSurvey {
  JawabanSurvey({
    this.id,
    required this.soalId,
    required this.kodeUnikSurvey,
    required this.kategoriSoalId,
    required this.jawabanSoalId,
    required this.jawabanLainnya,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String soalId;
  String kodeUnikSurvey;
  String kategoriSoalId;
  String? jawabanSoalId;
  String? jawabanLainnya;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory JawabanSurvey.fromJson(Map<String, dynamic> json) => JawabanSurvey(
        id: json["id"],
        soalId: json["soal_id"],
        kodeUnikSurvey: json["kode_unik_survey"],
        kategoriSoalId: json["kategori_soal_id"],
        jawabanSoalId: json["jawaban_soal_id"],
        jawabanLainnya: json["jawaban_lainnya"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "soal_id": soalId,
        "kode_unik_survey": kodeUnikSurvey,
        "kategori_soal_id": kategoriSoalId,
        "jawaban_soal_id": jawabanSoalId,
        "jawaban_lainnya": jawabanLainnya,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
