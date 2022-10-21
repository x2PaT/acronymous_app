import 'package:acronymous_app/models/letter_model.dart';
import 'package:acronymous_app/services/database_helper.dart';

class AlphabetRepository {
  AlphabetRepository({
    required this.databaseHelper,
  });

  final DatabaseHelper databaseHelper;

  Future<List<LetterModel>> getAlphabetModels() async {
    final json = await databaseHelper.getTableFromDatabase(
      DatabaseHelper.alphabetTableName,
    );

    return json.map((item) => LetterModel.fromJson(item)).toList();
  }

  Future<LetterModel> getLetterModelWithID({required int letterID}) async {
    final json = await databaseHelper.getTableFromDatabase(
      DatabaseHelper.alphabetTableName,
    );

    final List<dynamic> allLettersModels =
        json.map((item) => LetterModel.fromJson(item)).toList();

    return allLettersModels.where((element) => element.id == letterID).first;
  }
}
