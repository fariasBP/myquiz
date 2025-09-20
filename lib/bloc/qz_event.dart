part of 'qz_bloc.dart';

abstract class QzEvent {}

class LoadQzsEvent extends QzEvent {
  final String packId;
  LoadQzsEvent(this.packId);
}

class LoadQzsShuffleEvent extends QzEvent {
  final String packId;
  LoadQzsShuffleEvent(this.packId);
}
