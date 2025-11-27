import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:myquiz/prefs/global.dart';

part 'app_state.dart';
part 'app_event.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState(mode: AppBloc.getTheme(), nav: 0)) {
    on<SetModeEvent>((event, emit) {
      emit(AppState(mode: event.mode, nav: state.nav));
    });
    on<ChangeModeEvent>((event, emit) async {
      GlobalPrefs prefs = GlobalPrefs();
      prefs.isDark = event.isDark;
      final newMode = event.isDark ? ThemeMode.dark : ThemeMode.light;
      emit(AppState(mode: newMode, nav: state.nav));
    });
    on<ChangeNavEvent>((event, emit) {
      emit(AppState(mode: state.mode, nav: event.index));
    });
  }

  static getTheme() {
    GlobalPrefs prefs = GlobalPrefs();
    return prefs.isDark ? ThemeMode.dark : ThemeMode.light;
  }
}
