import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/jawaban_survey_model.dart';
import 'package:survey_stunting/models/localDb/responden_model.dart';

import 'nama_survey_mode.dart';
import 'profile_model.dart';

@Entity()
class SurveyModel {
  int? id = 0;
  int kodeUnik;
  int kategoriSelanjutnya;
  int isSelesai;
  int? kodeUnikRespondenId;
  int? namaSurveyId;
  int? profileId;
  String lastModified;

  SurveyModel({
    this.id,
    required this.kodeUnik,
    required this.kategoriSelanjutnya,
    required this.isSelesai,
    this.kodeUnikRespondenId,
    this.namaSurveyId,
    this.profileId,
    required this.lastModified,
  });

  final kodeUnikResponden = ToOne<RespondenModel>();
  final namaSurvey = ToOne<NamaSurveyModel>();
  final profile = ToOne<ProfileModel>();

  @Backlink()
  final jawabanSurvey = ToMany<JawabanSurveyModel>();
}
