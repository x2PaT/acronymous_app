import 'dart:async';

import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/app/injectable.dart';
import 'package:acronymous_app/app/utils.dart';
import 'package:acronymous_app/screens/listen_game_page/cubit/listen_game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ListenGame extends StatefulWidget {
  const ListenGame({
    Key? key,
    required this.gameLenght,
    required this.wordLenght,
  }) : super(key: key);

  final int gameLenght;
  final int wordLenght;

  @override
  State<ListenGame> createState() => _ListenGameState();
}

class _ListenGameState extends State<ListenGame> {
  TextEditingController textEditingController = TextEditingController();

  StreamController<ErrorAnimationType>? errorController;
  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();

    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listen and Write Game'),
      ),
      body: BlocProvider(
        create: (context) => getIt<ListenGamePageCubit>()
          ..createGame(widget.gameLenght, widget.wordLenght),
        child: BlocBuilder<ListenGamePageCubit, ListenGamePageState>(
            builder: (context, state) {
          switch (state.status) {
            case Status.initial:
              return const Center(
                child: Text('Initial state'),
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
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(24),
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
                              answerIconConstructor(answer.isCorrect)
                            ],
                            for (var i = 0;
                                i < (state.quizLenght - state.answers.length);
                                i++) ...[
                              const Icon(
                                Icons.check_box,
                                color: Colors.grey,
                              )
                            ],
                          ],
                        ),
                        const Divider(
                          indent: 15,
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
                                backgroundColor: Colors.orangeAccent),
                            onPressed: () {
                              BlocProvider.of<ListenGamePageCubit>(context)
                                  .speakText(state
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
                        const SizedBox(height: 25.0),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: PinCodeTextField(
                            autoDismissKeyboard: false,
                            appContext: context,
                            autoFocus: true,
                            controller: textEditingController,
                            cursorColor: Colors.black,
                            length: state.listenTaskLenght,
                            mainAxisAlignment: MainAxisAlignment.center,
                            errorAnimationController: errorController,
                            pastedTextStyle: TextStyle(
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                            animationType: AnimationType.fade,
                            boxShadows: const [
                              BoxShadow(
                                offset: Offset(0, 3),
                                color: Colors.black12,
                                blurRadius: 10,
                              )
                            ],
                            onChanged: (value) {},
                            pinTheme: PinTheme(
                              fieldOuterPadding: const EdgeInsets.all(3),
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 50,
                              fieldWidth: 35,
                              activeFillColor: Colors.white,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                final String answerLetters =
                                    textEditingController.text.toUpperCase();
                                final String questionLetters = state
                                    .questions[state.currentQuestion]
                                    .questionText;

                                if (state.answeredQuestions ==
                                    state.quizLenght) {
                                  showResultsDialog(context, state);
                                } else if (answerLetters.length ==
                                    questionLetters.length) {
                                  //check answer
                                  BlocProvider.of<ListenGamePageCubit>(context)
                                      .checkAnswer(answerLetters);

                                  textEditingController.clear();

                                  if (state.answeredQuestions ==
                                      state.quizLenght) {
                                    showResultsDialog(context, state);
                                  }
                                  BlocProvider.of<ListenGamePageCubit>(context)
                                      .isLastQuestionChecker();
                                } else {
                                  showSnackBar(context, 'Select answer!');
                                  errorController!
                                      .add(ErrorAnimationType.shake);
                                }
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
                ),
              );
          }
        }),
      ),
    );
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
              Navigator.of(context).pushReplacementNamed('/listenGame',
                  arguments: widget.gameLenght);
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

  Future<void> showResultsDialog(
      BuildContext context, ListenGamePageState state) async {
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
              Navigator.of(context).pushReplacementNamed('/listenGame',
                  arguments: widget.wordLenght);
            },
            child: const Text('Play again!'),
          )
        ],
      ),
    );
  }

  Icon answerIconConstructor(bool answer) {
    if (answer) {
      return const Icon(Icons.check_box, color: Colors.green);
    } else {
      return const Icon(Icons.check_box, color: Colors.red);
    }
  }
}
