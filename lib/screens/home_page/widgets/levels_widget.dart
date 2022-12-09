import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LevelWidgetGames extends StatelessWidget {
  const LevelWidgetGames({
    Key? key,
    required this.title,
    required this.color,
    required this.iconAsset,
    required this.pageRoute,
    this.wordLenght = 0,
  }) : super(key: key);

  final String pageRoute;
  final int wordLenght;

  final String title;
  final Color color;
  final String iconAsset;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        boxShadow: const [
          BoxShadow(
            color: Color(0x2C181515),
            blurRadius: 5,
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            //
            Navigator.of(context).pushNamed(pageRoute, arguments: wordLenght);
          },
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(iconAsset),
                  height: 45,
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: GoogleFonts.breeSerif(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LevelWidgetQuizzes extends StatelessWidget {
  const LevelWidgetQuizzes({
    Key? key,
    required this.title,
    required this.color,
    required this.iconAsset,
    required this.pageRoute,
    required this.quizType,
    required this.quizLenght,
  }) : super(key: key);

  final String pageRoute;
  final String quizType;
  final int quizLenght;

  final String title;
  final Color color;
  final String iconAsset;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        boxShadow: const [
          BoxShadow(
            color: Color(0x2C181515),
            blurRadius: 5,
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            //
            Navigator.of(context)
                .pushNamed(pageRoute, arguments: [quizLenght, quizType]);
          },
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(iconAsset),
                  height: 45,
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: GoogleFonts.breeSerif(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
