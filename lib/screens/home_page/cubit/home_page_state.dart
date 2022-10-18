part of 'home_page_cubit.dart';

class HomePageState {
  HomePageState({
    this.quizLenghtValue = 0,
    this.randomAcronyms = const [],
    this.status = Status.initial,
    this.statusAcronymsList = Status.initial,
    this.errorMessage,
    this.errorMessageAcronymsList,
  });

  final int quizLenghtValue;
  final Status status;
  final Status statusAcronymsList;
  final String? errorMessage;
  final String? errorMessageAcronymsList;
  final List<AcronymModel> randomAcronyms;
}
