import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/repository/acronyms_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'acronyms_page_state.dart';

class AcronymsPageCubit extends Cubit<AcronymsPageState> {
  AcronymsPageCubit({
    required this.acronymsRepository,
  }) : super(AcronymsPageState());

  final AcronymsRepository acronymsRepository;

  Future<void> start() async {
    emit(
      AcronymsPageState(
        status: Status.loading,
      ),
    );
    try {
      final result = await acronymsRepository.getAcronymsModels();

      emit(
        AcronymsPageState(
          status: Status.success,
          results: result,
          searchResults: result,
        ),
      );
    } catch (error) {
      emit(
        AcronymsPageState(
          status: Status.error,
          errorMessage: ('AcronymsPageState ${error.toString()}'),
        ),
      );
    }
  }

  void filterAcronyms(String input) {
    emit(
      AcronymsPageState(
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

    emit(AcronymsPageState(
      results: state.results,
      searchResults: searchResults,
      status: Status.success,
    ));
  }
}
