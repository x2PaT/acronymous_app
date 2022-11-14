import 'package:acronymous_app/app/core/colors.dart';
import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/app/widgets/drawer.dart';
import 'package:acronymous_app/screens/quiz_board_page/cubit/quiz_board_page_cubit.dart';
import 'package:acronymous_app/screens/quiz_page/quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class QuizBoardPage extends StatefulWidget {
  const QuizBoardPage({super.key});

  @override
  State<QuizBoardPage> createState() => _QuizBoardPageState();
}

class _QuizBoardPageState extends State<QuizBoardPage> {
  String? _quizTypesEnum;

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
                Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Acronyms'),
                      value: QuizTypesEnum.acronyms.name,
                      groupValue: _quizTypesEnum,
                      onChanged: (value) {
                        setState(() {
                          _quizTypesEnum = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Names'),
                      value: QuizTypesEnum.names.name,
                      groupValue: _quizTypesEnum,
                      onChanged: (value) {
                        setState(() {
                          _quizTypesEnum = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Random Letters'),
                      value: QuizTypesEnum.randomLetters.name,
                      groupValue: _quizTypesEnum,
                      onChanged: (value) {
                        setState(() {
                          setState(() {
                            _quizTypesEnum = value;
                          });
                        });
                      },
                    ),
                    Stack(
                      children: [
                        Positioned(
                          top: 10,
                          left: 130,
                          child: RotationTransition(
                            turns: const AlwaysStoppedAnimation(12 / 360),
                            child: Text('In progress',
                                style: TextStyle(
                                    color: AppColors.mainAppColor,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        RadioListTile<String>(
                          title: const Text('New Games'),
                          value: QuizTypesEnum.newGames.name,
                          groupValue: _quizTypesEnum,
                          onChanged: (value) {
                            setState(() {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('In development, stay tuned')));
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
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
                  ],
                ),
                const SizedBox(height: 15),
                InkWell(
                    onTap: () {
                      if (_quizTypesEnum != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AcronymsQuizPage(
                              quizLenght: state.quizLenghtValue,
                              quizType: _quizTypesEnum.toString(),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Choose quiz type')));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Center(
                        child: Text(
                          'Start Quiz',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainAppColor),
                        ),
                      ),
                    )),
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
