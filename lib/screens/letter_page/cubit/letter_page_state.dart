part of 'letter_page_cubit.dart';

class LetterPageState {
  LetterPageState({
   required this.letterModel,
    this.acronymsWithLetter = const [],
    this.status = Status.initial,
    this.errorMessage,
  });

  final LetterModel? letterModel;
  final List<AcronymModel> acronymsWithLetter;
  final Status status;
  final String? errorMessage;
}
