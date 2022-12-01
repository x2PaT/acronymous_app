import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void launchMail() async {
  final Uri mailtoUri =
      Uri(scheme: 'mailto', path: 'pludowskipatryk@gmail.com');
  await launchUrl(mailtoUri);
}

showSnackBar(context, String message) {
  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.breeSerif(fontSize: 16),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
}

class AppVersionWidget extends StatelessWidget {
  const AppVersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Ver. 1.0.1',
      style: TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 158, 158, 158),
      ),
    );
  }
}
