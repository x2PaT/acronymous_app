import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/screens/home_page/home_page.dart';
import 'package:acronymous_app/services/flutter_tts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class BoardPageWelcome extends StatelessWidget {
  const BoardPageWelcome({
    Key? key,
    required this.pageController,
    required this.index,
  }) : super(key: key);

  final PageController pageController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40).copyWith(bottom: 10),
      margin: const EdgeInsets.all(40).copyWith(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 20,
            ),
          ]),
      child: Column(
        children: [
          const Text(
            'Welcome!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text('add picture of alphabet'),
          const Placeholder(
            fallbackHeight: 200,
          ),
          const SizedBox(height: 30),
          const Text(
            'Acronymous will help you to learn spelling of english alphabet.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22),
          ),
          const Spacer(),
          NextButton(index: index, pageController: pageController),
        ],
      ),
    );
  }
}

class BoardPageTTS extends StatelessWidget {
  const BoardPageTTS({
    Key? key,
    required this.pageController,
    required this.index,
  }) : super(key: key);

  final PageController pageController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40).copyWith(bottom: 10),
      margin: const EdgeInsets.all(40).copyWith(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 20,
            ),
          ]),
      child: Column(
        children: [
          const Text(
            'Playing words!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'In app you can play many well know words that will help you to get familiar with english alphabet.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 20),
          const Text(
            'Check it now!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          acronymCustomRow(context,
              AcronymModel(id: 1, acronym: 'HBO', meaning: 'Home Box Office')),
          acronymCustomRow(context,
              AcronymModel(id: 1, acronym: 'BP', meaning: 'British Petrolium')),
          const Spacer(),
          NextButton(index: index, pageController: pageController),
        ],
      ),
    );
  }
}

acronymCustomRow(BuildContext context, AcronymModel acronymModel) {
  return Card(
    elevation: 5,
    child: Container(
      margin: const EdgeInsets.all(8),
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    acronymModel.acronym,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AutoSizeText(
                    acronymModel.meaning,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              ttsService.speakTTS(acronymModel.acronymLetters);
            },
            icon: const Icon(
              Icons.play_circle_outline,
              size: 32,
            ),
          ),
        ],
      ),
    ),
  );
}

class BoardPageQuiz extends StatelessWidget {
  const BoardPageQuiz({
    Key? key,
    required this.pageController,
    required this.index,
  }) : super(key: key);

  final PageController pageController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40).copyWith(bottom: 10),
      margin: const EdgeInsets.all(40).copyWith(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 20,
            ),
          ]),
      child: Column(
        children: [
          const Text('Boarding Page'),
          const Spacer(),
          NextButton(index: index, pageController: pageController),
        ],
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({
    Key? key,
    required this.index,
    required this.pageController,
  }) : super(key: key);

  final int index;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: (index == 2
            ? () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const HomePage(),
                ));
              }
            : () {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }),
        child: Text(index == 2 ? 'Start quizing' : 'Next Page'),
      ),
    );
  }
}
