import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/models/letter_model.dart';
import 'package:acronymous_app/repository/acronyms_repository.dart';
import 'package:acronymous_app/repository/alphabet_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'letter_page_state.dart';

class LetterPageCubit extends Cubit<LetterPageState> {
  LetterPageCubit(
      {required this.acronymsRepository, required this.alphabetRepository})
      : super(LetterPageState(letterModel: null));

  final AlphabetRepository alphabetRepository;
  final AcronymsRepository acronymsRepository;

  Future<void> start({required int letterID}) async {
    emit(
      LetterPageState(
        status: Status.initial,
        letterModel: null,
      ),
    );

    try {
      final letterModel = await alphabetRepository.getLetterModelWithID(
        letterID: letterID,
      );


      final acronymsModelsWithLetter =
          await acronymsRepository.getAcronymsModelsWithLetter(
        letter: letterModel.letter,
      );

      emit(LetterPageState(
        status: Status.success,
        letterModel: letterModel,
        acronymsWithLetter: acronymsModelsWithLetter,
      ));
    } catch (error) {
      emit(LetterPageState(
        letterModel: null,
        status: Status.error,
        errorMessage: error.toString(),
      ));
    }
  }
}
