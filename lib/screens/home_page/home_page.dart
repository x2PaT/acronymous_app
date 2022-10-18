import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/app/drawer.dart';
import 'package:acronymous_app/data/remote_data/acronyms_data_source.dart';
import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/repository/acronyms_repository.dart';
import 'package:acronymous_app/screens/acronyms_browser/acronyms_browser.dart';
import 'package:acronymous_app/screens/alphabet_page/alphabet_page.dart';
import 'package:acronymous_app/screens/ancronym_webview_page/ancronym_webview_page.dart';
import 'package:acronymous_app/screens/home_page/cubit/home_page_cubit.dart';
import 'package:acronymous_app/screens/quiz_page/quiz_page.dart';
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
      drawer: const DrawerMaster(),
      appBar: AppBar(
        title: const Text('Welcome to my app'),
      ),
      body: BlocProvider(
        create: (context) => HomePageCubit(
          acronymsRepository: AcronymsRepository(
            acronymsRemoteDataSource: AcronymsRemoteDataSource(),
          ),
        )..start(),
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
                return Center(
                  child: Text(
                    state.errorMessage ?? 'Unkown error',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                );
              case Status.success:
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      quizContainer(context, state),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 15,
                          itemBuilder: (BuildContext context, int index) =>
                              const Card(
                            child: Center(child: Text('Dummy Card Text')),
                          ),
                        ),
                      ),
                      const HomePageItem(
                        page: AlphabetPage(),
                        title: 'Alphabet Page',
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const AcronymsPage()));
                                  },
                                  child: const Text(
                                    'Acronyms List',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      BlocProvider.of<HomePageCubit>(context)
                                          .refreshRandomAcronymsList();
                                    },
                                    icon: const Icon(Icons.refresh))
                              ],
                            ),
                            acronymsList(context, state),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
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
          for (var acronym in state.randomAcronyms) ...[
            AcronymCustomRow(acronymModel: acronym)
          ],
        ],
        // child: ListView.builder(
        //   itemCount: state.randomAcronyms.length,
        //   itemBuilder: (context, index) {
        //     AcronymModel acronymModel = state.randomAcronyms[index];
        //     return AcronymCustomRow(
        //       acronymModel: acronymModel,
        //     );
        //   },
        // ),
      );
    case Status.error:
      return Center(
        child: Text(
          state.errorMessage ?? 'Unkown error',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).errorColor,
          ),
        ),
      );
  }
}

Container quizContainer(BuildContext context, HomePageState state) {
  return Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.all(16),
    decoration: const BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.all(
        Radius.circular(16),
      ),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Acronymous Quiz',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  BlocProvider.of<HomePageCubit>(context).quizLenghtSubt();
                },
                icon: const Icon(Icons.remove)),
            Container(
              width: 40,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
              child: Text(
                state.quizLenghtValue.toString(),
                style: const TextStyle(fontSize: 18),
              ),
            ),
            IconButton(
                onPressed: () {
                  BlocProvider.of<HomePageCubit>(context).quizLenghtIncr();
                },
                icon: const Icon(Icons.add)),
            const SizedBox(width: 15),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AcronymsQuizPage(
                      quizLenght: state.quizLenghtValue,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: const Text(
                  'Start Quiz',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class HomePageItem extends StatelessWidget {
  const HomePageItem({
    Key? key,
    required this.page,
    required this.title,
  }) : super(key: key);
  final Widget page;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => page,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 45),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.brown.shade200,
              borderRadius: const BorderRadius.all(Radius.circular(32)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 45),
      ],
    );
  }
}

class AcronymCustomRow extends StatelessWidget {
  const AcronymCustomRow({
    Key? key,
    required this.acronymModel,
  }) : super(key: key);

  final AcronymModel acronymModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AncronymWebviewPage(
                acronym: acronymModel.acronym,
              ))),
      child: Card(
        child: SizedBox(
          height: 55,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: Column(
                  children: [
                    Text(acronymModel.acronym),
                    AutoSizeText(
                      acronymModel.meaning,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  ttsService.speakTTS(acronymModel.acronymLetters);
                },
                icon: const Icon(Icons.play_circle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
