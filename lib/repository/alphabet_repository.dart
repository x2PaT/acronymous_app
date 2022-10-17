import 'package:acronymous_app/data/remote_data/alphabet_data_source.dart';
import 'package:acronymous_app/models/letter_model.dart';

class AlphabetRepository {
  AlphabetRepository({required this.alphabetRemoterDataSource});
  final AlphabetRemoterDataSource alphabetRemoterDataSource;

  Future<List<LetterModel>> getAlphabetModels() async {
    final json = await alphabetRemoterDataSource.getAlphabet();

    if (json == null) {
      return [];
    }
    final List jsonAlphabet = json['alphabet'];

    return jsonAlphabet.map((item) => LetterModel.fromJson(item)).toList();
  }

  Future<LetterModel> getLetterModelWithID({required int letterID}) async {
    final json = await alphabetRemoterDataSource.getAlphabet();

    final jsonAlphabet = json!['alphabet'];

    final allLettersModels =
        jsonAlphabet.map((item) => LetterModel.fromJson(item)).toList();

    return allLettersModels.where((element) => element.id == letterID).first;
  }
}
