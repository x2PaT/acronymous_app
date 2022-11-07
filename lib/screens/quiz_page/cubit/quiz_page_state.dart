part of 'quiz_page_cubit.dart';

class QuizPageState {
  QuizPageState({
    this.questions = const [],
    this.answers = const [],
    this.quizLenght = 8,
    //
    this.selectedAnswer,
    this.currentQuestion = 0,
    this.score = 0,
    this.isLastQuestion = false,
    this.isAnswerSelected = false,
    this.answersCounter = 0,
    //
    this.status = Status.initial,
    this.errorMessage,
  });

  final List<QuestionModel> questions;
  final List<bool> answers;
  final int quizLenght;

  AnswerModel? selectedAnswer;
  int currentQuestion;
  int score;
  bool isLastQuestion;
  bool isAnswerSelected;
  int answersCounter;

  final Status status;
  final String? errorMessage;

  QuizPageState copyWith({
    List<QuestionModel>? questions,
    List<bool>? answers,
    int? quizLenght,
    AnswerModel? selectedAnswer,
    int? currentQuestion,
    int? score,
    bool? isLastQuestion,
    bool? isAnswerSelected,
    int? answersCounter,
    Status? status,
    String? errorMessage,
  }) {
    return QuizPageState(
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      quizLenght: quizLenght ?? this.quizLenght,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      score: score ?? this.score,
      isLastQuestion: isLastQuestion ?? this.isLastQuestion,
      isAnswerSelected: isAnswerSelected ?? this.isAnswerSelected,
      answersCounter: answersCounter ?? this.answersCounter,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
