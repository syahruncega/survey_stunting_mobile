import 'package:objectbox/objectbox.dart';
import 'soal_model.dart';

@Entity()
class JawabanSoalModel {
  @Id(assignable: true)
  int? id = 0;
  String jawaban;
  int isLainnya;
  int? soalId;
  // int? jawabanSurveyId;
  String lastModified;

  JawabanSoalModel({
    this.id,
    required this.jawaban,
    required this.isLainnya,
    this.soalId,
    // this.jawabanSurveyId,
    required this.lastModified,
  });

  final soal = ToOne<SoalModel>();
  // final jawabanSurvey = ToOne<JawabanSurveyModel>();

  Map<String, dynamic> toJson() => {
        "id": id,
        "jawaban": jawaban.toString(),
        "is_lainnya": isLainnya.toString(),
        "soal_id": soal.targetId.toString(),
        "updated_at": lastModified.toString(),
      };
}
