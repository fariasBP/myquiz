part of 'app_bloc.dart';

abstract class AppEvent {}

class ChangeModeEvent extends AppEvent {
  final bool isDark;
  ChangeModeEvent({required this.isDark});
}

class SetModeEvent extends AppEvent {
  final ThemeMode mode;
  SetModeEvent({required this.mode});
}

class ChangeNavEvent extends AppEvent {
  final int index;
  ChangeNavEvent({required this.index});
}
