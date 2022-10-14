import 'package:acronymous_app/data/mocked_data/alphabet_mocked_data.dart';
import 'package:acronymous_app/screens/alphabet_page/alphabet_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to my app'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(50),
            width: 250,
            child: const Text(
              'App will help you to learn spelling of english alphabet by solving Quiz where you can hear well know acronyms.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
          ),
          const HomePageItem(page: HomePage(), title: 'Quiz Page /in progress'),
          HomePageItem(
              page: AlphabetPage(lettersMockedData: AlphabetMockedData()),
              title: 'Alphabet Page'),
        ],
      ),
    );
  }
}

class HomePageItem extends StatelessWidget {
  const HomePageItem({
    Key? key,
    required this.page,
    required this.title,
  }) : super(key: key);
  final Widget page;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => page,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 45),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.brown.shade200,
              borderRadius: const BorderRadius.all(Radius.circular(32)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 45),
      ],
    );
  }
}
