import 'package:acronymous_app/data/remote_data/acronyms_data_source.dart';
import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/repository/acronyms_repository.dart';
import 'package:acronymous_app/screens/acronyms_browser/cubit/acronyms_browser_cubit.dart';
import 'package:acronymous_app/screens/ancronym_webview_page/ancronym_webview_page.dart';
import 'package:acronymous_app/services/flutter_tts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcronymsBrowser extends StatelessWidget {
  const AcronymsBrowser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AcronymsBrowserCubit(
        acronymsRepository: AcronymsRepository(
          acronymsRemoteDataSource: AcronymsRemoteDataSource(),
        ),
      )..start(),
      child: BlocBuilder<AcronymsBrowserCubit, AcronymsBrowserState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Acronyms Browser'),
            ),
            body: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.results.length,
                      itemBuilder: (context, index) {
                        AcronymModel acronymModel = state.results[index];
                        return AcronymCustomRow(
                          acronymModel: acronymModel,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
