import 'dart:math';

import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/services/database_helper.dart';

class AcronymsRepository {
  AcronymsRepository({
    required this.databaseHelper,
  });
  final DatabaseHelper databaseHelper;

  Future<List<AcronymModel>> getAcronymsModels() async {
    final json = await databaseHelper.getTable(
      DatabaseHelper.acronymsTableName,
    );

    return json.map((item) => AcronymModel.fromJson(item)).toList();
  }

  Future<List<AcronymModel>> getRandomAcronyms(int quantity) async {
    final json = await databaseHelper.getTable(
      DatabaseHelper.acronymsTableName,
    );

    if (json.isEmpty) {
      return [];
    }
    List<AcronymModel> randomAcronyms = [];

    final acronymsModels =
        json.map((item) => AcronymModel.fromJson(item)).toList();

    for (var i = 0; i < quantity; i++) {
      int acronymRandomIndex = Random().nextInt(acronymsModels.length - 1);

      randomAcronyms.add(acronymsModels[acronymRandomIndex]);
      acronymsModels.removeAt(acronymRandomIndex);
    }
    return randomAcronyms;
  }

  Future<List<AcronymModel>> getAcronymsModelsWithLetter(
      {required String letter}) async {
    final json = await databaseHelper.getTable(
      DatabaseHelper.acronymsTableName,
    );

    final allAcronyms =
        json.map((item) => AcronymModel.fromJson(item)).toList();

    return allAcronyms
        .where((acronymModel) => acronymModel.acronym.contains(letter))
        .toList();
  }
}
