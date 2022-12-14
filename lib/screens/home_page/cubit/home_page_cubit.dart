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

  final randomAcronymsListLen = 12;

  Future<void> start() async {
    emit(state.copyWith(
      status: Status.loading,
      statusAcronymsList: Status.loading,
      statusAlphabet: Status.loading,
    ));

    try {
      final randomAcronyms = await acronymsRepository.getRandomAcronyms(
        randomAcronymsListLen,
      );

      final alphabet = await alphabetRepository.getAlphabetModels();

      emit(state.copyWith(
        randomAcronymsList: randomAcronyms,
        alphabet: alphabet,
        status: Status.success,
        statusAcronymsList: Status.success,
        statusAlphabet: Status.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: Status.error,
        statusAcronymsList: Status.error,
        statusAlphabet: Status.error,
        errorMessage: ('HomePageState ${error.toString()}'),
        errorMessageAcronymsList:
            ('HomePageStateAcronymsList ${error.toString()}'),
        errorMessageAlphabet: ('HomePageStateAlphabet ${error.toString()}'),
      ));
    }
  }

  Future<void> refreshRandomAcronymsList() async {
    emit(state.copyWith(statusAcronymsList: Status.loading));

    final randomAcronyms = await acronymsRepository.getRandomAcronyms(
      randomAcronymsListLen,
    );

    emit(state.copyWith(
      randomAcronymsList: randomAcronyms,
      statusAcronymsList: Status.success,
    ));
  }
}
