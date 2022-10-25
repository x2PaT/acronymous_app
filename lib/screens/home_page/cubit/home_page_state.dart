part of 'home_page_cubit.dart';

class HomePageState {
  HomePageState({
    this.quizLenghtValue = 0,
    this.status = Status.initial,
    this.errorMessage,
    this.randomAcronymsList = const [],
    this.statusAcronymsList = Status.initial,
    this.errorMessageAcronymsList,
    this.alphabet = const [],
    this.statusAlphabet = Status.initial,
    this.errorMessageAlphabet,
    this.internetStatus = false,
  });
  final bool internetStatus;

  final int quizLenghtValue;
  final Status status;
  final String? errorMessage;

  final Status statusAcronymsList;
  final String? errorMessageAcronymsList;
  final List<AcronymModel> randomAcronymsList;

  final List<LetterModel> alphabet;
  final String? errorMessageAlphabet;
  final Status statusAlphabet;

  HomePageState copyWith({
    bool? internetStatus,
    int? quizLenghtValue,
    Status? status,
    String? errorMessage,
    Status? statusAcronymsList,
    String? errorMessageAcronymsList,
    List<AcronymModel>? randomAcronymsList,
    List<LetterModel>? alphabet,
    String? errorMessageAlphabet,
    Status? statusAlphabet,
  }) {
    return HomePageState(
      internetStatus: internetStatus ?? this.internetStatus,
      randomAcronymsList: randomAcronymsList ?? this.randomAcronymsList,
      quizLenghtValue: quizLenghtValue ?? this.quizLenghtValue,
      alphabet: alphabet ?? this.alphabet,
      status: status ?? this.status,
      statusAcronymsList: statusAcronymsList ?? this.statusAcronymsList,
      statusAlphabet: statusAlphabet ?? this.statusAlphabet,
    );
  }
}
