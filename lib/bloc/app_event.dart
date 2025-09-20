part of 'app_bloc.dart';

abstract class AppEvent {}

class ChangeModeEvent extends AppEvent {}

class ChangeNavEvent extends AppEvent {
  final int index;
  ChangeNavEvent({required this.index});
}
