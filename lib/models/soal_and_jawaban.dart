// To parse this JSON data, do
//
//     final soalAndJawaban = soalAndJawabanFromJson(jsonString);

import 'dart:convert';

import 'package:survey_stunting/models/jawaban_soal.dart';
import 'package:survey_stunting/models/soal.dart';

List<SoalAndJawaban> soalAndJawabanFromJson(String str) =>
    List<SoalAndJawaban>.from(
        json.decode(str).map((x) => SoalAndJawaban.fromJson(x)));

String soalAndJawabanToJson(List<SoalAndJawaban> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoalAndJawaban {
  SoalAndJawaban({
    required this.soal,
    this.jawabanSoal,
  });

  Soal soal;
  List<JawabanSoal>? jawabanSoal;

  factory SoalAndJawaban.fromJson(Map<String, dynamic> json) => SoalAndJawaban(
        soal: Soal.fromJson(json["soal"]),
        jawabanSoal: List<JawabanSoal>.from(
            json["jawaban_soal"].map((x) => JawabanSoal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "soal": soal.toJson(),
        "jawaban_soal": List<dynamic>.from(jawabanSoal!.map((x) => x.toJson())),
      };
}
