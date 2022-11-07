import 'package:acronymous_app/app/core/colors.dart';
import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/app/drawer.dart';
import 'package:acronymous_app/app/injection_container.dart';
import 'package:acronymous_app/models/letter_model.dart';
import 'package:acronymous_app/screens/alphabet_page/cubit/alphabet_page_cubit.dart';
import 'package:acronymous_app/screens/letter_page/letter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlphabetPage extends StatelessWidget {
  const AlphabetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alphabet page'),
      ),
      drawer: const DrawerMaster(
        selectedElement: DrawerElements.alphabet,
      ),
      body: BlocProvider<AlphabetPageCubit>(
        create: (context) => getIt<AlphabetPageCubit>()..start(),
        child: BlocBuilder<AlphabetPageCubit, AlphabetPageState>(
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
                    state.errorMessage ?? 'AlphabetPageCubit Unkown error',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                );
              case Status.success:
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
            }
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
        decoration: BoxDecoration(
          color: AppColors.mainAppColor,
          borderRadius: const BorderRadius.all(
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
