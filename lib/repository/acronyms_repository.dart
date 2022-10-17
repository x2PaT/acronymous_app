import 'package:acronymous_app/data/mocked_data/acronyms_data_source.dart';
import 'package:acronymous_app/models/acronym_model.dart';

class AcronymsRepository {
  AcronymsRepository({required this.acronymsRemoteDataSource});
  final AcronymsRemoteDataSource acronymsRemoteDataSource;

  Future<List<AcronymModel>> getAcronymsModels() async {
    final json = await acronymsRemoteDataSource.getAcronyms();
    if (json == null) {
      return [];
    }

    final List jsonAcronyms = json['acronyms'];

    return jsonAcronyms.map((item) => AcronymModel.fromJson(item)).toList();
  }

  Future<List<AcronymModel>> getAcronymsModelsWithLetter(
      {required String letter}) async {
    final json = await acronymsRemoteDataSource.getAcronyms();
    if (json == null) {
      return [];
    }

    final List jsonAcronyms = json['acronyms'];

    final allAcronyms =
        jsonAcronyms.map((item) => AcronymModel.fromJson(item)).toList();

    return allAcronyms
        .where((acronymModel) => acronymModel.acronym.contains(letter))
        .toList();
  }
}
