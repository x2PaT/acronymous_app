import 'package:acronymous_app/data/mocked_data/acronyms_mocked_data.dart';
import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/models/letter_model.dart';
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
      body: Center(
        child: Column(
          children: [
            Text(letterModel.letter),
            Text(letterModel.pronunciation),
            Text(letterModel.name),
            Text(letterModel.useFrequency),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Pronunciation'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: acronymsWithLetter.length,
                itemBuilder: (context, index) {
                  AcronymModel acronymModel = acronymsWithLetter[index];
                  return ListTile(
                    title: Text(acronymModel.acronym),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
