import 'package:acronymous_app/data/mocked_data/acronyms_mocked_data.dart';
import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/models/letter_model.dart';
import 'package:acronymous_app/screens/ancronym_webview_page/ancronym_webview_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class LetterPage extends StatelessWidget {
  const LetterPage({
    Key? key,
    required this.letterModel,
    required this.acronymsMockedData,
  }) : super(key: key);

  final LetterModel letterModel;
  final AcronymsMockedData acronymsMockedData;

  @override
  Widget build(BuildContext context) {
    final acronyms = acronymsMockedData.getAcronyms();

    List acronymsWithLetter = [];
    for (var element in acronyms) {
      final acronymModel = AcronymModel.fromJson(element);
      if (acronymModel.acronym.contains(letterModel.letter)) {
        acronymsWithLetter.add(acronymModel);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to letter $letterModel page'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(letterModel.letter),
                Text(letterModel.pronunciation),
                Text(letterModel.name),
                Text(letterModel.useFrequency),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('PLAY'),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.play_circle),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: acronymsWithLetter.length,
                itemBuilder: (context, index) {
                  AcronymModel acronymModel = acronymsWithLetter[index];
                  return AcronymCustomRow(acronymModel: acronymModel);
                },
              ),
            ),
          ],
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
                onPressed: () {},
                icon: const Icon(Icons.play_circle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
