import 'package:acronymous_app/screens/home_page/home_page.dart';
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
          const SizedBox(height: 15),
          const Text(
            'Acronymous will help you to learn spelling of english alphabet by solving Quiz where you can hear well know words.',
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
          const Text('Boarding Page'),
          const Spacer(),
          NextButton(index: index, pageController: pageController),
        ],
      ),
    );
  }
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
