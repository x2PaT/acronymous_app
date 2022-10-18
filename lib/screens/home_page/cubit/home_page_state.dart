part of 'home_page_cubit.dart';

class HomePageState {
  HomePageState({
    this.quizLenghtValue = 0,
    this.randomAcronyms = const [],
    this.status = Status.initial,
    this.statusAcronymsList = Status.initial,
    this.errorMessage,
    this.errorMessageAcronymsList,
    this.alphabet = const [],
    this.errorMessageAlphabet,
    this.statusAlphabet = Status.initial,
  });

  final int quizLenghtValue;
  final Status status;
  final String? errorMessage;

  final Status statusAcronymsList;
  final String? errorMessageAcronymsList;
  final List<AcronymModel> randomAcronyms;

  final List<LetterModel> alphabet;
  final String? errorMessageAlphabet;
  final Status statusAlphabet;
}
