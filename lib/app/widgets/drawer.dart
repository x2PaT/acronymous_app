import 'package:acronymous_app/app/core/colors.dart';
import 'package:acronymous_app/app/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerElements {
  static const home = 0;
  static const alphabet = 1;
  static const acronyms = 2;
  static const names = 3;
  static const games = 4;
  static const sandBox = 6;

  static const contact = 7;
  static const about = 5;
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
          child: Column(
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(65).copyWith(bottom: 0),
                child: Image(
                  image: const AssetImage('assets/logo-a.png'),
                  color: AppColors.mainAppColor,
                ),
              ),
              Positioned(
                right: 10,
                top: 45,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Image(
              image: const AssetImage('assets/acronymous-name.png'),
              color: AppColors.mainAppColor,
            ),
          ),
          const Divider(
            thickness: 5,
          ),
          DrawerListTileItem(
            selectedElement: selectedElement,
            title: 'HOME',
            drawerElementId: DrawerElements.home,
            pageRoute: '/',
            icon: Icons.home,
          ),
          DrawerListTileItem(
            selectedElement: selectedElement,
            title: 'GAMES',
            drawerElementId: DrawerElements.games,
            pageRoute: '/games',
            icon: Icons.games,
          ),
          DrawerListTileItem(
            selectedElement: selectedElement,
            title: 'ALPHABET',
            drawerElementId: DrawerElements.alphabet,
            pageRoute: '/alphabet',
            icon: Icons.abc,
          ),
          DrawerListTileItem(
            selectedElement: selectedElement,
            title: 'ACRONYMS',
            drawerElementId: DrawerElements.acronyms,
            pageRoute: '/acronyms',
            icon: Icons.view_list_outlined,
          ),
          DrawerListTileItem(
            selectedElement: selectedElement,
            title: 'NAMES',
            drawerElementId: DrawerElements.names,
            pageRoute: '/names',
            icon: Icons.people,
          ),
          DrawerListTileItem(
            selectedElement: selectedElement,
            title: 'SANDBOX',
            drawerElementId: DrawerElements.sandBox,
            pageRoute: '/sandbox',
            icon: Icons.sensors_sharp,
          ),
          const Spacer(),
          const DrawerContactItem(
            title: 'Contact',
            icon: Icons.contacts,
          ),
          DrawerListTileItem(
            selectedElement: selectedElement,
            title: 'About',
            drawerElementId: DrawerElements.about,
            pageRoute: '/about',
            icon: Icons.info,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: AppVersionWidget(),
          ),
        ],
      )),
    );
  }
}

class DrawerContactItem extends StatelessWidget {
  const DrawerContactItem({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
        ),
        height: 45,
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 15),
            Text(
              title,
              style: GoogleFonts.breeSerif(
                letterSpacing: 1.4,
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        launchMail();
        Navigator.of(context).pop();
      },
    );
  }
}

class DrawerListTileItem extends StatelessWidget {
  const DrawerListTileItem({
    Key? key,
    required this.selectedElement,
    required this.title,
    required this.drawerElementId,
    required this.pageRoute,
    required this.icon,
  }) : super(key: key);

  final int selectedElement;
  final String title;
  final int drawerElementId;
  final String pageRoute;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedElement == drawerElementId;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: isSelected
          ? const BoxDecoration(
              border: Border.symmetric(
                  horizontal: BorderSide(color: Colors.black26)),
              color: Color(0xFFF2F7F2),
            )
          : const BoxDecoration(
              color: Color(0xFFFFFFFF),
            ),
      height: 45,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(pageRoute);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(icon),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: isSelected
                      ? GoogleFonts.breeSerif(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 18,
                          color: AppColors.mainAppColor,
                        )
                      : GoogleFonts.breeSerif(
                          letterSpacing: 1.4,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // ListTile(
    //   minLeadingWidth: 15,
    //   leading: const Icon(Icons.abc),
    //   title: Text(
    //     title,
    //     style: selectedElement == drawerElementId
    //         ? TextStyle(
    //             fontWeight: FontWeight.bold, color: AppColors.mainAppColor)
    //         : const TextStyle(fontWeight: FontWeight.normal),
    //   ),
    //   onTap: () {
    //     Navigator.of(context).pop();
    //     Navigator.of(context).push(MaterialPageRoute(
    //       builder: (_) => pageWidget,
    //     ));
    //   },
    // );
  }
}
