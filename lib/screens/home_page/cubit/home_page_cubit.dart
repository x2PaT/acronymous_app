import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/repository/acronyms_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit({
    required this.acronymsRepository,
  }) : super(HomePageState());

  final AcronymsRepository acronymsRepository;

  final minQuizLen = 4;
  final maxQuizLen = 18;
  final randomAcronymsListLen = 10;

  start() async {
    final randomAcronyms =
        await acronymsRepository.getRandomAcronyms(randomAcronymsListLen);

    emit(
      HomePageState(
        randomAcronyms: randomAcronyms,
        quizLenghtValue: minQuizLen,
        status: Status.success,
      ),
    );
  }

  refreshRandomAcronymsList() async {
    final randomAcronyms =
        await acronymsRepository.getRandomAcronyms(randomAcronymsListLen);

    emit(
      HomePageState(
        randomAcronyms: randomAcronyms,
        quizLenghtValue: state.quizLenghtValue,
        status: Status.success,
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
        ),
      );
    }
  }
}
