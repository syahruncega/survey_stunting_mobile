import 'package:objectbox/objectbox.dart';

import 'jawaban_survey_model.dart';
import 'soal_model.dart';

@Entity()
class JawabanSoalModel {
  int? id = 0;
  String jawaban;
  int isLainnya;
  int? soalId;

  JawabanSoalModel({
    this.id,
    required this.jawaban,
    required this.isLainnya,
    this.soalId,
  });

  final soal = ToOne<SoalModel>();
  final jawabanSurvey = ToOne<JawabanSurveyModel>();
}
