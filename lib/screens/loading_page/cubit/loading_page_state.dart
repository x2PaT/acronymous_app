part of 'loading_page_cubit.dart';

class LoadingPageState {
  LoadingPageState({
    this.doneLoading = false,
    this.status = Status.initial,
    this.errorMessage,
  });

  bool doneLoading;
  Status status;
  final String? errorMessage;

  LoadingPageState copyWith({
    bool? doneLoading,
    Status? status,
    String? errorMessage,
  }) {
    return LoadingPageState(
      doneLoading: doneLoading ?? this.doneLoading,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
