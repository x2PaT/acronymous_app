import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/models/name_model.dart';
import 'package:acronymous_app/repository/names_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'names_page_state.dart';

class NamesPageCubit extends Cubit<NamesPageState> {
  NamesPageCubit({required this.namesRepository}) : super(NamesPageState());

  final NamesRepository namesRepository;

  Future<void> start() async {
    emit(
      NamesPageState(
        status: Status.loading,
      ),
    );
    try {
      final result = await namesRepository.getNamesModels();
      emit(
        NamesPageState(
          status: Status.success,
          results: result,
          searchResults: result,
        ),
      );
    } catch (error) {
      emit(
        NamesPageState(
          status: Status.error,
          errorMessage: ('NamesPageState ${error.toString()}'),
        ),
      );
    }
  }

  void filterNames(String input) {
    emit(
      NamesPageState(
        status: Status.loading,
        results: state.results,
        searchResults: state.searchResults,
      ),
    );
    final searchResults = state.results.where((name) {
      final nameText = name.name.toLowerCase();

      return nameText.contains(input.toLowerCase());
    }).toList();

    emit(NamesPageState(
      results: state.results,
      searchResults: searchResults,
      status: Status.success,
    ));
  }
}
