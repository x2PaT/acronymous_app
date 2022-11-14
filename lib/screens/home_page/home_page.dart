import 'package:acronymous_app/app/core/colors.dart';
import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/app/widgets/drawer.dart';
import 'package:acronymous_app/app/injectable.dart';
import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/screens/acronyms_page/acronyms_page.dart';
import 'package:acronymous_app/screens/alphabet_page/alphabet_page.dart';
import 'package:acronymous_app/screens/ancronym_webview_page/ancronym_webview_page.dart';
import 'package:acronymous_app/screens/home_page/cubit/home_page_cubit.dart';
import 'package:acronymous_app/screens/letter_page/letter_page.dart';
// import 'package:acronymous_app/screens/boarding_page/boarding_page.dart';
import 'package:acronymous_app/screens/quiz_board_page/quiz_board_page.dart';
import 'package:acronymous_app/services/flutter_tts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerMaster(
        selectedElement: DrawerElements.home,
      ),
      appBar: AppBar(
        title: const Text('Welcome to my app'),
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
                return SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const QuizBoardPage()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              height: 70,
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Center(
                                child: Text(
                                  'Start Quizing',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.mainAppColor),
                                ),
                              ),
                            )),
                        const SizedBox(height: 25),
                        alphabetContainer(context, state),
                        const SizedBox(height: 15),
                        acronymsContainer(context, state),
                      ],
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  Column alphabetContainer(BuildContext context, HomePageState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AlphabetPage()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 10,
                    ),
                  ],
                ),
                height: 45,
                width: MediaQuery.of(context).size.width * 0.75,
                child: Center(
                  child: Text(
                    'Alphabet',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainAppColor),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 75,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: state.alphabet.length,
            itemBuilder: (BuildContext context, int index) => SizedBox(
              width: 100,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          LetterPage(letterID: state.alphabet[index].id),
                    ),
                  );
                },
                child: Card(
                  child: Center(
                    child: Text(
                      state.alphabet[index].letter,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Column acronymsContainer(BuildContext context, HomePageState state) {
  return Column(
    children: [
      Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width,
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => AcronymsPage()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 10,
                    ),
                  ],
                ),
                height: 45,
                width: MediaQuery.of(context).size.width * 0.75,
                child: Center(
                  child: Text(
                    'Acronyms',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainAppColor),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: IconButton(
              onPressed: () {
                BlocProvider.of<HomePageCubit>(context)
                    .refreshRandomAcronymsList();
              },
              icon: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      acronymsList(context, state),
    ],
  );
}

Widget acronymsList(BuildContext context, HomePageState state) {
  switch (state.statusAcronymsList) {
    case Status.initial:
      return const Center(
        child: Text('Initial State'),
      );
    case Status.loading:
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    case Status.success:
      return Column(
        children: [
          for (var acronym in state.randomAcronymsList) ...[
            acronymCustomRow(context, acronym)
          ],
        ],
      );
    case Status.error:
      return Center(
        child: Text(
          state.errorMessage ?? 'AcronymsList Unkown error',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).errorColor,
          ),
        ),
      );
  }
}

acronymCustomRow(BuildContext context, AcronymModel acronymModel) {
  return InkWell(
    onTap: () => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AncronymWebviewPage(
          acronym: acronymModel.acronym,
        ),
      ),
    ),
    child: Card(
      child: SizedBox(
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 12),
                width: MediaQuery.of(context).size.width * 0.65,
                child: Column(
                  children: [
                    Text(
                      acronymModel.acronym,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AutoSizeText(
                      acronymModel.meaning,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                ttsService.speakTTS(acronymModel.acronymLetters);
              },
              icon: const Icon(
                Icons.play_circle_outline,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
