part of 'home_page_cubit.dart';

class HomePageState {
  HomePageState({
    this.quizLenghtValue = 0,
    this.status = Status.initial,
    this.errorMessage,
    this.randomAcronyms = const [],
  });

  final int quizLenghtValue;
  final Status status;
  final String? errorMessage;
  final List<AcronymModel> randomAcronyms;
}
