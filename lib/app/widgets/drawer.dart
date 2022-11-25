import 'package:acronymous_app/app/core/colors.dart';
import 'package:acronymous_app/screens/about_page/about_page.dart';
import 'package:acronymous_app/screens/acronyms_page/acronyms_page.dart';
import 'package:acronymous_app/screens/alphabet_page/alphabet_page.dart';
import 'package:acronymous_app/screens/games_page/games_page.dart';
import 'package:acronymous_app/screens/home_page/home_page.dart';
import 'package:acronymous_app/screens/names_page/names_page.dart';
import 'package:acronymous_app/screens/sandbox_page/sandbox_page.dart';
import 'package:flutter/material.dart';

class DrawerElements {
  static const home = 0;
  static const alphabet = 1;
  static const acronyms = 2;
  static const names = 3;
  static const games = 4;
  static const about = 5;
  static const sandBox = 6;
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
                Positioned(
                  child: Container(
                    margin: const EdgeInsets.all(50).copyWith(bottom: 0),
                    child: Image(
                      image: const AssetImage('assets/logo-a.png'),
                      color: AppColors.mainAppColor,
                    ),
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
            Image(
              image: const AssetImage('assets/acronymous-name.png'),
              color: AppColors.mainAppColor,
            ),
            const Divider(
              thickness: 2,
            ),
            DrawerListTileItem(
              selectedElement: selectedElement,
              title: 'HOME',
              drawerElementId: DrawerElements.home,
              pageWidget: const HomePage(),
            ),
            DrawerListTileItem(
              selectedElement: selectedElement,
              title: 'GAMES',
              drawerElementId: DrawerElements.games,
              pageWidget: const GamesPage(),
            ),
            DrawerListTileItem(
              selectedElement: selectedElement,
              title: 'ALPHABET',
              drawerElementId: DrawerElements.alphabet,
              pageWidget: const AlphabetPage(),
            ),
            DrawerListTileItem(
              selectedElement: selectedElement,
              title: 'ACRONYMS',
              drawerElementId: DrawerElements.acronyms,
              pageWidget: AcronymsPage(),
            ),
            DrawerListTileItem(
              selectedElement: selectedElement,
              title: 'NAMES',
              drawerElementId: DrawerElements.names,
              pageWidget: NamesPage(),
            ),
            DrawerListTileItem(
              selectedElement: selectedElement,
              title: 'SANDBOX',
              drawerElementId: DrawerElements.sandBox,
              pageWidget: SandBoxPage(),
            ),
            DrawerListTileItem(
              selectedElement: selectedElement,
              title: 'About',
              drawerElementId: DrawerElements.about,
              pageWidget: const AboutPage(),
            ),
          ],
        ),
      )),
    );
  }
}

class DrawerListTileItem extends StatelessWidget {
  const DrawerListTileItem({
    Key? key,
    required this.selectedElement,
    required this.title,
    required this.drawerElementId,
    required this.pageWidget,
  }) : super(key: key);

  final int selectedElement;
  final String title;
  final int drawerElementId;
  final Widget pageWidget;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => pageWidget,
        ));
      },
      title: Text(
        title,
        style: selectedElement == drawerElementId
            ? TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.mainAppColor)
            : const TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }
}
