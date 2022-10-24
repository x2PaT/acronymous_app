class QuestionModel {
  QuestionModel(this.questionText, this.answersList);

  final String questionText;
  final List<AnswerModel> answersList;

  String get questionLetters {
    // ABC >>> A, B, C
    return questionText.split('').join(', ');
  }
}

class AnswerModel {
  AnswerModel(this.answerText, this.isCorrect);

  final String answerText;
  final bool isCorrect;
}
