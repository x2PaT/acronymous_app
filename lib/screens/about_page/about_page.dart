import 'package:acronymous_app/app/core/colors.dart';
import 'package:acronymous_app/app/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        actions: [
          IconButton(
            onPressed: () {
              showFlutterDialog(context);
            },
            icon: const Icon(Icons.flutter_dash),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(12).copyWith(bottom: 0),
        margin: const EdgeInsets.all(12),
        child: Column(
          children: [
            Image(
              image: const AssetImage(
                'assets/logo-a.png',
              ),
              color: AppColors.mainAppColor,
              width: 150,
            ),
            Text(
              'Acronymous App',
              style: GoogleFonts.breeSerif(
                  fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            Text(
              'App will help you to learn speaking of english alphabet by solving Quizes and games where you will hear group of letters.',
              textAlign: TextAlign.center,
              style: GoogleFonts.breeSerif(fontSize: 18),
            ),
            Text(
              '...and more',
              textAlign: TextAlign.center,
              style: GoogleFonts.breeSerif(fontSize: 18),
            ),
            const Spacer(),
            InkWell(
              onTap: () => launchMail(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(255, 242, 247, 242),
                ),
                child: Text(
                  'Contact Us',
                  style: GoogleFonts.breeSerif(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const AppVersionWidget(),
          ],
        ),
      ),
    );
  }

  Future<void> showFlutterDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey.shade300,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: SizedBox(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Made with:',
                style: GoogleFonts.breeSerif(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Image(
                    width: 80,
                    image: AssetImage('assets/flutter_logo.png'),
                  ),
                  Image(
                    width: 80,
                    image: AssetImage('assets/dart_logo.png'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
