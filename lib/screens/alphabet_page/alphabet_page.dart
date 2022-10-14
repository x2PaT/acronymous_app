import 'package:acronymous_app/data/mocked_data/alphabet_mocked_data.dart';
import 'package:acronymous_app/models/letter_model.dart';
import 'package:acronymous_app/repository/alphabet_repository.dart';
import 'package:acronymous_app/screens/alphabet_page/cubit/alphabet_page_cubit.dart';
import 'package:acronymous_app/screens/letter_page/letter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlphabetPage extends StatelessWidget {
  const AlphabetPage({
    Key? key,
    required this.lettersMockedData,
  }) : super(key: key);

  final AlphabetMockedData lettersMockedData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to alphabet page'),
      ),
      body: BlocProvider(
        create: (context) => AlphabetPageCubit(
          alphabelRepository: AlphabetRepository(
            alphabetMockedData: AlphabetMockedData(),
          ),
        )..start(),
        child: BlocBuilder<AlphabetPageCubit, AlphabetPageState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 100,
                        childAspectRatio: 1 / 1,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: state.results.length,
                      itemBuilder: (context, index) {
                        final letterModel = state.results[index];
                        return GridElement(letterModel: letterModel);
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

class GridElement extends StatelessWidget {
  const GridElement({
    Key? key,
    required this.letterModel,
  }) : super(key: key);
  final LetterModel letterModel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LetterPage(
            letterID: letterModel.id,
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
