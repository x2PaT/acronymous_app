import 'dart:io';

import 'package:acronymous_app/app/core/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'ancronym_webview_page_state.dart';

class AncronymWebviewPageCubit extends Cubit<AncronymWebviewPageState> {
  AncronymWebviewPageCubit() : super(AncronymWebviewPageState());

  Future<void> start() async {
    emit(
      AncronymWebviewPageState(
        status: Status.loading,
      ),
    );

    bool internetStatus = false;

    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internetStatus = true;
      } else {
        internetStatus = false;
      }
      emit(
        AncronymWebviewPageState(
          internetStatus: internetStatus,
          status: Status.success,
        ),
      );
    } catch (error) {
      emit(
        AncronymWebviewPageState(
          status: Status.error,
          errorMessage: 'AncronymWebviewPageState ${error.toString()}',
        ),
      );
    }
  }
}
