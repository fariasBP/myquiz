import 'package:loon/loon.dart';
import 'package:myquiz/prefs/pack_model.dart';

class PackServices {
  static List<DocumentSnapshot<PackModel>> getPacks() {
    List<DocumentSnapshot<PackModel>> packs = Loon.collection<PackModel>(
      PackModel.coll,
      fromJson: PackModel.fromJson,
      toJson: (pack) => pack.toJson(),
    ).get();
    return packs;
  }

  static String createPack(String name, String description) {
    final String id = uuid.v4();
    Loon.collection<PackModel>(
      PackModel.coll,
      fromJson: PackModel.fromJson,
      toJson: (pack) => pack.toJson(),
    ).doc(id).create(PackModel(name: name, description: description));
    return id;
  }
}
