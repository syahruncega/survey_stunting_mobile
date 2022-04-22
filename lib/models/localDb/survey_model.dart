import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/jawaban_survey_model.dart';
import 'package:survey_stunting/models/localDb/responden_model.dart';

import 'nama_survey_mode.dart';
import 'profile_model.dart';

@Entity()
class SurveyModel {
  @Id(assignable: true)
  int? id = 0;
  int kodeUnik;
  int? kategoriSelanjutnya;
  int isSelesai;
  int? kodeUnikRespondenId;
  int? namaSurveyId;
  int? profileId;
  String lastModified;

  SurveyModel({
    this.id,
    required this.kodeUnik,
    this.kategoriSelanjutnya,
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

class SurveysModel {
  int id;
  int kodeUnik;
  int? kategoriSelanjutnya;
  int isSelesai;
  int kodeUnikResponden;
  int namaSurveyId;
  int profileId;
  String lastModified;
  RespondenModel? respondenModel;
  NamaSurveyModel? namaSurveyModel;
  ProfileModel? profileModel;

  SurveysModel({
    required this.id,
    required this.kodeUnik,
    this.kategoriSelanjutnya,
    required this.isSelesai,
    required this.kodeUnikResponden,
    required this.namaSurveyId,
    required this.profileId,
    required this.lastModified,
    this.respondenModel,
    this.namaSurveyModel,
    this.profileModel,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode_unik_responden": kodeUnikResponden.toString(),
        "kode_unik": kodeUnik.toString(),
        "nama_survey_id": namaSurveyId.toString(),
        "profile_id": profileId.toString(),
        "kategori_selanjutnya": kategoriSelanjutnya.toString(),
        "is_selesai": isSelesai.toString(),
        "updated_at": lastModified.toString(),
        "created_at": lastModified.toString(),
        "responden": respondenModel?.toJson(),
        "nama_survey": namaSurveyModel?.toJson(),
        "profile": profileModel?.toJson(),
      };
}
