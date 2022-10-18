part of 'acronyms_browser_cubit.dart';

class AcronymsBrowserState {
  AcronymsBrowserState({
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
