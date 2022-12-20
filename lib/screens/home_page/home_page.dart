import 'package:acronymous_app/app/core/colors.dart';
import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/app/widgets/drawer.dart';
import 'package:acronymous_app/app/injectable.dart';
import 'package:acronymous_app/screens/home_page/cubit/home_page_cubit.dart';
import 'package:acronymous_app/screens/home_page/widgets/games_container.dart';
import 'package:acronymous_app/screens/home_page/widgets/home_page_button_widget.dart';
import 'package:acronymous_app/screens/home_page/widgets/quizzes_container.dart';
// import 'package:acronymous_app/screens/boarding_page/boarding_page.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerMaster(
        selectedElement: DrawerElements.home,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.grey.shade700,
        ),
        centerTitle: true,
        title: Text(
          'Acronymous',
          textAlign: TextAlign.center,
          style: GoogleFonts.breeSerif(
            letterSpacing: 1.5,
            fontSize: 26,
            color: AppColors.mainAppColor,
          ),
        ),
        // actions: [
        // IconButton(
        //     onPressed: () {
        //       Navigator.of(context).push(MaterialPageRoute(
        //         builder: (_) => const BoardingPage(),
        //       ));
        //     },
        //     icon: const Icon(Icons.info_outline)),
        // ],
      ),
      body: BlocProvider<HomePageCubit>(
        create: (context) => getIt<HomePageCubit>()..start(),
        child: BlocBuilder<HomePageCubit, HomePageState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.initial:
                return const Center(
                  child: Text('Initial State'),
                );
              case Status.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case Status.error:

              case Status.success:
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            height: 50,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  child: Text(
                                    'Games',
                                    style: currentIndex == 0
                                        ? const TextStyle(
                                            fontSize: 18,
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.bold)
                                        : const TextStyle(
                                            fontSize: 18,
                                          ),
                                  ),
                                  onTap: () {
                                    _pageController.jumpToPage(0);
                                  },
                                ),
                                GestureDetector(
                                  child: Text(
                                    'Quizzes',
                                    style: currentIndex == 1
                                        ? const TextStyle(
                                            fontSize: 18,
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.bold)
                                        : const TextStyle(
                                            fontSize: 18,
                                          ),
                                  ),
                                  onTap: () {
                                    _pageController.jumpToPage(1);
                                  },
                                ),
                              ],
                            ),
                          ),
                          ExpandablePageView(
                            controller: _pageController,
                            onPageChanged: (value) {
                              setState(() {
                                currentIndex =
                                    _pageController.page!.round();
                              });
                            },
                            children: [
                              GamesContainerContent(
                                controller: _pageController,
                              ),
                              QuizzesContainerContent(
                                controller: _pageController,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(12).copyWith(top: 0),
                        child: Text(
                          'Learn something new',
                          style: GoogleFonts.breeSerif(fontSize: 24),
                        ),
                      ),
                    ),
                    const HomePageButtonWidget(
                      title: 'Names',
                      pageRoute: '/names',
                      imageAsset: 'assets/icons/people.png',
                    ),
                    const HomePageButtonWidget(
                      title: 'Alphabet',
                      pageRoute: '/alphabet',
                      imageAsset: 'assets/icons/abc.png',
                    ),
                    const HomePageButtonWidget(
                      title: 'Acronyms',
                      pageRoute: '/acronyms',
                      imageAsset: 'assets/icons/choose.png',
                    ),
                    const HomePageButtonWidget(
                      title: 'Sandbox',
                      pageRoute: '/sandbox',
                      imageAsset: 'assets/icons/sandbox.png',
                    ),
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(
                          thickness: 5,
                          color: Color(0xFFBDBDBD),
                        ),
                      ),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
