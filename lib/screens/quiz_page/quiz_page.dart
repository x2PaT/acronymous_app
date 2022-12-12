// ignore_for_file: deprecated_member_use

import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/app/injectable.dart';
import 'package:acronymous_app/app/utils.dart';
import 'package:acronymous_app/models/quiz_question_model.dart';
import 'package:acronymous_app/screens/quiz_page/cubit/quiz_page_cubit.dart';
import 'package:acronymous_app/services/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@override
class QuizPage extends StatelessWidget {
  const QuizPage({
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
                    if (state.answeredQuestions == 0 ||
                        state.answeredQuestions == state.quizLenght) {
                      return true;
                    } else {
                      final doPop = await showPopDialog(context);

                      return doPop ?? false;
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Question ${state.currentQuestion + 1}/${state.quizLenght}',
                                    style: const TextStyle(fontSize: 25),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (var answer in state.answers) ...[
                                    answerIconConstructor(
                                        answer.selectedOption.isCorrect)
                                  ],
                                  for (var i = 0;
                                      i <
                                          (state.quizLenght -
                                              state.answers.length);
                                      i++) ...[
                                    const Icon(
                                      Icons.check_box,
                                      color: Colors.grey,
                                    )
                                  ]
                                ],
                              ),
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
                                primary: state.isOptionSelected
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
                                Icon(
                                  Icons.play_circle_outline,
                                  size: 32,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Column(
                          children:
                              state.questions[state.currentQuestion].optionsList
                                  .map((option) => OptionButton(
                                        option: option,
                                        state: state,
                                      ))
                                  .toList(),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            final String questionLetters = state
                                .questions[state.currentQuestion].questionText;

                            if (state.answeredQuestions == state.quizLenght) {
                              showResultsDialog(context, state);
                            } else if (state.isOptionSelected) {
                              BlocProvider.of<QuizPageCubit>(context)
                                  .checkAnswer(
                                selectedOption: state.selectedOption!,
                              );
                              modalBottomSheetOnCheckAnswer(
                                context,
                                state.selectedOption!.isCorrect,
                                questionLetters,
                                state,
                              );
                            } else {
                              showSnackBar(context, 'Select answer');
                            }
                          },
                          child: Text(
                            state.isLastQuestion
                                ? 'Show Results'
                                : 'Next Question',
                          ),
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

  void modalBottomSheetOnCheckAnswer(
    BuildContext context,
    isCorrect,
    questionLetters,
    QuizPageState state,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (_) {
        return Wrap(
          children: [
            WillPopScope(
              onWillPop: () async {
                final doPop = await showPopDialog(context);

                return doPop ?? false;
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(isCorrect
                            ? Icons.trending_up
                            : Icons.trending_down),
                        const SizedBox(width: 10),
                        Text(
                          isCorrect ? 'Correct answer' : 'Wrong answer',
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    isCorrect
                        ? const SizedBox()
                        : Column(
                            children: [
                              const Text('Correct answer is:'),
                              Text(questionLetters),
                            ],
                          ),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<QuizPageCubit>(context).nextQuestion();

                        Navigator.of(context).pop();
                      },
                      child: const Text('Next Question'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Icon answerIconConstructor(bool answer) {
    if (answer) {
      return const Icon(Icons.check_box, color: Colors.green);
    } else {
      return const Icon(Icons.check_box, color: Colors.red);
    }
  }

  Future<bool?> showPopDialog(BuildContext contextPass) async {
    return showDialog<bool>(
      context: contextPass,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('You will lost quiz progress.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/quiz',
                  arguments: [quizLenght, quizType]);
            },
            child: const Text("Restart"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Finish game"),
          ),
        ],
      ),
    );
  }

  Future<void> showResultsDialog(
      BuildContext context, QuizPageState state) async {
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
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/quiz',
                  arguments: [quizLenght, quizType]);
            },
            child: const Text('Play again!'),
          )
        ],
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  const OptionButton({Key? key, required this.option, required this.state})
      : super(key: key);
  final QuizPageState state;
  final QuizOptionModel option;

  @override
  Widget build(BuildContext context) {
    bool isSelected = option == state.selectedOption;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: isSelected
                ? Colors.orangeAccent
                : state.isOptionSelected
                    ? Colors.grey.shade200
                    : Colors.white,
            onPrimary: isSelected ? Colors.white : Colors.black,
            shape: const StadiumBorder(),
          ),
          onPressed: () {
            BlocProvider.of<QuizPageCubit>(context).selectOption(option);
          },
          child: Text(option.optionText)),
    );
  }
}
