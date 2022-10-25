import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/app/drawer.dart';
import 'package:acronymous_app/models/question_model.dart';
import 'package:acronymous_app/repository/acronyms_repository.dart';
import 'package:acronymous_app/repository/questions_repository.dart';
import 'package:acronymous_app/screens/quiz_page/cubit/quiz_page_cubit.dart';
import 'package:acronymous_app/services/database_helper.dart';
import 'package:acronymous_app/services/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@override
class AcronymsQuizPage extends StatelessWidget {
  const AcronymsQuizPage({Key? key, required this.quizLenght})
      : super(key: key);

  final int quizLenght;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Acronymous Quiz'),
      ),
      drawer: const DrawerMaster(
        selectedElement: DrawerElements.home,
      ),
      body: BlocProvider(
        create: (context) {
          return QuizPageCubit(
            questionsRepository: QuestionsRepository(
              acronymsRepository: AcronymsRepository(
                databaseHelper: DatabaseHelper(),
              ),
            ),
          )..createQuiz(quizLenght);
        },
        child: BlocBuilder<QuizPageCubit, QuizPageState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.initial:
                return const Center(
                  child: Text('Initial State'),
                );
              case Status.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case Status.error:
                return Center(
                  child: Text(
                    state.errorMessage ?? 'Unkown error',
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                );
              case Status.success:
                return Container(
                  margin: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Question ${state.currentQuestion + 1}/${state.quizLenght}',
                              style: const TextStyle(fontSize: 25),
                            ),
                            Text(state.score.toString()),
                          ],
                        ),
                      ),
                      const Divider(
                        endIndent: 15,
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              primary: state.isAnswerSelected
                                  ? Colors.grey.shade500
                                  : Colors.orangeAccent),
                          onPressed: () {
                            ttsService.speakTTS(state
                                .questions[state.currentQuestion]
                                .questionLetters);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(state.questions[state.currentQuestion]
                                  .questionLetters
                                  .toString()),
                              const Text(
                                'PLAY',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Icon(Icons.play_circle_outline),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Column(
                        children: state
                            .questions[state.currentQuestion].answersList
                            .map((answer) =>
                                AnswerButton(answer: answer, state: state))
                            .toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<QuizPageCubit>(context)
                                  .checkAnswer(
                                      selectedAnswer: state.selectedAnswer);

                              if (state.isLastQuestion) {
                                showResultsDialog(context, state);
                              }
                              BlocProvider.of<QuizPageCubit>(context)
                                  .isLastQuestionChecker();
                            },
                            child: Text(
                                state.isLastQuestion ? 'Show Results' : 'Next'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  Future<void> showResultsDialog(BuildContext context, QuizPageState state) {
    final mark = state.score / state.quizLenght;
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: SizedBox(
          height: 200,
          child: Column(
            children: [
              Text(
                'You answered correctly on ${state.score} from ${state.quizLenght} questions',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22),
              ),
              Text(mark > 0.6 ? 'Great result' : 'You could do better'),
            ],
          ),
        ),
        title: const Text('Quiz Result'),
        actions: [
          TextButton(
            onPressed: () {
              BlocProvider.of<QuizPageCubit>(context).createQuiz(quizLenght);
              Navigator.of(context).pop();
            },
            child: const Text('Play again!'),
          )
        ],
      ),
    );
  }
}

class AnswerButton extends StatelessWidget {
  const AnswerButton({Key? key, required this.answer, required this.state})
      : super(key: key);
  final QuizPageState state;
  final AnswerModel answer;

  @override
  Widget build(BuildContext context) {
    bool isSelected = answer == state.selectedAnswer;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          primary: isSelected
              ? Colors.orangeAccent
              : state.isAnswerSelected
                  ? Colors.grey.shade200
                  : Colors.white,
          onPrimary: isSelected ? Colors.white : Colors.black,
        ),
        onPressed: () {
          BlocProvider.of<QuizPageCubit>(context).selectAnswer(answer);
        },
        child: Text(answer.answerText),
      ),
    );
  }
}
