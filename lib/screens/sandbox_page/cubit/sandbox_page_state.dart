part of 'sandbox_page_cubit.dart';

class SandboxPageState {
  SandboxPageState({
    this.results = const [],
    this.wordsMode = false,
    this.status = Status.initial,
    this.errorMessage,
  });
  final bool wordsMode;
  final List<WordSandboxModel> results;
  final Status status;
  final String? errorMessage;

  SandboxPageState copyWith({
    bool? wordsMode,
    List<WordSandboxModel>? results,
    Status? status,
    String? errorMessage,
  }) {
    return SandboxPageState(
      wordsMode: wordsMode ?? this.wordsMode,
      results: results ?? this.results,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
