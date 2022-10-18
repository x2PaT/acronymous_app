class QuestionModel {
  QuestionModel(this.questionText, this.answersList);

  final String questionText;
  final List<AnswerModel> answersList;

  String get questionLetters {
    // ABC >>> A, B, C
    final String splitToLetters = '${questionText.split('').map((e) => e)}';

    return splitToLetters;
  }
}

class AnswerModel {
  AnswerModel(this.answerText, this.isCorrect);

  final String answerText;
  final bool isCorrect;
}
