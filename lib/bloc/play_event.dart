part of 'play_bloc.dart';

abstract class PlayEvent {}

class LoadQzsPlayEvent extends PlayEvent {
  final String packId;
  final bool onlyFails;
  LoadQzsPlayEvent(this.packId, {this.onlyFails = false});
}

class ShowAnswerPlayEvent extends PlayEvent {}

class NextQzPlayEvent extends PlayEvent {}

class WrongAnswerPlayEvent extends PlayEvent {
  final int indexQzFail;
  WrongAnswerPlayEvent(this.indexQzFail);
}
