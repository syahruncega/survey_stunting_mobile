import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/institusi_model.dart';
import 'package:survey_stunting/models/localDb/survey_model.dart';
import 'package:survey_stunting/models/localDb/user_model.dart';

@Entity()
class ProfileModel {
  @Id(assignable: true)
  int? id = 0;
  String namaLengkap;
  String jenisKelamin;
  String tempatLahir;
  String tanggalLahir;
  String alamat;
  String provinsiId;
  String kabupatenId;
  String kecamatanId;
  String kelurahanId;
  String nomorHp;
  String? email;
  int? userId;
  String? institusiId;
  String lastModified;

  ProfileModel({
    this.id,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.alamat,
    required this.provinsiId,
    required this.kabupatenId,
    required this.kecamatanId,
    required this.kelurahanId,
    required this.nomorHp,
    this.email,
    this.userId,
    this.institusiId,
    required this.lastModified,
  });

  final user = ToOne<UserModel>();

  final institusi = ToOne<InstitusiModel>();

  @Backlink()
  final survey = ToMany<SurveyModel>();

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId.toString(),
        "institusi_id": institusi.toString(),
        "nama_lengkap": namaLengkap.toString(),
        "jenis_kelamin": jenisKelamin.toString(),
        "tempat_lahir": tempatLahir.toString(),
        "tanggal_lahir": tanggalLahir.toString(),
        "alamat": alamat.toString(),
        "provinsi": provinsiId.toString(),
        "kabupaten_kota": kabupatenId.toString(),
        "kecamatan": kecamatanId.toString(),
        "desa_kelurahan": kelurahanId.toString(),
        "nomor_hp": nomorHp.toString(),
        "email": email?.toString(),
        "updated_at": lastModified.toString(),
      };
}
