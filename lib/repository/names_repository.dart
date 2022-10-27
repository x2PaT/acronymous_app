import 'package:acronymous_app/models/name_model.dart';
import 'package:acronymous_app/services/database_helper.dart';

class NamesRepository {
  NamesRepository({
    required this.databaseHelper,
  });

  final DatabaseHelper databaseHelper;

  Future<List<NameModel>> getNamesModels() async {
    final json = await databaseHelper.getTable(
      DatabaseHelper.namesTableName,
    );

    return json.map((item) => NameModel.fromJson(item)).toList();
  }
}
