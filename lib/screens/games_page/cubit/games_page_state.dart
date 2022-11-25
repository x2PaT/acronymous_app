part of 'games_page_cubit.dart';

class GamesPageState {
  GamesPageState({
    this.quizLenghtValue = 0,
    this.status = Status.initial,
    this.errorMessage,
  });
  final int quizLenghtValue;
  final Status status;
  final String? errorMessage;
}
