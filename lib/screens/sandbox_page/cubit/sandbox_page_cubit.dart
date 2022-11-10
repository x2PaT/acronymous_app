import 'dart:math';

import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/models/word_sandbox.dart';
import 'package:acronymous_app/repository/sandbox_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sandbox_page_state.dart';

class SandboxPageCubit extends Cubit<SandboxPageState> {
  SandboxPageCubit({
    required this.sandboxRepository,
  }) : super(SandboxPageState());

  final SandboxRepository sandboxRepository;

  Future<void> start() async {
    emit(state.copyWith(status: Status.loading));

    try {
//read data from database table
      final result = await sandboxRepository.getWordModels();

      emit(state.copyWith(
        status: Status.success,
        results: result,
      ));
    } catch (error) {
      emit(
        SandboxPageState(
          status: Status.error,
          errorMessage: 'LetterPageState ${error.toString()}',
        ),
      );
    }
  }

  Future<void> addWord(String word) async {
    emit(state.copyWith(status: Status.loading));

    final wordsHistory = state.results.map((e) => e.word).toList();

    if (wordsHistory.contains(word)) {
      null;
    } else {
      try {
        final id = Random().nextInt(0xFFFFFF);
        
        final record = {
          'id': id,
          'word': word,
        };
        await sandboxRepository.addWordRecord(record);

        final result = await sandboxRepository.getWordModels();

        emit(state.copyWith(
          status: Status.success,
          results: result,
        ));
      } catch (error) {
        emit(
          SandboxPageState(
            status: Status.error,
            errorMessage: 'LetterPageState ${error.toString()}',
          ),
        );
      }
    }
  }

  Future<void> deleteWord(int id) async {
    emit(state.copyWith(status: Status.loading));

    try {
      await sandboxRepository.deleteWordRecord(id);

      List<WordSandboxModel> result = List.from(state.results);

      result.removeWhere((element) => element.id == id);

      emit(state.copyWith(
        status: Status.success,
        results: result,
      ));
    } catch (error) {
      emit(
        SandboxPageState(
          status: Status.error,
          errorMessage: 'LetterPageState ${error.toString()}',
        ),
      );
    }
  }

  void changeLettersModeCheckBox() {
    emit(state.copyWith(wordsMode: !state.wordsMode));
  }
}
