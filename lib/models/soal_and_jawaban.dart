// To parse this JSON data, do
//
//     final soalJawaban = soalJawabanFromJson(jsonString);

import 'dart:convert';

import 'package:survey_stunting/models/jawaban_soal.dart';
import 'package:survey_stunting/models/soal.dart';

List<SoalJawaban> soalJawabanFromJson(String str) => List<SoalJawaban>.from(
    json.decode(str).map((x) => SoalJawaban.fromJson(x)));

String soalJawabanToJson(List<SoalJawaban> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoalJawaban {
  SoalJawaban({
    required this.soal,
    this.jawaban,
  });

  Soal soal;
  List<JawabanSoal>? jawaban;

  factory SoalJawaban.fromJson(Map<String, dynamic> json) => SoalJawaban(
        soal: Soal.fromJson(json["soal"]),
        jawaban: List<JawabanSoal>.from(
            json["jawaban_soal"].map((x) => JawabanSoal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "soal": soal.toJson(),
        "jawaban_soal": List<dynamic>.from(jawaban!.map((x) => x.toJson())),
      };
}
