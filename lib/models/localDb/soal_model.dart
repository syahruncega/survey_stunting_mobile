import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/jawaban_soal_model.dart';
import 'package:survey_stunting/models/localDb/kategori_soal_model.dart';

import 'jawaban_survey_model.dart';

@Entity()
class SoalModel {
  int? id = 0;
  String soal;
  int urutan;
  String tipeJawaban;
  int isNumerik;
  int? kategoriSoalId;

  SoalModel({
    this.id,
    required this.soal,
    required this.urutan,
    required this.tipeJawaban,
    required this.isNumerik,
    this.kategoriSoalId,
  });

  @Backlink()
  final jawabanSoal = ToMany<JawabanSoalModel>();
  final kategoriSoal = ToOne<KategoriSoalModel>();

  @Backlink()
  final jawabanSurvey = ToMany<JawabanSurveyModel>();
}
