import 'package:objectbox/objectbox.dart';

@Entity()
class UserModel {
  @Id(assignable: true)
  int? id = 0;
  String? username;
  String? password;
  String? status;
  String? role;
  // int? profileId;
  String lastModified;

  UserModel({
    this.id,
    this.username,
    this.password,
    this.status,
    this.role,
    // this.profileId,
    required this.lastModified,
  });

  // final profile = ToOne<ProfileModel>();

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "password": password,
        "status": status,
        "role": role,
        "updated_at": lastModified,
      };
}
