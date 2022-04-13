import 'package:objectbox/objectbox.dart';

import 'jawaban_survey_model.dart';
import 'soal_model.dart';

@Entity()
class JawabanSoalModel {
  int? id = 0;
  String jawaban;
  int isLainnya;
  int? soalId;
  int? jawabanSurveyId;

  JawabanSoalModel({
    this.id,
    required this.jawaban,
    required this.isLainnya,
    this.soalId,
    this.jawabanSurveyId,
  });

  final soal = ToOne<SoalModel>();
  final jawabanSurvey = ToOne<JawabanSurveyModel>();
}
