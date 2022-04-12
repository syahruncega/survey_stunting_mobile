import 'package:survey_stunting/models/localDb/objectBox_generated_files/objectbox.g.dart';
import 'package:survey_stunting/models/localDb/profile_model.dart';

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
  static Future<int> insertProfile(Store store, ProfileModel profile) async {
    // var store = await Objectbox.create();
    // return store.profileBox.put(profile);
    return store.box<ProfileModel>().put(profile);
  }

  static Future<List<ProfileModel>> getData(Store store) async {
    // var store = await Objectbox.create();
    return store.box<ProfileModel>().getAll();
  }
  // static Future<List<ProfileModel>> getData() async {
  //   var store = await Objectbox.create();
  //   return store.profileBox.getAll();
  // }
}
