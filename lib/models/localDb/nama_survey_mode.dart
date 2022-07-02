import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/kategori_soal_model.dart';
import 'package:survey_stunting/models/localDb/survey_model.dart';

@Entity()
class NamaSurveyModel {
  @Id(assignable: true)
  int? id = 0;
  String nama;
  String tipe;
  int isAktif;
  String lastModified;

  NamaSurveyModel({
    this.id,
    required this.nama,
    required this.tipe,
    required this.isAktif,
    required this.lastModified,
  });

  @Backlink()
  final kategoriSoal = ToMany<KategoriSoalModel>();

  @Backlink()
  final survey = ToMany<SurveyModel>();

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama.toString(),
        "tipe": tipe.toString(),
        "is_aktif": isAktif.toString(),
        "updated_at": lastModified.toString(),
      };
}
