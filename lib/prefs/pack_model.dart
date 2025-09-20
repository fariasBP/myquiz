import 'package:loon/loon.dart';

class PackModel {
  static const String coll = 'packs';

  late String name;
  late String description;

  PackModel({required this.name, required this.description});

  toJson() {
    return {"name": name, "description": description};
  }

  PackModel.fromJson(Json json) {
    name = json['name'];
    description = json['description'];
  }

  static final Collection<PackModel> store = Loon.collection(
    PackModel.coll,
    fromJson: PackModel.fromJson,
    toJson: (pack) => pack.toJson(),
  );
}
