import 'dart:ffi';

import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/models/letter_model.dart';
import 'package:acronymous_app/repository/acronyms_repository.dart';
import 'package:acronymous_app/repository/alphabet_repository.dart';
import 'package:acronymous_app/repository/database_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit({
    required this.alphabetRepository,
    required this.acronymsRepository,
    required this.databaseRepository,
  }) : super(HomePageState());

  final AcronymsRepository acronymsRepository;
  final AlphabetRepository alphabetRepository;
  final DatabaseRepository databaseRepository;
  final startQuizLen = 4;

  final minQuizLen = 1;
  final maxQuizLen = 18;
  final randomAcronymsListLen = 12;

  Future<void> start() async {
    emit(
      HomePageState(
        status: Status.loading,
        statusAcronymsList: Status.loading,
        statusAlphabet: Status.loading,
      ),
    );

    try {
      final internetConnection = await databaseRepository.readDataToDatabase();

      final randomAcronyms =
          await acronymsRepository.getRandomAcronyms(randomAcronymsListLen);
      final alphabet = await alphabetRepository.getAlphabetModels();

      emit(
        HomePageState(
          internetConnectionStatus: internetConnection,
          randomAcronymsList: randomAcronyms,
          quizLenghtValue: startQuizLen,
          alphabet: alphabet,
          status: Status.success,
          statusAcronymsList: Status.success,
          statusAlphabet: Status.success,
        ),
      );
    } catch (error) {
      emit(
        HomePageState(
          internetConnectionStatus: false,
          status: Status.error,
          statusAcronymsList: Status.error,
          statusAlphabet: Status.error,
          errorMessage: ('HomePageState ${error.toString()}'),
          errorMessageAcronymsList:
              ('HomePageStateAcronymsList ${error.toString()}'),
          errorMessageAlphabet: ('HomePageStateAlphabet ${error.toString()}'),
        ),
      );
    }
  }

  Future<void> refreshRandomAcronymsList() async {
    emit(
      HomePageState(
        statusAlphabet: Status.success,
        status: Status.success,
        statusAcronymsList: Status.loading,
        quizLenghtValue: state.quizLenghtValue,
        alphabet: state.alphabet,
        internetConnectionStatus: state.internetConnectionStatus,
      ),
    );

    final randomAcronyms =
        await acronymsRepository.getRandomAcronyms(randomAcronymsListLen);

    emit(
      HomePageState(
        randomAcronymsList: randomAcronyms,
        quizLenghtValue: state.quizLenghtValue,
        alphabet: state.alphabet,
        status: Status.success,
        statusAcronymsList: Status.success,
        statusAlphabet: Status.success,
        internetConnectionStatus: state.internetConnectionStatus,
      ),
    );
  }

  void quizLenghtSubt() {
    if (state.quizLenghtValue <= minQuizLen) {
      return;
    } else {
      final int newValue = state.quizLenghtValue - 1;

      emit(
        HomePageState(
          quizLenghtValue: newValue,
          randomAcronymsList: state.randomAcronymsList,
          alphabet: state.alphabet,
          status: Status.success,
          statusAcronymsList: Status.success,
          statusAlphabet: Status.success,
        ),
      );
    }
  }

  void quizLenghtIncr() {
    if (state.quizLenghtValue >= maxQuizLen) {
      return;
    } else {
      final int newValue = state.quizLenghtValue + 1;

      emit(
        HomePageState(
          randomAcronymsList: state.randomAcronymsList,
          quizLenghtValue: newValue,
          alphabet: state.alphabet,
          status: Status.success,
          statusAcronymsList: Status.success,
          statusAlphabet: Status.success,
        ),
      );
    }
  }
}
