import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'app_state.dart';
part 'app_event.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState(mode: ThemeMode.light, nav: 0)) {
    on<ChangeModeEvent>((event, emit) {
      final newMode = state.mode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
      emit(AppState(mode: newMode, nav: state.nav));
    });
    on<ChangeNavEvent>((event, emit) {
      emit(AppState(mode: state.mode, nav: event.index));
    });
  }
}
