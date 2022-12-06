import 'package:acronymous_app/screens/about_page/about_page.dart';
import 'package:acronymous_app/screens/acronyms_page/acronyms_page.dart';
import 'package:acronymous_app/screens/alphabet_page/alphabet_page.dart';
import 'package:acronymous_app/screens/games_page/games_page.dart';
import 'package:acronymous_app/screens/home_page/home_page.dart';
import 'package:acronymous_app/screens/listen_game_page/listen_game_page.dart';
import 'package:acronymous_app/screens/loading_page/loading_page.dart';
import 'package:acronymous_app/screens/names_page/names_page.dart';
import 'package:acronymous_app/screens/quiz_page/quiz_page.dart';
import 'package:acronymous_app/screens/sandbox_page/sandbox_page.dart';
import 'package:flutter/material.dart';

class RouteGeneretor {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/loading':
        return MaterialPageRoute(builder: (_) => const LoadingPage());
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/games':
        return MaterialPageRoute(builder: (_) => const GamesPage());
      case '/alphabet':
        return MaterialPageRoute(builder: (_) => const AlphabetPage());
      case '/acronyms':
        return MaterialPageRoute(builder: (_) => AcronymsPage());
      case '/names':
        return MaterialPageRoute(builder: (_) => NamesPage());
      case '/sandbox':
        return MaterialPageRoute(builder: (_) => SandBoxPage());
      case '/about':
        return MaterialPageRoute(builder: (_) => const AboutPage());

      case '/listenGame':
        if (args is int) {
          return MaterialPageRoute(
              builder: (_) => ListenGame(
                    gameLenght: 8,
                    wordLenght: args,
                  ));
        }
        return _errorRoute('Wrong type');

      case '/quiz':
        if (args is List) {
          return MaterialPageRoute(
              builder: (_) => QuizPage(
                    quizLenght: args[0],
                    quizType: args[1],
                  ));
        }
        return _errorRoute('Wrong type');

      default:
        return _errorRoute('Wrong route name');
    }
  }

  static Route<dynamic> _errorRoute(String error) {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Route error'),
          ),
          body: Center(
            child: Text(
              'Error wirh routes \n$error',
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
