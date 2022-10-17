import 'dart:math';

import 'package:acronymous_app/data/remote_data/acronyms_data_source.dart';
import 'package:acronymous_app/models/acronym_model.dart';

class AcronymsRepository {
  AcronymsRepository({required this.acronymsRemoteDataSource});
  final AcronymsRemoteDataSource acronymsRemoteDataSource;

  Future<List<AcronymModel>> getAcronymsModels() async {
    final json = await acronymsRemoteDataSource.getAcronyms();
    if (json == null) {
      return [];
    }

    final List acronymsJson = json['acronyms'];

    return acronymsJson.map((item) => AcronymModel.fromJson(item)).toList();
  }

  getRandomAcronyms(int quantity) async {
    final json = await acronymsRemoteDataSource.getAcronyms();
    if (json == null) {
      return [];
    }
    List<AcronymModel> randomAcronyms = [];
    final List acronymsJson = json['acronyms'];

    final acronymsModels =
        acronymsJson.map((item) => AcronymModel.fromJson(item)).toList();

    for (var i = 0; i < quantity; i++) {
      int acronymRandomIndex = Random().nextInt(acronymsModels.length - 1);

      randomAcronyms.add(acronymsModels[acronymRandomIndex]);
      acronymsModels.removeAt(acronymRandomIndex);
    }
    return randomAcronyms;
  }

  Future<List<AcronymModel>> getAcronymsModelsWithLetter(
      {required String letter}) async {
    final json = await acronymsRemoteDataSource.getAcronyms();
    if (json == null) {
      return [];
    }

    final List acronymsJson = json['acronyms'];

    final allAcronyms =
        acronymsJson.map((item) => AcronymModel.fromJson(item)).toList();

    return allAcronyms
        .where((acronymModel) => acronymModel.acronym.contains(letter))
        .toList();
  }
}
