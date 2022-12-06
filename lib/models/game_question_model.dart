class GameQuestionModel {
  GameQuestionModel(this.questionText);

  final String questionText;

  String get questionLetters {
    // ABC >>> A, B, C
    return questionText.split('').join(', ');
  }

  List<String> get questionLettersList {
    // ABC >>> A, B, C
    return questionText.split('');
  }
}

class GameAnswerModel {
  GameAnswerModel(this.questionText, this.selectedText);

  final String questionText;
  final String selectedText;

  bool get isCorrect {
    return questionText == selectedText;
  }
}
