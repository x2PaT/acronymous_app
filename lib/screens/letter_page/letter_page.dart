import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/app/injection_container.dart';
import 'package:acronymous_app/models/acronym_model.dart';
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
      body: BlocProvider<LetterPageCubit>(
        create: (context) =>
            getIt<LetterPageCubit>()..start(letterID: letterID),
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.all(10).copyWith(bottom: 25),
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: 70,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: Center(
                                child: Text(
                                  letterModel.letter,
                                  style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            SizedBox(
                              width: 100,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text(
                                    'Pronunciation',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(letterModel.pronunciation),
                                      Text(letterModel.name),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    ttsService.speakTTS(letterModel.letter);
                                  },
                                  icon: const Icon(
                                    Icons.play_circle_outline,
                                    size: 35,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
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
}
