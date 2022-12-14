import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/models/question_model.dart';
import 'package:acronymous_app/repository/questions_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'quiz_page_state.dart';

class QuizPageCubit extends Cubit<QuizPageState> {
  QuizPageCubit({
    required this.questionsRepository,
  }) : super(QuizPageState());

  final QuestionsRepository questionsRepository;

  Future<void> createQuiz(int quizLenght, String quizType) async {
    emit(QuizPageState());

    try {
      final result = await questionsRepository.getQuizQuestions(
        quizLenght,
        quizType,
      );
      emit(state.copyWith(
        quizLenght: quizLenght,
        questions: result,
        status: Status.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: Status.error,
        errorMessage: 'QuizPageState ${error.toString()}',
      ));
    }
  }

  void selectAnswer(AnswerModel answer) {
    emit(state.copyWith(
      isAnswerSelected: true,
      selectedAnswer: answer,
    ));
  }

  void checkAnswer({required AnswerModel? selectedAnswer}) {
    List<bool> newAnswers = List.from(state.answers);
    if (state.isAnswerSelected && state.answersCounter < state.quizLenght) {
      state.answersCounter = state.answersCounter + 1;

      if (!state.isLastQuestion) {
        state.currentQuestion = state.currentQuestion + 1;
      }
      if (selectedAnswer!.isCorrect) {
        state.score = state.score + 1;

        newAnswers.add(true);
      } else {
        newAnswers.add(false);
      }
    }

    emit(state.copyWith(
      isAnswerSelected: false,
      selectedAnswer: null,
      score: state.score,
      currentQuestion: state.currentQuestion,
      answersCounter: state.answersCounter,
      answers: newAnswers,
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
}
