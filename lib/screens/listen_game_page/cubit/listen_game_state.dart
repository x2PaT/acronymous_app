part of 'listen_game_cubit.dart';

class ListenGamePageState {
  ListenGamePageState(
      {this.questions = const [],
      this.answers = const [],
      this.quizLenght = 8,
      //
      this.selectedText,
      this.currentQuestion = 0,
      this.score = 0,
      this.isLastQuestion = false,
      this.isAnswerSelected = false,
      this.answeredQuestions = 0,
      this.listenTaskLenght = 0,
      //
      this.status = Status.initial,
      this.errorMessage});

  final List<GameQuestionModel> questions;
  final List<GameAnswerModel> answers;
  final int quizLenght;

  String? selectedText;
  int currentQuestion;
  int score;
  bool isLastQuestion;
  int answeredQuestions;
  bool isAnswerSelected;
  int listenTaskLenght;

  final Status status;
  final String? errorMessage;

  ListenGamePageState copyWith({
    List<GameQuestionModel>? questions,
    List<GameAnswerModel>? answers,
    int? quizLenght,
    int? listenTaskLenght,
    String? selectedText,
    int? currentQuestion,
    int? score,
    bool? isLastQuestion,
    int? answeredQuestions,
    Status? status,
    String? errorMessage,
  }) {
    return ListenGamePageState(
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      quizLenght: quizLenght ?? this.quizLenght,
      listenTaskLenght: listenTaskLenght ?? this.listenTaskLenght,
      selectedText: selectedText ?? this.selectedText,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      score: score ?? this.score,
      isLastQuestion: isLastQuestion ?? this.isLastQuestion,
      answeredQuestions: answeredQuestions ?? this.answeredQuestions,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
