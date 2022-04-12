import 'package:survey_stunting/models/localDb/objectBox_generated_files/objectbox.g.dart';
import 'package:survey_stunting/models/localDb/profile_model.dart';

import 'user_model.dart';

class Objectbox {
  late final Store store;
  late final Admin admin;

  Objectbox._create(this.store) {
    if (Admin.isAvailable()) {
      admin = Admin(store);
    }
  }

  static Future<Objectbox> create() async {
    final store = await openStore();
    return Objectbox._create(store);
  }
}

class DbHelper {
  // ? Profile
  static Future<int> putProfile(Store store, ProfileModel profile) async {
    return store.box<ProfileModel>().put(profile);
  }

  static Future<List<ProfileModel>> getProfile(Store store) async {
    return store.box<ProfileModel>().getAll();
  }

  static Future<bool> deleteProfile(Store store, int id) async {
    return store.box<ProfileModel>().remove(id);
  }

  // ? Akun
  static Future<int> putUser(Store store, UserModel akun) async {
    return store.box<UserModel>().put(akun);
  }

  static Future<List<UserModel>> getUser(Store store) async {
    return store.box<UserModel>().getAll();
  }

  static Future<bool> deleteUser(Store store, int id) async {
    return store.box<UserModel>().remove(id);
  }
}
