import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/app/injection_container.dart';
import 'package:acronymous_app/models/question_model.dart';
import 'package:acronymous_app/screens/quiz_page/cubit/quiz_page_cubit.dart';
import 'package:acronymous_app/services/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@override
class AcronymsQuizPage extends StatelessWidget {
  const AcronymsQuizPage({
    Key? key,
    required this.quizLenght,
    required this.quizType,
  }) : super(key: key);

  final int quizLenght;
  final String quizType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Acronymous Quiz'),
      ),
      body: BlocProvider<QuizPageCubit>(
        create: (context) {
          return getIt<QuizPageCubit>()..createQuiz(quizLenght, quizType);
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
                    state.errorMessage ?? 'QuizPageCubit Unkown error',
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                );
              case Status.success:
                return WillPopScope(
                  onWillPop: () async {
                    if (state.answersCounter != state.quizLenght) {
                      final doPop = await showPopDialog(context);

                      return doPop ?? false;
                    } else {
                      return true;
                    }
                  },
                  child: Container(
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
                                backgroundColor: state.isAnswerSelected
                                    ? Colors.grey.shade500
                                    : Colors.orangeAccent),
                            onPressed: () {
                              ttsService.speakTTS(state
                                  .questions[state.currentQuestion]
                                  .questionLetters);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Text(
                                  'PLAY',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Icon(Icons.play_circle_outline),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Column(
                          children:
                              state.questions[state.currentQuestion].answersList
                                  .map((answer) => AnswerButton(
                                        answer: answer,
                                        state: state,
                                      ))
                                  .toList(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (!state.isAnswerSelected) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Select answer!',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }
                                BlocProvider.of<QuizPageCubit>(context)
                                    .checkAnswer(
                                  selectedAnswer: state.selectedAnswer,
                                );
                                if (state.answersCounter == state.quizLenght) {
                                  showResultsDialog(context, state);
                                }
                                BlocProvider.of<QuizPageCubit>(context)
                                    .isLastQuestionChecker();
                              },
                              child: Text(
                                state.isLastQuestion ? 'Show Results' : 'Next',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  Future<bool?> showPopDialog(BuildContext contextPass) async {
    return showDialog<bool>(
      context: contextPass,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('You will lost quiz progress'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              BlocProvider.of<QuizPageCubit>(contextPass)
                  .createQuiz(quizLenght, quizType);
            },
            child: const Text("START AGAIN"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("NO"),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("YES"),
          ),
        ],
      ),
    );
  }

  Future<void> showResultsDialog(BuildContext context, QuizPageState state) {
    final mark = state.score / state.quizLenght;
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(child: Text('Quiz Result')),
        backgroundColor: Colors.grey.shade300,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: SizedBox(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Answered correctly on ${state.score} from ${state.quizLenght} questions.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 25),
              Text(mark > 0.6
                  ? 'Great result. You are the best!!'
                  : 'You could do better... try again :) '),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              BlocProvider.of<QuizPageCubit>(context).createQuiz(
                quizLenght,
                quizType,
              );
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
          foregroundColor: isSelected ? Colors.white : Colors.black,
          backgroundColor: isSelected
              ? Colors.orangeAccent
              : state.isAnswerSelected
                  ? Colors.grey.shade200
                  : Colors.white,
          shape: const StadiumBorder(),
        ),
        onPressed: () {
          BlocProvider.of<QuizPageCubit>(context).selectAnswer(answer);
        },
        child: Text(answer.answerText),
      ),
    );
  }
}
