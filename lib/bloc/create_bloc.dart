import 'package:bloc/bloc.dart';
import 'package:myquiz/config/scripts.dart';
import 'package:myquiz/services/qz_services.dart';

part 'create_state.dart';
part 'create_event.dart';

class CreateBloc extends Bloc<CreateEvent, CreateState> {
  CreateBloc()
    : super(CreateState(question: '', answer: '', pack: '', fakeAnswers: [])) {
    on<UpdateQuestionEvent>(
      (event, emit) => emit(
        CreateState(
          question: event.question,
          answer: state.answer,
          pack: state.pack,
          fakeAnswers: state.fakeAnswers,
        ),
      ),
    );
    on<UpdateAnswerEvent>(
      (event, emit) => emit(
        CreateState(
          question: state.question,
          answer: event.answer,
          pack: state.pack,
          fakeAnswers: state.fakeAnswers,
        ),
      ),
    );
    on<UpdatePackEvent>(
      (event, emit) => emit(
        CreateState(
          question: state.question,
          answer: state.answer,
          pack: event.idPack,
          fakeAnswers: state.fakeAnswers,
        ),
      ),
    );
    on<AddFakeEvent>((event, emit) {
      final List<String> updatedFakes = List.from(state.fakeAnswers)
        ..add(event.fake);
      emit(
        CreateState(
          question: state.question,
          answer: state.answer,
          pack: state.pack,
          fakeAnswers: updatedFakes,
        ),
      );
    });
    on<UpdateFakeEvent>((event, emit) {
      final List<String> updatedFakes = List.from(state.fakeAnswers);
      if (event.index >= 0 && event.index < updatedFakes.length) {
        updatedFakes[event.index] = event.fake;
        emit(
          CreateState(
            question: state.question,
            answer: state.answer,
            pack: state.pack,
            fakeAnswers: updatedFakes,
          ),
        );
      }
    });
    on<CreateQzEvent>((event, emit) {
      if (state.pack.trim() != '' &&
          state.question.trim() != '' &&
          state.answer.trim() != '') {
        if (state.fakeAnswers.isNotEmpty) {
          if (!Parsering.allElementsHaveContent(state.fakeAnswers)) {
            print('Error: Some fake answers are empty.');
          } else {
            QzServices.createQz(
              state.pack,
              state.question,
              state.answer,
              state.fakeAnswers,
            );
            emit(
              CreateState(
                question: '',
                answer: '',
                pack: state.pack,
                fakeAnswers: [],
              ),
            );
          }
        } else {
          QzServices.createQz(state.pack, state.question, state.answer, []);
          emit(
            CreateState(
              question: '',
              answer: '',
              pack: state.pack,
              fakeAnswers: [],
            ),
          );
        }
      }
    });
  }
}
