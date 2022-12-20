import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/screens/home_page/widgets/levels_widget.dart';
import 'package:flutter/material.dart';

class QuizzesContainerContent extends StatelessWidget {
  const QuizzesContainerContent({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Column(
        children: [
          LevelWidgetQuizzes(
            pageRoute: '/quiz',
            quizLenght: 8,
            quizType: GamesTypesEnum.acronyms.name,
            title: 'Acronyms',
            iconAsset: 'assets/icons/choose.png',
            color: (Colors.green.shade100),
          ),
          LevelWidgetQuizzes(
            pageRoute: '/quiz',
            quizLenght: 8,
            quizType: GamesTypesEnum.names.name,
            title: 'Names',
            iconAsset: 'assets/icons/people.png',
            color: (Colors.green.shade100),
          ),
          LevelWidgetQuizzes(
            pageRoute: '/quiz',
            quizLenght: 8,
            quizType: GamesTypesEnum.randomLetters.name,
            title: 'Random Letters',
            iconAsset: 'assets/icons/quiz1.png',
            color: (Colors.green.shade100),
          ),
        ],
      ),
    );
  }
}
