import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/app/widgets/drawer.dart';
import 'package:acronymous_app/app/injectable.dart';
import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/screens/acronyms_page/cubit/acronyms_page_cubit.dart';
import 'package:acronymous_app/screens/ancronym_webview_page/ancronym_webview_page.dart';
import 'package:acronymous_app/services/flutter_tts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcronymsPage extends StatelessWidget {
  AcronymsPage({Key? key}) : super(key: key);

  final acronymController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acronyms Page'),
      ),
      drawer: const DrawerMaster(
        selectedElement: DrawerElements.acronyms,
      ),
      body: BlocProvider<AcronymsPageCubit>(
        create: (context) => getIt<AcronymsPageCubit>()..start(),
        child: BlocBuilder<AcronymsPageCubit, AcronymsPageState>(
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
                    state.errorMessage ?? 'AcronymsPageCubit Unkown error',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                );
              case Status.success:
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: acronymController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Acronym or meaning',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onChanged: (input) {
                          BlocProvider.of<AcronymsPageCubit>(context)
                              .filterAcronyms(input);
                        },
                      ),
                      Expanded(
                        child: state.searchResults.isNotEmpty
                            ? ListView.builder(
                                itemCount: state.searchResults.length,
                                itemBuilder: (context, index) {
                                  AcronymModel acronymModel =
                                      state.searchResults[index];
                                  return AcronymCustomRow(
                                      context: context,
                                      acronymModel: acronymModel);
                                },
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Center(
                                    child: Text(
                                      'It is empty here, \ntry something else',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
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

class AcronymCustomRow extends StatelessWidget {
  const AcronymCustomRow({
    Key? key,
    required this.context,
    required this.acronymModel,
  }) : super(key: key);
  final BuildContext context;
  final AcronymModel acronymModel;
  @override
  Widget build(BuildContext context) {
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
