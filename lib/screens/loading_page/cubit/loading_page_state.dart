part of 'loading_page_cubit.dart';

class LoadingPageState {
  LoadingPageState({
    this.doneLoading = false,
    this.isFirstRun = false,
    this.internetConnection = false,
    this.status = Status.initial,
    this.errorMessage,
  });

  bool internetConnection;
  bool isFirstRun;
  bool doneLoading;
  Status status;
  final String? errorMessage;

  LoadingPageState copyWith({
    bool? doneLoading,
    bool? isFirstRun,
    bool? internetConnection,
    Status? status,
    String? errorMessage,
  }) {
    return LoadingPageState(
      doneLoading: doneLoading ?? this.doneLoading,
      isFirstRun: isFirstRun ?? this.isFirstRun,
      internetConnection: internetConnection ?? this.internetConnection,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
