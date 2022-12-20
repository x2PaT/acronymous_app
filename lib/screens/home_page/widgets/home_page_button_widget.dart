import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageButtonWidget extends StatelessWidget {
  const HomePageButtonWidget({
    Key? key,
    required this.title,
    required this.pageRoute,
    required this.imageAsset,
  }) : super(key: key);

  final String title;
  final String pageRoute;
  final String imageAsset;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          boxShadow: const [
            BoxShadow(
              color: Color(0x2C181515),
              blurRadius: 5,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(pageRoute);
            },
            child: SizedBox(
              height: 90,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        height: 55,
                        image: AssetImage(imageAsset),
                      ),
                      const SizedBox(width: 15),
                      Flexible(
                        child: AutoSizeText(
                          title,
                          maxLines: 1,
                          style: GoogleFonts.breeSerif(
                            fontSize: 24,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
