import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/profile_model.dart';

@Entity()
class InstitusiModel {
  @Id(assignable: true)
  int? id = 0;
  String nama;
  String? alamat;
  String? deletedAt;
  String lastModified;

  InstitusiModel({
    this.id,
    required this.nama,
    this.alamat,
    this.deletedAt,
    required this.lastModified,
  });

  @Backlink()
  final profile = ToMany<ProfileModel>();

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama.toString(),
        "alamat": alamat.toString(),
        "deleted_at": deletedAt.toString(),
        "updated_at": lastModified.toString(),
      };
}
