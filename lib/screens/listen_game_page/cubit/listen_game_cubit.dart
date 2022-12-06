import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/models/game_question_model.dart';
import 'package:acronymous_app/repository/questions_repository.dart';
import 'package:acronymous_app/services/flutter_tts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'listen_game_state.dart';

class ListenGamePageCubit extends Cubit<ListenGamePageState> {
  ListenGamePageCubit({
    required this.questionsRepository,
  }) : super(ListenGamePageState());

  final QuestionsRepository questionsRepository;

  Future<void> createGame(int gameLenght, int wordLenght) async {
    emit(ListenGamePageState(status: Status.loading));
    try {
      final List<GameQuestionModel> results = await questionsRepository
          .createRandomLettersGameQuestions(gameLenght, wordLenght);

      speakText(results[0].questionLetters);

      emit(state.copyWith(
        quizLenght: gameLenght,
        questions: results,
        listenTaskLenght: wordLenght,
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
        state.questions[state.currentQuestion].questionText.toUpperCase();
    List<GameAnswerModel> newAnswers = List.from(state.answers);

    debugPrint('answeredQuestions ${state.answeredQuestions}');
    debugPrint('quizLenght ${state.quizLenght}');

    if (state.answeredQuestions < state.quizLenght) {
      state.answeredQuestions = state.answeredQuestions + 1;

      if (!state.isLastQuestion) {
        state.currentQuestion = state.currentQuestion + 1;
      }

      if (currentQuestion == answer) {
        state.score = state.score + 1;
      }

      final quizAnswerModel = GameAnswerModel(currentQuestion, answer);
      newAnswers.add(quizAnswerModel);
    }
    if (!state.isLastQuestion) {
      speakText(state.questions[state.currentQuestion].questionLetters);
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
