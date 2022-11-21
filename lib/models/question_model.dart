class QuizQuestionModel {
  QuizQuestionModel(this.questionText, this.optionsList);

  final String questionText;
  final List<QuizOptionModel> optionsList;

  String get questionLetters {
    // ABC >>> A, B, C
    return questionText.split('').join(', ');
  }
}

class QuizOptionModel {
  QuizOptionModel(this.optionText, this.isCorrect);

  final String optionText;
  final bool isCorrect;
}

class QuizAnswerModel {
  QuizAnswerModel(this.questionText, this.selectedOption);

  final String questionText;
  final QuizOptionModel selectedOption;
}
