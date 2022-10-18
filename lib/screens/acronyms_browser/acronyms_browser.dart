import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/app/drawer.dart';
import 'package:acronymous_app/data/remote_data/acronyms_data_source.dart';
import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/repository/acronyms_repository.dart';
import 'package:acronymous_app/screens/acronyms_browser/cubit/acronyms_browser_cubit.dart';
import 'package:acronymous_app/screens/ancronym_webview_page/ancronym_webview_page.dart';
import 'package:acronymous_app/services/flutter_tts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcronymsPage extends StatefulWidget {
  const AcronymsPage({Key? key}) : super(key: key);

  @override
  State<AcronymsPage> createState() => _AcronymsPageState();
}

class _AcronymsPageState extends State<AcronymsPage> {
  final acronymController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acronyms Browser'),
      ),
      drawer: const DrawerMaster(
        selectedElement: DrawerElements.acronyms,
      ),
      body: BlocProvider(
        create: (context) => AcronymsBrowserCubit(
          acronymsRepository: AcronymsRepository(
            acronymsRemoteDataSource: AcronymsRemoteDataSource(),
          ),
        )..start(),
        child: BlocBuilder<AcronymsBrowserCubit, AcronymsBrowserState>(
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
                    state.errorMessage ?? 'Unkown error',
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
                          BlocProvider.of<AcronymsBrowserCubit>(context)
                              .filterAcronyms(input);
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.searchResults.length,
                          itemBuilder: (context, index) {
                            AcronymModel acronymModel =
                                state.searchResults[index];
                            return acronymCustomRow(context, acronymModel);
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
