import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/models/question_model.dart';
import 'package:acronymous_app/repository/acronyms_repository.dart';
import 'package:acronymous_app/services/flutter_tts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'listen_game_state.dart';

class ListenGamePageCubit extends Cubit<ListenGamePageState> {
  ListenGamePageCubit({
    required this.acronymsRepository,
  }) : super(ListenGamePageState());

  final AcronymsRepository acronymsRepository;

  Future<void> createGame(int quizLenght) async {
    emit(ListenGamePageState(status: Status.loading));

    try {
      final List<AcronymModel> results =
          await acronymsRepository.getRandomAcronyms(quizLenght);

      // there is an error in PinCodePackage
      int maxAcronymLenght = 0;
      for (var element in results) {
        if (maxAcronymLenght < element.acronymLettersList.length) {
          maxAcronymLenght = element.acronymLettersList.length;
        }
      }

      final int listenTaskLenght = maxAcronymLenght;

      speakText(results[0].acronymLetters);

      emit(state.copyWith(
        quizLenght: quizLenght,
        questions: results,
        listenTaskLenght: listenTaskLenght,
        status: Status.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: Status.error,
        errorMessage: 'ListenGameState ${error.toString()}',
      ));
    }
  }

  void checkAnswer(String answer) {
    final String currentQuestion =
        state.questions[state.currentQuestion].acronym.toUpperCase();
    List<GameAnswerModel> newAnswers = List.from(state.answers);

    bool isCorrect = false;

    debugPrint('answeredQuestions ${state.answeredQuestions}');
    debugPrint('quizLenght ${state.quizLenght}');

    if (state.answeredQuestions < state.quizLenght) {
      state.answeredQuestions = state.answeredQuestions + 1;

      if (!state.isLastQuestion) {
        state.currentQuestion = state.currentQuestion + 1;
      }

      if (currentQuestion == answer) {
        state.score = state.score + 1;
        isCorrect = true;
      }

      final quizAnswerModel =
          GameAnswerModel(currentQuestion, answer, isCorrect);

      newAnswers.add(quizAnswerModel);
    }
    if (!state.isLastQuestion) {
      speakText(state.questions[state.currentQuestion].acronymLetters);
    }

    emit(state.copyWith(
      answers: newAnswers,
      score: state.score,
      currentQuestion: state.currentQuestion,
      answeredQuestions: state.answeredQuestions,
    ));
  }

  void isLastQuestionChecker() {
    if (state.currentQuestion == state.quizLenght - 1) {
      state.isLastQuestion = true;
    }
    emit(state.copyWith(
      isLastQuestion: state.isLastQuestion,
    ));
  }

  void speakText(text) {
    ttsService.speakTTS(text);
  }
}
