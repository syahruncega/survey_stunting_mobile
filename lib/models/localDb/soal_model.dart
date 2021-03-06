import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/jawaban_soal_model.dart';
import 'package:survey_stunting/models/localDb/kategori_soal_model.dart';

import 'jawaban_survey_model.dart';

@Entity()
class SoalModel {
  @Id(assignable: true)
  int? id = 0;
  String soal;
  int urutan;
  String tipeJawaban;
  int isNumerik;
  int? kategoriSoalId;
  String lastModified;

  SoalModel({
    this.id,
    required this.soal,
    required this.urutan,
    required this.tipeJawaban,
    required this.isNumerik,
    this.kategoriSoalId,
    required this.lastModified,
  });

  @Backlink()
  final jawabanSoal = ToMany<JawabanSoalModel>();
  final kategoriSoal = ToOne<KategoriSoalModel>();

  @Backlink()
  final jawabanSurvey = ToMany<JawabanSurveyModel>();

  Map<String, dynamic> toJson() => {
        "id": id,
        "soal": soal.toString(),
        "urutan": urutan.toString(),
        "tipe_jawaban": tipeJawaban.toString(),
        "is_numerik": isNumerik.toString(),
        "kategori_soal_id": kategoriSoalId.toString(),
        "updated_at": lastModified.toString(),
      };
}
