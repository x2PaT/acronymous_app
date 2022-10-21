import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/app/drawer.dart';
import 'package:acronymous_app/data/remote_data/acronyms_data_source.dart';
import 'package:acronymous_app/data/remote_data/alphabet_data_source.dart';
import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/repository/acronyms_repository.dart';
import 'package:acronymous_app/repository/alphabet_repository.dart';
import 'package:acronymous_app/repository/database_repository.dart';
import 'package:acronymous_app/screens/acronyms_browser/acronyms_browser.dart';
import 'package:acronymous_app/screens/alphabet_page/alphabet_page.dart';
import 'package:acronymous_app/screens/ancronym_webview_page/ancronym_webview_page.dart';
import 'package:acronymous_app/screens/home_page/cubit/home_page_cubit.dart';
import 'package:acronymous_app/screens/letter_page/letter_page.dart';
import 'package:acronymous_app/screens/quiz_page/quiz_page.dart';
import 'package:acronymous_app/services/database_helper.dart';
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
      ),
      body: BlocProvider(
        create: (context) => HomePageCubit(
          acronymsRepository: AcronymsRepository(
            databaseHelper: DatabaseHelper(),
          ),
          alphabetRepository: AlphabetRepository(
            databaseHelper: DatabaseHelper(),
          ),
          databaseRepository: DatabaseRepository(
            acronymsRemoteDataSource: AcronymsRemoteDataSource(),
            alphabetRemoterDataSource: AlphabetRemoterDataSource(),
            databaseHelper: DatabaseHelper(),
          ),
        )..start(),
        child: BlocListener<HomePageCubit, HomePageState>(
          listener: (context, state) {
            if (!state.internetConnectionStatus &&
                (state.randomAcronymsList.isEmpty || state.alphabet.isEmpty)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: SizedBox(
                    height: 40,
                    child: Text(
                      'Check your internet connection!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 22),
                    ),
                  ),
                ),
              );
            }
          },
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
                          quizContainer(context, state),
                          const SizedBox(height: 15),
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
      ),
    );
  }

  Column alphabetContainer(BuildContext context, HomePageState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AlphabetPage()));
              },
              child: const Text(
                'Alphabet',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
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
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AcronymsPage()));
              },
              child: const Text(
                'Acronyms List',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
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
    padding: const EdgeInsets.all(12),
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
              margin: const EdgeInsets.symmetric(horizontal: 10),
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
              icon: const Icon(Icons.play_circle),
            ),
          ],
        ),
      ),
    ),
  );
}
