part of 'quiz_board_page_cubit.dart';

class QuizBoardPageState {
  QuizBoardPageState({
    this.quizLenghtValue = 0,
    this.status = Status.initial,
    this.errorMessage,
  });
  final int quizLenghtValue;
  final Status status;
  final String? errorMessage;
}
