part of 'alphabet_page_cubit.dart';

class AlphabetPageState {
  AlphabetPageState({
    this.results = const [],
    this.status = Status.initial,
    this.errorMessage,
  });

  final List<LetterModel> results;
  final Status status;
  final String? errorMessage;
}
