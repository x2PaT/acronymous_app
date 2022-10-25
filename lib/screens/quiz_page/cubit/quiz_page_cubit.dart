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

  Future<void> createQuiz(int quizLenght) async {
    emit(
      QuizPageState(
        status: Status.loading,
        //
        currentQuestion: 0,
        score: 0,
        isAnswerSelected: false,
        isLastQuestion: false,
        selectedAnswer: null,
        answersCounter: 0,
      ),
    );
    try {
      final result = await questionsRepository.getQuizQuestions(quizLenght);

      emit(
        QuizPageState(
          quizLenght: quizLenght,
          questions: result,
          status: Status.success,
          //
          currentQuestion: state.currentQuestion,
          score: state.score,
          isAnswerSelected: state.isAnswerSelected,
          isLastQuestion: state.isLastQuestion,
          selectedAnswer: state.selectedAnswer,
          answersCounter: state.answersCounter,
        ),
      );
    } catch (error) {
      emit(
        QuizPageState(
          status: Status.error,
          errorMessage: 'QuizPageState ${error.toString()}',
        ),
      );
    }
  }

  void selectAnswer(AnswerModel answer) {
    emit(QuizPageState(
      quizLenght: state.quizLenght,
      questions: state.questions,
      status: Status.success,
      //
      currentQuestion: state.currentQuestion,
      score: state.score,
      isAnswerSelected: true,
      isLastQuestion: state.isLastQuestion,
      selectedAnswer: answer,
      answersCounter: state.answersCounter,
    ));
  }

  void checkAnswer({required AnswerModel? selectedAnswer}) {
    if (state.isAnswerSelected && state.answersCounter < state.quizLenght) {
      state.answersCounter = state.answersCounter + 1;

      if (!state.isLastQuestion) {
        state.currentQuestion = state.currentQuestion + 1;
      }
      if (selectedAnswer!.isCorrect) {
        state.score = state.score + 1;
      }
    }

    emit(
      QuizPageState(
        quizLenght: state.quizLenght,
        questions: state.questions,
        status: Status.success,
        //
        currentQuestion: state.currentQuestion,
        score: state.score,
        isAnswerSelected: false,
        isLastQuestion: state.isLastQuestion,
        selectedAnswer: null,
        answersCounter: state.answersCounter,
      ),
    );
  }

  void isLastQuestionChecker() {
    if (state.currentQuestion == state.quizLenght - 1) {
      state.isLastQuestion = true;
    }

    emit(
      QuizPageState(
        quizLenght: state.quizLenght,
        questions: state.questions,
        status: Status.success,
        //
        currentQuestion: state.currentQuestion,
        score: state.score,
        isAnswerSelected: state.isAnswerSelected,
        isLastQuestion: state.isLastQuestion,
        selectedAnswer: state.selectedAnswer,
        answersCounter: state.answersCounter,
      ),
    );
  }
}
