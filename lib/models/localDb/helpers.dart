import 'dart:developer';

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
  /// Params:
  /// - store (ObjextBoxStore)
  /// - ProfileData (ProfileModel)
  /// - id (int) - id of profile optional only if you want to update profile
  static Future<int> putProfile(Store store, ProfileModel profile) async {
    profile.user.targetId = profile.userId;
    return store.box<ProfileModel>().put(profile);
  }

  /// Get all profile data
  static Future<List<ProfileModel>> getProfile(Store store) async {
    return store.box<ProfileModel>().getAll();
  }

  static Future<ProfileModel?> getProfileById(Store store,
      {required int id}) async {
    return store.box<ProfileModel>().get(id);
  }

  static Future<ProfileModel?> getProfileByUserId(Store store,
      {required int userId}) async {
    var profiles = await getProfile(store);
    return profiles.singleWhere((profile) => profile.user.targetId == userId);
  }

  static Future<bool> deleteProfile(Store store, int id) async {
    return store.box<ProfileModel>().remove(id);
  }

  // ? User
  /// Params:
  /// - store (ObjextBoxStore)
  /// - UserData (UserModel)
  /// - id (int) - id of the user optional only if you want to update the user
  static Future<int> putUser(Store store, UserModel user) async {
    user.profile.targetId = user.profileId;
    return store.box<UserModel>().put(user);
  }

  static Future<List<UserModel>> getUser(Store store) async {
    return store.box<UserModel>().getAll();
  }

  static Future<UserModel?> getUserById(Store store, {required int id}) async {
    return store.box<UserModel>().get(id);
  }

  static Future<UserModel?> getUserByProfileId(Store store,
      {required int profileId}) async {
    final users = await getUser(store);
    return users.firstWhere((user) => user.profile.targetId == profileId);
  }

  static Future<bool> deleteUser(Store store, {required int id}) async {
    return store.box<UserModel>().remove(id);
  }
}
