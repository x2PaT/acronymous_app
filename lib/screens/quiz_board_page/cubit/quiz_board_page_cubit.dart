import 'package:acronymous_app/app/core/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'quiz_board_page_state.dart';

class QuizBoardPageCubit extends Cubit<QuizBoardPageState> {
  QuizBoardPageCubit() : super(QuizBoardPageState());

  final startQuizLenght = 8;

  final minQuizLen = 2;
  final maxQuizLen = 12;

  void start() {
    emit(QuizBoardPageState(
      status: Status.loading,
    ));

    emit(QuizBoardPageState(
      quizLenghtValue: startQuizLenght,
      status: Status.success,
    ));
  }

  void quizLenghtSubt() {
    if (state.quizLenghtValue <= minQuizLen) {
      return;
    } else {
      final int newValue = state.quizLenghtValue - 1;

      emit(QuizBoardPageState(
        quizLenghtValue: newValue,
        status: Status.success,
      ));
    }
  }

  void quizLenghtIncr() {
    if (state.quizLenghtValue >= maxQuizLen) {
      return;
    } else {
      final int newValue = state.quizLenghtValue + 1;

      emit(QuizBoardPageState(
        quizLenghtValue: newValue,
        status: Status.success,
      ));
    }
  }
}
