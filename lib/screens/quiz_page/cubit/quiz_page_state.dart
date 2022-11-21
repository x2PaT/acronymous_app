part of 'quiz_page_cubit.dart';

class QuizPageState {
  QuizPageState({
    this.questions = const [],
    this.answers = const [],
    this.quizLenght = 8,
    //
    this.selectedOption,
    this.currentQuestion = 0,
    this.score = 0,
    this.isLastQuestion = false,
    this.isOptionSelected = false,
    this.answeredQuestions = 0,
    //
    this.status = Status.initial,
    this.errorMessage,
  });

  final List<QuizQuestionModel> questions;
  final List<QuizAnswerModel> answers;
  final int quizLenght;

  QuizOptionModel? selectedOption;
  int currentQuestion;
  int score;
  bool isLastQuestion;
  bool isOptionSelected;
  int answeredQuestions;

  final Status status;
  final String? errorMessage;

  QuizPageState copyWith({
    List<QuizQuestionModel>? questions,
    List<QuizAnswerModel>? answers,
    int? quizLenght,
    QuizOptionModel? selectedOption,
    int? currentQuestion,
    int? score,
    bool? isLastQuestion,
    bool? isOptionSelected,
    int? answeredQuestions,
    Status? status,
    String? errorMessage,
  }) {
    return QuizPageState(
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      quizLenght: quizLenght ?? this.quizLenght,
      selectedOption: selectedOption ?? this.selectedOption,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      score: score ?? this.score,
      isLastQuestion: isLastQuestion ?? this.isLastQuestion,
      isOptionSelected: isOptionSelected ?? this.isOptionSelected,
      answeredQuestions: answeredQuestions ?? this.answeredQuestions,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
