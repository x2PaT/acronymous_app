import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/app/drawer.dart';
import 'package:acronymous_app/data/remote_data/acronyms_data_source.dart';
import 'package:acronymous_app/models/question_model.dart';
import 'package:acronymous_app/repository/acronyms_repository.dart';
import 'package:acronymous_app/repository/questions_repository.dart';
import 'package:acronymous_app/screens/quiz_page/cubit/quiz_page_cubit.dart';
import 'package:acronymous_app/services/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

AnswerModel? selectedAnswer;
int currentQuestion = 0;
int score = 0;
bool isLastQuestion = false;
bool isAnswerSelected = false;

bool showQuestion = false;

@override
class AcronymsQuizPage extends StatefulWidget {
  const AcronymsQuizPage({Key? key, required this.quizLenght})
      : super(key: key);

  final int quizLenght;
  @override
  State<AcronymsQuizPage> createState() => _AcronymsQuizPageState();
}

class _AcronymsQuizPageState extends State<AcronymsQuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Acronymous Quiz'),
      ),
      drawer: const DrawerMaster(),
      body: BlocProvider(
        create: (context) {
          return QuizPageCubit(
            questionsRepository: QuestionsRepository(
              acronymsRepository: AcronymsRepository(
                acronymsRemoteDataSource: AcronymsRemoteDataSource(),
              ),
            ),
          )..createQuiz(widget.quizLenght);
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
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Question ${currentQuestion + 1}/${state.quizLenght}',
                            style: const TextStyle(fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      endIndent: 15,
                      thickness: 2,
                      color: Colors.grey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        showQuestion
                            ? Text(
                                state.questions[currentQuestion].questionText,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(width: 25),
                        InkWell(
                          onTap: () {
                            ttsService.speakTTS(state
                                .questions[currentQuestion].questionLetters);
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.grey.withOpacity(0.3),
                            ),
                            child: const Icon(Icons.play_circle_outline),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Column(
                      children: state.questions[currentQuestion].answersList
                          .map((answer) => answerButton(context, answer))
                          .toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(
                              () {
                                showQuestion = !showQuestion;
                              },
                            );
                          },
                          child: const Text('Show question'),
                        ),
                        const SizedBox(width: 15),
                        nextButton(context, state, selectedAnswer),
                      ],
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }

  Container answerButton(BuildContext context, AnswerModel answer) {
    bool isSelected = answer == selectedAnswer;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          primary: isSelected ? Colors.orangeAccent : Colors.white,
          onPrimary: isSelected ? Colors.white : Colors.black,
        ),
        onPressed: () {
          setState(() {
            isAnswerSelected = true;
            selectedAnswer = answer;
          });
        },
        child: Text(answer.answerText),
      ),
    );
  }

  ElevatedButton nextButton(BuildContext context, state, selectedAnswer) {
    if (currentQuestion == state.quizLenght - 1) {
      isLastQuestion = true;
    }
    return ElevatedButton(
      child: Text(!isLastQuestion ? 'Next' : 'Show Results'),
      onPressed: () {
        if (!isAnswerSelected) {
        } else {
          if (selectedAnswer.isCorrect) {
            score++;
          }

          if (isLastQuestion) {
            setState(() {
              showResultsDialog(context, state);
            });
          } else {
            setState(() {
              isAnswerSelected = false;
              currentQuestion++;
            });
          }
        }
      },
    );
  }

  showResultsDialog(BuildContext context, QuizPageState state) {
    final mark = score / state.quizLenght;
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: SizedBox(
          height: 200,
          child: Column(
            children: [
              Text(
                'You answered correctly on $score from ${state.quizLenght} questions',
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
              currentQuestion = 0;
              isLastQuestion = false;
              score = 0;
              isAnswerSelected = false;

              BlocProvider.of<QuizPageCubit>(context)
                  .createQuiz(widget.quizLenght);
              Navigator.of(context).pop();
            },
            child: const Text('Play again!'),
          )
        ],
      ),
    );
  }
}
