import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loon/loon.dart';
import 'package:myquiz/prefs/qz_model.dart';
import 'package:myquiz/services/qz_services.dart';

part 'qz_state.dart';
part 'qz_event.dart';

class QzBloc extends Bloc<QzEvent, QzState> {
  QzBloc() : super(QzState(packId: '', qzs: [])) {
    on<LoadQzsEvent>((event, emit) {
      emit(QzState(packId: event.packId, qzs: QzServices.getQzs(event.packId)));
    });
  }
}
