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

  void selectOption(QuizOptionModel option) {
    emit(state.copyWith(
      isOptionSelected: true,
      selectedOption: option,
    ));
  }

  void checkAnswer({required QuizOptionModel selectedOption}) {
    List<QuizAnswerModel> newAnswers = List.from(state.answers);

    final quizAnswerModel = QuizAnswerModel(
      state.questions[state.currentQuestion].questionText,
      selectedOption,
    );

    newAnswers.add(quizAnswerModel);

    if (state.isOptionSelected && state.answeredQuestions < state.quizLenght) {
      state.answeredQuestions = state.answeredQuestions + 1;

      if (!state.isLastQuestion) {
        state.currentQuestion = state.currentQuestion + 1;
      }

      if (selectedOption.isCorrect) {
        state.score = state.score + 1;
      }
    }

    emit(state.copyWith(
      answers: newAnswers,
      isOptionSelected: false,
      selectedOption: null,
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
}
