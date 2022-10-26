part of 'home_page_cubit.dart';

class HomePageState {
  HomePageState({
    this.quizLenghtValue = 0,
    this.alphabet = const [],
    this.randomAcronymsList = const [],
    this.errorMessage,
    this.errorMessageAlphabet,
    this.errorMessageAcronymsList,
    this.status = Status.initial,
    this.statusAlphabet = Status.initial,
    this.statusAcronymsList = Status.initial,
  });

  final int quizLenghtValue;
  final List<LetterModel> alphabet;
  final List<AcronymModel> randomAcronymsList;

  final String? errorMessage;
  final String? errorMessageAlphabet;
  final String? errorMessageAcronymsList;

  final Status status;
  final Status statusAlphabet;
  final Status statusAcronymsList;

  HomePageState copyWith({
    int? quizLenghtValue,
    List<LetterModel>? alphabet,
    List<AcronymModel>? randomAcronymsList,
    String? errorMessage,
    String? errorMessageAlphabet,
    String? errorMessageAcronymsList,
    Status? status,
    Status? statusAlphabet,
    Status? statusAcronymsList,
  }) {
    return HomePageState(
      quizLenghtValue: quizLenghtValue ?? this.quizLenghtValue,
      alphabet: alphabet ?? this.alphabet,
      randomAcronymsList: randomAcronymsList ?? this.randomAcronymsList,
      errorMessage: errorMessage ?? this.errorMessage,
      errorMessageAlphabet: errorMessageAlphabet ?? this.errorMessageAlphabet,
      errorMessageAcronymsList:
          errorMessageAcronymsList ?? this.errorMessageAcronymsList,
      status: status ?? this.status,
      statusAlphabet: statusAlphabet ?? this.statusAlphabet,
      statusAcronymsList: statusAcronymsList ?? this.statusAcronymsList,
    );
  }
}
