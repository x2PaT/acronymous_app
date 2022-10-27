part of 'names_page_cubit.dart';

class NamesPageState {
  NamesPageState({
    this.results = const [],
    this.searchResults = const [],
    this.status = Status.initial,
    this.errorMessage,
  });

  final List<NameModel> results;
  final List<NameModel> searchResults;
  final Status status;
  final String? errorMessage;
}
