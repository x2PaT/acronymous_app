import 'package:acronymous_app/data/mocked_data/acronyms_mocked_data.dart';
import 'package:acronymous_app/models/acronym_model.dart';

class AcronymsRepository {
  AcronymsRepository({required this.acronymsMockedData});
  final AcronymsMockedData acronymsMockedData;

  Future<List<AcronymModel>> getAcronymsModels() async {
    final json = await acronymsMockedData.getAcronyms();

    return json.map((item) => AcronymModel.fromJson(item)).toList();
  }

  Future<List<AcronymModel>> getAcronymsModelsWithLetter(
      {required String letter}) async {
    final json = await acronymsMockedData.getAcronyms();

    final allAcronyms =
        json.map((item) => AcronymModel.fromJson(item)).toList();

    return allAcronyms
        .where((acronymModel) => acronymModel.acronym.contains(letter))
        .toList();
  }
}
