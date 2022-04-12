import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/kategori_soal_model.dart';
import 'package:survey_stunting/models/localDb/survey_model.dart';

@Entity()
class NamaSurveyModel {
  int? id = 0;
  String nama;
  String tipe;

  NamaSurveyModel({this.id, required this.nama, required this.tipe});

  @Backlink()
  final kategoriSoal = ToMany<KategoriSoalModel>();

  @Backlink()
  final survey = ToMany<SurveyModel>();
}
