import 'package:acronymous_app/app/drawer.dart';
import 'package:acronymous_app/screens/quiz_board_page/cubit/quiz_board_page_cubit.dart';
import 'package:acronymous_app/screens/quiz_page/quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizBoardPage extends StatelessWidget {
  const QuizBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select quiz'),
      ),
      drawer: const DrawerMaster(
        selectedElement: DrawerElements.quizBoard,
      ),
      body: BlocProvider(
        create: (context) => QuizBoardPageCubit()..start(),
        child: BlocBuilder<QuizBoardPageCubit, QuizBoardPageState>(
          builder: (context, state) {
            return Column(
              children: [
                QuizContainer(
                    context: context,
                    state: state,
                    title: 'Acronymous Quiz',
                    quizType: 'acronyms'),
                const SizedBox(height: 15),
                QuizContainer(
                    context: context,
                    state: state,
                    title: 'Names Quiz',
                    quizType: 'names'),
                const SizedBox(height: 15),
              ],
            );
          },
        ),
      ),
    );
  }
}

class QuizContainer extends StatelessWidget {
  const QuizContainer(
      {super.key,
      required this.context,
      required this.state,
      required this.title,
      required this.quizType});

  final BuildContext context;
  final QuizBoardPageState state;
  final String title;
  final String quizType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    BlocProvider.of<QuizBoardPageCubit>(context)
                        .quizLenghtSubt();
                  },
                  icon: const Icon(Icons.remove)),
              Container(
                width: 40,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: Text(
                  state.quizLenghtValue.toString(),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              IconButton(
                  onPressed: () {
                    BlocProvider.of<QuizBoardPageCubit>(context)
                        .quizLenghtIncr();
                  },
                  icon: const Icon(Icons.add)),
              const SizedBox(width: 15),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AcronymsQuizPage(
                        quizLenght: state.quizLenghtValue,
                        quizType: quizType,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'Start Quiz',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
