import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Image(
              image: AssetImage('assets/logo-a.png'),
              width: 150,
            ),
            const Text(
              'Acronymous App',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            const Text(
              'App will help you to learn spelling of english alphabet by solving Quiz where you can hear well know words.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22),
            ),
            const Text(
              '...and more',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22),
            ),
            const Spacer(),
            const Text(
              'Made in flutter and dart',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Image(
                  width: 100,
                  image: AssetImage('assets/flutter_logo.png'),
                ),
                Image(
                  width: 100,
                  image: AssetImage('assets/dart_logo.png'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
