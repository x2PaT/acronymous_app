part of 'acronyms_page_cubit.dart';

class AcronymsPageState {
  AcronymsPageState({
    this.results = const [],
    this.searchResults = const [],
    this.status = Status.initial,
    this.errorMessage,
  });

  final List<AcronymModel> results;
  final List<AcronymModel> searchResults;
  final Status status;
  final String? errorMessage;
}
