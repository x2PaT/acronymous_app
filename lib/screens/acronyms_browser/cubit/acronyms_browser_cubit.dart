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
        status: Status.loading,
      ),
    );
    try {
      final result = await acronymsRepository.getAcronymsModels();

      emit(
        AcronymsBrowserState(
          status: Status.success,
          results: result,
          searchResults: result,
        ),
      );
    } catch (error) {
      emit(
        AcronymsBrowserState(
          status: Status.error,
          errorMessage: ('AcronymsBrowserState ${error.toString()}'),
        ),
      );
    }
  }

  void filterAcronyms(String input) {
    emit(
      AcronymsBrowserState(
        status: Status.loading,
        results: state.results,
        searchResults: state.searchResults,
      ),
    );
    final searchResults = state.results.where((acronym) {
      final acronymText = acronym.acronym.toLowerCase();
      final acronymMeaning = acronym.meaning.toLowerCase();

      return acronymText.contains(input.toLowerCase()) ||
          acronymMeaning.contains(input.toLowerCase());
    }).toList();

    emit(AcronymsBrowserState(
      results: state.results,
      searchResults: searchResults,
      status: Status.success,
    ));
  }
}
