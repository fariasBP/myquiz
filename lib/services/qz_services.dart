import 'package:loon/loon.dart';
import 'package:myquiz/prefs/qz_model.dart';

class QzServices {
  static void createQz(
    String packId,
    String question,
    String answer,
    List<String> fakes,
  ) {
    final String id = uuid.v4();
    Loon.collection<QzModel>(
          QzModel.coll,
          fromJson: QzModel.fromJson,
          toJson: (qz) => qz.toJson(),
        )
        .doc(id)
        .create(
          QzModel(
            packId: packId,
            question: question,
            answer: answer,
            fake: fakes,
          ),
        );
  }

  static List<DocumentSnapshot<QzModel>> getQzs(String packId) {
    return Loon.collection<QzModel>(
      QzModel.coll,
      fromJson: QzModel.fromJson,
      toJson: (qz) => qz.toJson(),
    ).where((snap) => (snap.data.packId == packId)).get();
  }
}
