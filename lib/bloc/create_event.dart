part of 'create_bloc.dart';

abstract class CreateEvent {}

class UpdatePackEvent extends CreateEvent {
  final String idPack;
  UpdatePackEvent({required this.idPack});
}

class UpdateQuestionEvent extends CreateEvent {
  final String question;
  UpdateQuestionEvent({required this.question});
}

class UpdateAnswerEvent extends CreateEvent {
  final String answer;
  UpdateAnswerEvent({required this.answer});
}

class AddFakeEvent extends CreateEvent {
  final String fake;
  AddFakeEvent({required this.fake});
}

class UpdateFakeEvent extends CreateEvent {
  final int index;
  final String fake;
  UpdateFakeEvent({required this.index, required this.fake});
}

class CreateQzEvent extends CreateEvent {}
