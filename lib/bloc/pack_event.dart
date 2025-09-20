part of 'pack_bloc.dart';

abstract class PackEvent {}

class PacksEvent extends PackEvent {
  final List<DocumentSnapshot<PackModel>> packs;
  PacksEvent(this.packs);
}

class CreatePackEvent extends PackEvent {
  final String name;
  final String description;

  CreatePackEvent(this.name, this.description);
}
