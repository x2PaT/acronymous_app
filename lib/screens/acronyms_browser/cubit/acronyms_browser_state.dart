part of 'acronyms_browser_cubit.dart';

class AcronymsBrowserState {
  AcronymsBrowserState({
    this.results = const [],
    this.status = Status.initial,
    this.errorMessage,
  });

  final List<AcronymModel> results;
  final Status status;
  final String? errorMessage;
}
