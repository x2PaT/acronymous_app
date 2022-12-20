import 'package:acronymous_app/screens/home_page/widgets/levels_widget.dart';
import 'package:flutter/material.dart';

class GamesContainerContent extends StatelessWidget {
  const GamesContainerContent({
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
          LevelWidgetGames(
            pageRoute: '/listenGame',
            wordLenght: 2,
            title: 'Easy',
            iconAsset: 'assets/icons/1-easy.png',
            color: (Colors.green.shade100),
          ),
          LevelWidgetGames(
            pageRoute: '/listenGame',
            wordLenght: 4,
            title: 'Medium',
            iconAsset: 'assets/icons/2-medium.png',
            color: (Colors.orange.shade100),
          ),
          LevelWidgetGames(
            pageRoute: '/listenGame',
            wordLenght: 6,
            title: 'Hard',
            iconAsset: 'assets/icons/3-hard.png',
            color: (Colors.red.shade100),
          ),
        ],
      ),
    );
  }
}
