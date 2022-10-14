import 'package:acronymous_app/data/mocked_data/alphabet_mocked_data.dart';
import 'package:acronymous_app/models/letter_model.dart';

class AlphabetRepository {
  AlphabetRepository({required this.alphabetMockedData});
  final AlphabetMockedData alphabetMockedData;

  Future<List<LetterModel>> getAlphabetModels() async {
    final json = await alphabetMockedData.getAlphabet();

    return json.map((item) => LetterModel.fromJson(item)).toList();
  }

  Future<LetterModel> getLetterModelWithID({required int letterID}) async {
    final json = await alphabetMockedData.getAlphabet();

    final allLettersModels =
        json.map((item) => LetterModel.fromJson(item)).toList();

    return allLettersModels.where((element) => element.id == letterID).first;
  }
}
