import 'package:acronymous_app/data/mocked_data/acronyms_mocked_data.dart';
import 'package:acronymous_app/data/mocked_data/letters_mocked_data.dart';
import 'package:acronymous_app/models/letter_model.dart';
import 'package:acronymous_app/screens/letter_page/letter_page.dart';
import 'package:flutter/material.dart';

class AlphabetPage extends StatelessWidget {
  const AlphabetPage({
    Key? key,
    required this.lettersMockedData,
  }) : super(key: key);

  final LettersMockedData lettersMockedData;

  @override
  Widget build(BuildContext context) {
    final alphabetLetters = lettersMockedData.getLetters();
    List<LetterModel> letterModels = [];
    for (var element in alphabetLetters) {
      letterModels.add(LetterModel.fromJson(element));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to alphabet page'),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100,
                  childAspectRatio: 1 / 1,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: alphabetLetters.length,
                itemBuilder: (context, index) {
                  final letterModel = letterModels[index];
                  return GridElement(letterModel: letterModel);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridElement extends StatelessWidget {
  const GridElement({Key? key, required this.letterModel}) : super(key: key);
  final LetterModel letterModel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LetterPage(
            letterModel: letterModel,
            acronymsMockedData: AcronymsMockedData(),
          ),
        ));
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Center(
          child: Text(
            letterModel.letter,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
