import 'package:bloc/bloc.dart';
import 'package:loon/loon.dart';
import 'package:myquiz/prefs/pack_model.dart';
import 'package:myquiz/services/pack_services.dart';

part 'pack_state.dart';
part 'pack_event.dart';

class PackBloc extends Bloc<PackEvent, PackState> {
  PackBloc() : super(PackState(packs: PackServices.getPacks())) {
    on<CreatePackEvent>((event, emit) {
      PackServices.createPack(event.name, event.description);
      emit(PackState(packs: PackServices.getPacks()));
    });
  }
}
