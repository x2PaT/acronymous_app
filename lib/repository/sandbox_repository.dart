import 'package:acronymous_app/models/word_sandbox.dart';
import 'package:acronymous_app/services/database_helper.dart';

class SandboxRepository {
  SandboxRepository({required this.databaseHelper});
  final DatabaseHelper databaseHelper;

  Future<List<WordSandboxModel>> getWordModels() async {
    final json = await databaseHelper.getTable(
      DatabaseHelper.userWordsTableName,
    );

    return json.map((item) => WordSandboxModel.fromJson(item)).toList();
  }

  Future<void> addWordRecord(Map<String, dynamic> record) async {
    await databaseHelper.createRecord(
        DatabaseHelper.userWordsTableName, record);
  }

  Future<void> deleteWordRecord(int id) async {
    await databaseHelper.deleteRecord(DatabaseHelper.userWordsTableName, id);
  }
}
