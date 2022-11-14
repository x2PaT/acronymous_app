import 'package:acronymous_app/app/core/colors.dart';
import 'package:acronymous_app/app/widgets/drawer.dart';
import 'package:acronymous_app/app/injectable.dart';
import 'package:acronymous_app/screens/sandbox_page/cubit/sandbox_page_cubit.dart';
import 'package:acronymous_app/services/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SandBoxPage extends StatelessWidget {
  SandBoxPage({
    Key? key,
  }) : super(key: key);
  final wordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SandboxPageCubit>(
      create: (context) => getIt<SandboxPageCubit>()..start(),
      child: BlocBuilder<SandboxPageCubit, SandboxPageState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('SandBox'),
              actions: [
                Center(
                    child: Text(
                  'Read by \n${state.wordsMode ? 'words' : 'letters'}',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
                Switch(
                  value: state.wordsMode,
                  onChanged: (value) {
                    BlocProvider.of<SandboxPageCubit>(context)
                        .changeLettersModeCheckBox();
                  },
                )
              ],
            ),
            drawer: const DrawerMaster(selectedElement: DrawerElements.sandBox),
            body: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: wordController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Type any word',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (wordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Text field cannot be empty!')));
                          } else {
                            BlocProvider.of<SandboxPageCubit>(context)
                                .addWord(wordController.text);
                            if (state.wordsMode) {
                              //
                              ttsService.speakTTS(wordController.text);
                            } else {
                              ttsService.speakTTS(
                                  wordController.text.split('').join(', '));
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.play_circle_outline,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 45,
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Center(
                          child: Text(
                            'Sandbox History',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainAppColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: state.results.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Center(
                                child: Text(
                                  'It is empty here, \ntry some words',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: state.results.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: const EdgeInsets.all(5),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Text(
                                        state.results[index].word,
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          if (state.wordsMode) {
                                            ttsService
                                                .speakTTS(wordController.text);
                                          } else {
                                            ttsService.speakTTS(state
                                                .results[index].word
                                                .split('')
                                                .join(', '));
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.play_circle_outline,
                                          size: 32,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            BlocProvider.of<SandboxPageCubit>(
                                                    context)
                                                .deleteWord(
                                                    state.results[index].id);
                                          },
                                          icon:
                                              const Icon(Icons.delete_forever))
                                    ],
                                  ),
                                ),
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
