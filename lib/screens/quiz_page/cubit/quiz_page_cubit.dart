import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/models/question_model.dart';
import 'package:acronymous_app/repository/questions_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'quiz_page_state.dart';

class QuizPageCubit extends Cubit<QuizPageState> {
  QuizPageCubit({
    required this.questionsRepository,
  }) : super(const QuizPageState());

  final QuestionsRepository questionsRepository;

  Future<void> createQuiz(int quizLenght) async {
    emit(
      const QuizPageState(
        status: Status.loading,
        //
        currentQuestion: 0,
        score: 0,
        isAnswerSelected: false,
        isLastQuestion: false,
        selectedAnswer: null,
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
        ),
      );
    } catch (error) {
      emit(
        QuizPageState(
          status: Status.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  // pressNextButton() {
  //   if (!state.isAnswerSelected) {
  //   } else {
  //     if (state.currentQuestion == state.quizLenght - 1) {
  //       // do things for last question
  //       var isCorrect = state.selectedAnswer!.isCorrect;

  //       emit(
  //         QuizPageState(
  //           score: isCorrect ? state.score + 1 : state.score,
  //           currentQuestion: state.currentQuestion + 1,
  //           isAnswerSelected: false,
  //           isLastQuestion: true,
  //           selectedAnswer: null,
  //         ),
  //       );
  //     } else {
  //       // do things for not last question
  //       var isCorrect = state.selectedAnswer!.isCorrect;

  //       emit(
  //         QuizPageState(
  //           score: isCorrect ? state.score + 1 : state.score,
  //           currentQuestion: state.currentQuestion + 1,
  //           isAnswerSelected: false,
  //           isLastQuestion: false,
  //           selectedAnswer: null,
  //         ),
  //       );
  //     }
  //   }
  // }
}
