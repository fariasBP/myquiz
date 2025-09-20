class QzModel {
  static const String coll = 'qzs';

  String question;
  String answer;
  String packId;
  List<String> fake = [];

  QzModel({
    required this.question,
    required this.answer,
    required this.packId,
    required this.fake,
  });

  factory QzModel.fromJson(Map<String, dynamic> json) => QzModel(
    question: json['question'],
    answer: json['answer'],
    packId: json['packId'],
    fake: List<String>.from(json['fake'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'question': question,
    'answer': answer,
    'packId': packId,
    'fake': fake,
  };
}

class QzImport {
  final String question;
  final String answer;
  final List<String> fake;

  QzImport({required this.question, required this.answer, required this.fake});

  factory QzImport.fromJson(Map<String, dynamic> json) {
    return QzImport(
      question: json['question'] as String,
      answer: json['answer'] as String,
      fake: List<String>.from(json['fake'] as List),
    );
  }

  // Método para convertir a Map (opcional)
  Map<String, dynamic> toJson() {
    return {'question': question, 'answer': answer, 'fake': fake};
  }

  @override
  String toString() {
    return 'QzImport(question: $question, answer: $answer, fake: $fake)';
  }
}
