import 'package:acronymous_app/main.dart';
import 'package:acronymous_app/screens/games_page/games_page.dart';
import 'package:acronymous_app/screens/home_page/home_page.dart';
import 'package:acronymous_app/screens/listen_game_page/listen_game_page.dart';
import 'package:acronymous_app/screens/loading_page/loading_page.dart';
import 'package:flutter/material.dart';

class RouteGeneretor {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/loading':
        return MaterialPageRoute(builder: (_) => const LoadingPage());
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/games':
        return MaterialPageRoute(builder: (_) => const GamesPage());
      case '/listenGame':
        if (args is int) {
          return MaterialPageRoute(
              builder: (_) => ListenGame(quizLenght: args));
        }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Route error'),
          ),
          body: const Center(
            child: Text('Error wirh routes'),
          ),
        );
      },
    );
  }
}
