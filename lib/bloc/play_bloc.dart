import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loon/loon.dart';
import 'package:myquiz/config/scripts.dart';
import 'package:myquiz/prefs/qz_model.dart';
import 'package:myquiz/services/qz_services.dart';

part 'play_state.dart';
part 'play_event.dart';

class PlayBloc extends Bloc<PlayEvent, PlayState> {
  PlayBloc()
    : super(
        PlayState(
          packId: '',
          qzs: [],
          options: [],
          fails: [],
          currentIndex: 0,
          show: false,
        ),
      ) {
    on<LoadQzsPlayEvent>((event, emit) {
      final int index = 0;
      List<DocumentSnapshot<QzModel>> qzs = [];
      if (state.fails.isNotEmpty && event.onlyFails) {
        qzs = state.fails;
      } else {
        qzs = Parsering.shuffleList<DocumentSnapshot<QzModel>>(
          QzServices.getQzs(event.packId),
        );
      }
      emit(
        PlayState(
          packId: event.packId,
          qzs: qzs,
          options: Parsering.addAndShuffleList<String>(
            qzs[index].data.fake,
            qzs[index].data.answer,
            true,
          ),
          fails: [],
          currentIndex: index,
          show: false,
        ),
      );
    });
    on<ShowAnswerPlayEvent>((event, emit) {
      emit(
        PlayState(
          packId: state.packId,
          qzs: state.qzs,
          options: state.options,
          fails: state.fails,
          currentIndex: state.currentIndex,
          show: true,
        ),
      );
    });
    on<NextQzPlayEvent>((event, emit) {
      if (state.currentIndex < state.qzs.length - 1) {
        final int index = state.currentIndex + 1;
        emit(
          PlayState(
            packId: state.packId,
            qzs: state.qzs,
            options: Parsering.addAndShuffleList<String>(
              state.qzs[index].data.fake,
              state.qzs[index].data.answer,
              true,
            ),
            fails: state.fails,
            currentIndex: index,
            show: false,
          ),
        );
      }
    });
    on<WrongAnswerPlayEvent>((event, emit) {
      final List<DocumentSnapshot<QzModel>> newFails = List.from(state.fails);
      newFails.add(state.qzs[event.indexQzFail]);
      emit(
        PlayState(
          packId: state.packId,
          qzs: state.qzs,
          options: state.options,
          fails: newFails,
          currentIndex: state.currentIndex,
          show: state.show,
        ),
      );
    });
  }
}
