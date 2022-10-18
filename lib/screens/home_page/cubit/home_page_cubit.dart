import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/models/letter_model.dart';
import 'package:acronymous_app/repository/acronyms_repository.dart';
import 'package:acronymous_app/repository/alphabet_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit({
    required this.alphabetRepository,
    required this.acronymsRepository,
  }) : super(HomePageState());

  final AcronymsRepository acronymsRepository;
  final AlphabetRepository alphabetRepository;
  final startQuizLen = 4;

  final minQuizLen = 1;
  final maxQuizLen = 18;
  final randomAcronymsListLen = 10;

  start() async {
    emit(
      HomePageState(
        status: Status.loading,
        statusAcronymsList: Status.loading,
        statusAlphabet: Status.loading,
      ),
    );

    final randomAcronyms =
        await acronymsRepository.getRandomAcronyms(randomAcronymsListLen);
    final alphabet = await alphabetRepository.getAlphabetModels();
    emit(
      HomePageState(
        randomAcronyms: randomAcronyms,
        quizLenghtValue: startQuizLen,
        alphabet: alphabet,
        status: Status.success,
        statusAcronymsList: Status.success,
        statusAlphabet: Status.success,
      ),
    );
  }

  refreshRandomAcronymsList() async {
    emit(
      HomePageState(
        statusAlphabet: Status.success,
        status: Status.success,
        statusAcronymsList: Status.loading,
        quizLenghtValue: state.quizLenghtValue,
        alphabet: state.alphabet,
      ),
    );

    final randomAcronyms =
        await acronymsRepository.getRandomAcronyms(randomAcronymsListLen);

    emit(
      HomePageState(
        randomAcronyms: randomAcronyms,
        quizLenghtValue: state.quizLenghtValue,
        alphabet: state.alphabet,
        status: Status.success,
        statusAcronymsList: Status.success,
        statusAlphabet: Status.success,
      ),
    );
  }

  quizLenghtSubt() {
    if (state.quizLenghtValue <= minQuizLen) {
      return;
    } else {
      final int newValue = state.quizLenghtValue - 1;

      emit(
        HomePageState(
          quizLenghtValue: newValue,
          randomAcronyms: state.randomAcronyms,
          alphabet: state.alphabet,
          status: Status.success,
          statusAcronymsList: Status.success,
          statusAlphabet: Status.success,
        ),
      );
    }
  }

  quizLenghtIncr() {
    if (state.quizLenghtValue >= maxQuizLen) {
      return;
    } else {
      final int newValue = state.quizLenghtValue + 1;

      emit(
        HomePageState(
          randomAcronyms: state.randomAcronyms,
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
