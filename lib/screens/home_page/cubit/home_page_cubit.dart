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
  final startQuizLen = 4;

  final minQuizLen = 1;
  final maxQuizLen = 18;
  final randomAcronymsListLen = 10;

  start() async {
    emit(
      HomePageState(
        status: Status.loading,
        statusAcronymsList: Status.loading,
      ),
    );

    final randomAcronyms =
        await acronymsRepository.getRandomAcronyms(randomAcronymsListLen);

    emit(
      HomePageState(
        randomAcronyms: randomAcronyms,
        quizLenghtValue: startQuizLen,
        status: Status.success,
        statusAcronymsList: Status.success,
      ),
    );
  }

  refreshRandomAcronymsList() async {
    emit(
      HomePageState(
        status: Status.success,
        statusAcronymsList: Status.loading,
        quizLenghtValue: state.quizLenghtValue,
      ),
    );

    final randomAcronyms =
        await acronymsRepository.getRandomAcronyms(randomAcronymsListLen);

    emit(
      HomePageState(
        randomAcronyms: randomAcronyms,
        quizLenghtValue: state.quizLenghtValue,
        status: Status.success,
        statusAcronymsList: Status.success,
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
          status: Status.success,
          statusAcronymsList: Status.success,
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
          status: Status.success,
          statusAcronymsList: Status.success,
        ),
      );
    }
  }
}
