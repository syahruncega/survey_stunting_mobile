import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/jawaban_survey_model.dart';

import 'nama_survey_mode.dart';
import 'profile_model.dart';

@Entity()
class SurveyModel {
  int? id = 0;
  int kodeUnik;
  int kategoriSelanjutnya;
  int isSelesai;
  int? kodeUnikResponden;
  int? namaSurveyId;
  int? profileId;

  SurveyModel(
      {this.id,
      required this.kodeUnik,
      required this.kategoriSelanjutnya,
      required this.isSelesai,
      this.kodeUnikResponden,
      this.namaSurveyId,
      this.profileId});

  final namaSurvey = ToOne<NamaSurveyModel>();
  final profile = ToOne<ProfileModel>();

  @Backlink()
  final jawabanSurvey = ToMany<JawabanSurveyModel>();
}
