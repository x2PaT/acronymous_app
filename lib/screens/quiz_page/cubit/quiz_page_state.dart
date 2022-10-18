part of 'quiz_page_cubit.dart';

class QuizPageState {
  const QuizPageState({
    this.questions = const [],
    this.quizLenght = 8,
    //
    this.selectedAnswer,
    this.currentQuestion = 0,
    this.score = 0,
    this.isLastQuestion = false,
    this.isAnswerSelected = false,
    //
    this.status = Status.initial,
    this.errorMessage,
  });

  final List<QuestionModel> questions;
  final int quizLenght;

  final AnswerModel? selectedAnswer;
  final int currentQuestion;
  final int score;
  final bool isLastQuestion;
  final bool isAnswerSelected;

  final Status status;
  final String? errorMessage;
}
