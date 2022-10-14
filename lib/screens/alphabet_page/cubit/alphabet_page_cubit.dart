import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/models/letter_model.dart';
import 'package:acronymous_app/repository/alphabet_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'alphabet_page_state.dart';

class AlphabetPageCubit extends Cubit<AlphabetPageState> {
  AlphabetPageCubit({required this.alphabelRepository})
      : super(AlphabetPageState());

  final AlphabetRepository alphabelRepository;

  Future<void> start() async {
    emit(
      AlphabetPageState(
        status: Status.initial,
      ),
    );
    try {
      final result = await alphabelRepository.getAlphabetModels();

      emit(
        AlphabetPageState(
          status: Status.success,
          results: result,
        ),
      );
    } catch (error) {
      emit(
        AlphabetPageState(
          status: Status.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
