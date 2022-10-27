import 'package:acronymous_app/models/letter_model.dart';
import 'package:acronymous_app/services/database_helper.dart';

class AlphabetRepository {
  AlphabetRepository({
    required this.databaseHelper,
  });

  final DatabaseHelper databaseHelper;

  Future<List<LetterModel>> getAlphabetModels() async {
    final json = await databaseHelper.getTable(
      DatabaseHelper.alphabetTableName,
    );

    return json.map((item) => LetterModel.fromJson(item)).toList();
  }

  Future<LetterModel> getLetterModelWithID({required int letterID}) async {
    final result = await databaseHelper.getOneRecordByID(
      DatabaseHelper.alphabetTableName,
      letterID,
    );
    return LetterModel.fromJson(result.first);
  }
}
