part of 'quiz_page_cubit.dart';

class QuizPageState {
  QuizPageState({
    this.questions = const [],
    this.quizLenght = 8,
    //
    this.selectedAnswer,
    this.currentQuestion = 0,
    this.score = 0,
    this.isLastQuestion = false,
    this.isAnswerSelected = false,
    this.answersCounter = 0,
    //
    this.status = Status.initial,
    this.errorMessage,
  });

  final List<QuestionModel> questions;
  final int quizLenght;

  AnswerModel? selectedAnswer;
  int currentQuestion;
  int score;
  bool isLastQuestion;
  bool isAnswerSelected;
  int answersCounter;

  final Status status;
  final String? errorMessage;
}
