part of 'play_bloc.dart';

class PlayState {
  final String packId;
  final List<DocumentSnapshot<QzModel>> qzs;
  final List<String> options;
  final List<DocumentSnapshot<QzModel>> fails;
  final int currentIndex;
  final bool show;

  PlayState({
    required this.packId,
    required this.qzs,
    required this.options,
    required this.currentIndex,
    required this.show,
    required this.fails,
  });
}
