import 'package:acronymous_app/data/mocked_data/acronyms_mocked_data.dart';
import 'package:acronymous_app/data/mocked_data/alphabet_mocked_data.dart';
import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/repository/acronyms_repository.dart';
import 'package:acronymous_app/repository/alphabet_repository.dart';
import 'package:acronymous_app/screens/ancronym_webview_page/ancronym_webview_page.dart';
import 'package:acronymous_app/screens/letter_page/cubit/letter_page_cubit.dart';
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
            acronymsMockedData: AcronymsMockedData(),
          ),
          alphabetRepository: AlphabetRepository(
            alphabetMockedData: AlphabetMockedData(),
          ),
        )..start(letterID: letterID),
        child: BlocBuilder<LetterPageCubit, LetterPageState>(
          builder: (context, state) {
            final letterModel = state.letterModel;
            if (letterModel == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Container(
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
        child: Container(
          height: 55,
          child: Row(
            children: [
              Container(
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
