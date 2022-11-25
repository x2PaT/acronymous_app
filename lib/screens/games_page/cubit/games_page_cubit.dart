import 'package:acronymous_app/app/core/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'games_page_state.dart';

class GamesPageCubit extends Cubit<GamesPageState> {
  GamesPageCubit() : super(GamesPageState());

  final startQuizLenght = 8;

  final minQuizLen = 2;
  final maxQuizLen = 12;

  void start() {
    emit(GamesPageState(
      status: Status.loading,
    ));

    emit(GamesPageState(
      quizLenghtValue: startQuizLenght,
      status: Status.success,
    ));
  }

  void quizLenghtSubt() {
    if (state.quizLenghtValue <= minQuizLen) {
      return;
    } else {
      final int newValue = state.quizLenghtValue - 1;

      emit(GamesPageState(
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

      emit(GamesPageState(
        quizLenghtValue: newValue,
        status: Status.success,
      ));
    }
  }
}
