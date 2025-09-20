part of 'qz_bloc.dart';

class QzState {
  final String packId;
  final List<DocumentSnapshot<QzModel>> qzs;
  QzState({required this.packId, required this.qzs});
}
