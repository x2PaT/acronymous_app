import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/repository/acronyms_repository.dart';
import 'package:acronymous_app/repository/alphabet_repository.dart';
import 'package:acronymous_app/screens/ancronym_webview_page/ancronym_webview_page.dart';
import 'package:acronymous_app/screens/letter_page/cubit/letter_page_cubit.dart';
import 'package:acronymous_app/services/database_helper.dart';
import 'package:acronymous_app/services/flutter_tts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LetterPage extends StatelessWidget {
  const LetterPage({
    Key? key,
    required this.letterID,
  }) : super(key: key);

  final int letterID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Letter page'),
      ),
      body: BlocProvider(
        create: (context) => LetterPageCubit(
          acronymsRepository: AcronymsRepository(
            databaseHelper: DatabaseHelper(),
          ),
          alphabetRepository: AlphabetRepository(
            databaseHelper: DatabaseHelper(),
          ),
        )..start(letterID: letterID),
        child: BlocBuilder<LetterPageCubit, LetterPageState>(
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
                    state.errorMessage ?? 'LetterPageCubit Unkown error',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                );
              case Status.success:
                final letterModel = state.letterModel!;

                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: 60,
                                child: Center(
                                  child: Text(
                                    letterModel.letter,
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(letterModel.pronunciation),
                              Text(letterModel.name),
                              Text(letterModel.useFrequency),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('PLAY'),
                              IconButton(
                                onPressed: () {
                                  ttsService.speakTTS(letterModel.letter);
                                },
                                icon: const Icon(Icons.play_circle),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.acronymsWithLetter.length,
                          itemBuilder: (context, index) {
                            AcronymModel acronymModel =
                                state.acronymsWithLetter[index];
                            return AcronymCustomRow(
                              acronymModel: acronymModel,
                            );
                          },
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
                width: MediaQuery.of(context).size.width * 0.75,
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
