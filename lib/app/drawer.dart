import 'package:acronymous_app/screens/about_page/about_page.dart';
import 'package:acronymous_app/screens/acronyms_page/acronyms_page.dart';
import 'package:acronymous_app/screens/alphabet_page/alphabet_page.dart';
import 'package:acronymous_app/screens/home_page/home_page.dart';
import 'package:acronymous_app/screens/names_page/names_page.dart';
import 'package:flutter/material.dart';

class DrawerElements {
  static const home = 0;
  static const alphabet = 1;
  static const acronyms = 2;
  static const names = 3;
}

class DrawerMaster extends StatelessWidget {
  const DrawerMaster({
    Key? key,
    required this.selectedElement,
  }) : super(key: key);

  final int selectedElement;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      width: MediaQuery.of(context).size.width * 0.65,
      child: Drawer(
          child: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            Stack(
              children: [
                const Positioned(
                  child: Image(
                    image: AssetImage('assets/logo.png'),
                  ),
                ),
                Positioned(
                  right: 5,
                  top: 25,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
            const Text('Acronymous App'),
            const Divider(
              thickness: 2,
            ),
            ListTile(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const HomePage(),
              )),
              title: Text(
                'HOME',
                style: TextStyle(
                  fontWeight: selectedElement == DrawerElements.home
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
            ListTile(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const AlphabetPage(),
              )),
              title: Text(
                'ALPHABET',
                style: TextStyle(
                  fontWeight: selectedElement == DrawerElements.alphabet
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
            ListTile(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => AcronymsPage(),
              )),
              title: Text(
                'ACRONYMS',
                style: TextStyle(
                  fontWeight: selectedElement == DrawerElements.acronyms
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
            ListTile(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => NamesPage(),
              )),
              title: Text(
                'NAMES',
                style: TextStyle(
                  fontWeight: selectedElement == DrawerElements.names
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
            ListTile(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const AboutPage(),
              )),
              title: const Text('About'),
            ),
          ],
        ),
      )),
    );
  }
}
