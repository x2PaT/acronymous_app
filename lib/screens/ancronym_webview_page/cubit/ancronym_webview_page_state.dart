part of 'ancronym_webview_page_cubit.dart';

class AncronymWebviewPageState {
  AncronymWebviewPageState({
    this.internetStatus = false,
    this.status = Status.initial,
    this.errorMessage,
  });

  final bool internetStatus;
  final Status status;
  final String? errorMessage;
}
