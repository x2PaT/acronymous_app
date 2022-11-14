import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/app/widgets/drawer.dart';
import 'package:acronymous_app/app/injectable.dart';
import 'package:acronymous_app/models/name_model.dart';
import 'package:acronymous_app/screens/names_page/cubit/names_page_cubit.dart';
import 'package:acronymous_app/services/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NamesPage extends StatelessWidget {
  NamesPage({Key? key}) : super(key: key);
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acronyms Page'),
      ),
      drawer: const DrawerMaster(
        selectedElement: DrawerElements.names,
      ),
      body: BlocProvider<NamesPageCubit>(
        create: (context) => getIt<NamesPageCubit>()..start(),
        child: BlocBuilder<NamesPageCubit, NamesPageState>(
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
                    state.errorMessage ?? 'NamesPageCubit Unkown error',
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
                        controller: nameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onChanged: (input) {
                          BlocProvider.of<NamesPageCubit>(context)
                              .filterNames(input);
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.searchResults.length,
                          itemBuilder: (context, index) {
                            NameModel nameModel = state.searchResults[index];
                            return NameCustomRow(
                                context: context, nameModel: nameModel);
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

class NameCustomRow extends StatelessWidget {
  const NameCustomRow({
    Key? key,
    required this.context,
    required this.nameModel,
  }) : super(key: key);
  final BuildContext context;
  final NameModel nameModel;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 12),
                width: MediaQuery.of(context).size.width * 0.65,
                alignment: Alignment.center,
                child: Text(
                  nameModel.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                ttsService.speakTTS(nameModel.nameLetters);
              },
              icon: const Icon(
                Icons.play_circle_outline,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
