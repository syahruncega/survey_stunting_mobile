import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/nama_survey_mode.dart';
import 'package:survey_stunting/models/localDb/soal_model.dart';

import 'jawaban_survey_model.dart';

@Entity()
class KategoriSoalModel {
  int id = 0;
  int urutan;
  String nama;
  int? namaSurveyId;

  KategoriSoalModel({
    required this.urutan,
    required this.nama,
    this.namaSurveyId,
  });

  @Backlink()
  final soal = ToMany<SoalModel>();
  final namaSurvey = ToOne<NamaSurveyModel>();

  @Backlink()
  final jawabanSurvey = ToMany<JawabanSurveyModel>();
}
