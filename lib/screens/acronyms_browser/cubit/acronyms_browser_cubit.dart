import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/repository/acronyms_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'acronyms_browser_state.dart';

class AcronymsBrowserCubit extends Cubit<AcronymsBrowserState> {
  AcronymsBrowserCubit({
    required this.acronymsRepository,
  }) : super(AcronymsBrowserState());

  final AcronymsRepository acronymsRepository;

  Future<void> start() async {
    emit(
      AcronymsBrowserState(
        status: Status.initial,
      ),
    );
    try {
      final result = await acronymsRepository.getAcronymsModels();

      emit(
        AcronymsBrowserState(
          status: Status.success,
          results: result,
        ),
      );
    } catch (error) {
      emit(
        AcronymsBrowserState(
          status: Status.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
