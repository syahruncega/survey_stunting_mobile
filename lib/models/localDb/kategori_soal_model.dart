import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/nama_survey_mode.dart';
import 'package:survey_stunting/models/localDb/soal_model.dart';

import 'jawaban_survey_model.dart';

@Entity()
class KategoriSoalModel {
  @Id(assignable: true)
  int? id = 0;
  int urutan;
  String nama;
  int? namaSurveyId;
  String lastModified;

  KategoriSoalModel({
    this.id,
    required this.urutan,
    required this.nama,
    this.namaSurveyId,
    required this.lastModified,
  });

  @Backlink()
  final soal = ToMany<SoalModel>();
  final namaSurvey = ToOne<NamaSurveyModel>();

  @Backlink()
  final jawabanSurvey = ToMany<JawabanSurveyModel>();

  Map<String, dynamic> toJson() => {
        "id": id,
        "urutan": urutan.toString(),
        "nama": nama.toString(),
        "nama_survey_id": namaSurveyId.toString(),
        "updated_at": lastModified.toString(),
      };
}
