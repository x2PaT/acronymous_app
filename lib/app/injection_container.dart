import 'package:acronymous_app/data/remote_data/fetch_api_data.dart';
import 'package:acronymous_app/repository/acronyms_repository.dart';
import 'package:acronymous_app/repository/alphabet_repository.dart';
import 'package:acronymous_app/repository/database_repository.dart';
import 'package:acronymous_app/repository/names_repository.dart';
import 'package:acronymous_app/screens/acronyms_page/cubit/acronyms_page_cubit.dart';
import 'package:acronymous_app/screens/alphabet_page/cubit/alphabet_page_cubit.dart';
import 'package:acronymous_app/screens/ancronym_webview_page/cubit/ancronym_webview_page_cubit.dart';
import 'package:acronymous_app/screens/home_page/cubit/home_page_cubit.dart';
import 'package:acronymous_app/screens/letter_page/cubit/letter_page_cubit.dart';
import 'package:acronymous_app/screens/loading_page/cubit/loading_page_cubit.dart';
import 'package:acronymous_app/screens/names_page/cubit/names_page_cubit.dart';
import 'package:acronymous_app/services/database_helper.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

//bloc
void configureDependencies() {
  getIt.registerFactory(() => AcronymsPageCubit(acronymsRepository: getIt()));
  getIt.registerFactory(() => AncronymWebviewPageCubit());
  getIt.registerFactory(() => AlphabetPageCubit(alphabelRepository: getIt()));
  getIt.registerFactory(() => LoadingPageCubit(databaseRepository: getIt()));
  getIt.registerFactory(() => NamesPageCubit(namesRepository: getIt()));
  getIt.registerFactory(() => LetterPageCubit(
        acronymsRepository: getIt(),
        alphabetRepository: getIt(),
      ));
  getIt.registerFactory(() => HomePageCubit(
        alphabetRepository: getIt(),
        acronymsRepository: getIt(),
      ));

//repository
  getIt.registerFactory(() => (AcronymsRepository(databaseHelper: getIt())));
  getIt.registerFactory(() => (NamesRepository(databaseHelper: getIt())));
  getIt.registerFactory(() => (AlphabetRepository(databaseHelper: getIt())));
  getIt.registerFactory(() => (DatabaseRepository(
        databaseHelper: getIt(),
        fetchApiData: getIt(),
      )));
//datasource
  getIt.registerFactory(() => (DatabaseHelper()));
  getIt.registerFactory(() => (FetchApiData()));
}
