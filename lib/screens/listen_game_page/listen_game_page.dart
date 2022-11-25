// ignore_for_file: avoid_print, deprecated_member_use

import 'dart:async';

import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/app/injectable.dart';
import 'package:acronymous_app/screens/listen_game_page/cubit/listen_game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ListenGame extends StatefulWidget {
  const ListenGame({
    Key? key,
    required this.quizLenght,
  }) : super(key: key);

  final int quizLenght;

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
    // errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBarWidget(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message!,
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listen and Write Game'),
      ),
      body: BlocProvider(
        create: (context) =>
            getIt<ListenGamePageCubit>()..createGame(widget.quizLenght),
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
              print(state.questions[state.currentQuestion].acronymLetters);
              return Column(
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
                          primary: Colors.orangeAccent),
                      onPressed: () {
                        BlocProvider.of<ListenGamePageCubit>(context).speakText(
                            state.questions[state.currentQuestion]
                                .acronymLetters);
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
                          final String questionLetters =
                              state.questions[state.currentQuestion].acronym;

                          if (state.answeredQuestions == state.quizLenght) {
                            showResultsDialog(context, state);
                          } else if (answerLetters.length ==
                              questionLetters.length) {
                            //check answer
                            BlocProvider.of<ListenGamePageCubit>(context)
                                .checkAnswer(answerLetters);

                            textEditingController.clear();

                            if (state.answeredQuestions == state.quizLenght) {
                              showResultsDialog(context, state);
                            }
                            BlocProvider.of<ListenGamePageCubit>(context)
                                .isLastQuestionChecker();
                          } else {
                            snackBarWidget('Select answer!');
                            errorController!.add(ErrorAnimationType.shake);
                          }
                        },
                        child: Text(
                          state.isLastQuestion ? 'Show Results' : 'Next',
                        ),
                      ),
                    ],
                  ),
                ],
              );
          }
        }),
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
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/listenGame', ModalRoute.withName('/'),
                  arguments: widget.quizLenght);
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