import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/soal_model.dart';

import 'jawaban_soal_model.dart';
import 'kategori_soal_model.dart';
import 'survey_model.dart';

@Entity()
class JawabanSurveyModel {
  int id = 0;
  String jawabanLainnya;
  int? soalId;
  int? kodeUnikSurvey;
  int? kategoriSoalId;
  int? jawabanSoalId;

  JawabanSurveyModel({
    required this.jawabanLainnya,
    this.soalId,
    this.kodeUnikSurvey,
    this.kategoriSoalId,
    this.jawabanSoalId,
  });

  final soal = ToOne<SoalModel>();
  final survey = ToOne<SurveyModel>();
  final kategoriSoal = ToOne<KategoriSoalModel>();

  @Backlink()
  final jawabanSoal = ToMany<JawabanSoalModel>();
}
