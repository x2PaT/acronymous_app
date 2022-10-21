import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

class AlphabetRemoterDataSource {
  Future<Map<String, dynamic>?> getAlphabet() async {
    const binID = '634d3c5b65b57a31e6995131';
    const parameters = '';

    final jsonUrl =
        p.join('https://api.jsonbin.io/v3/b/', binID, 'latest?$parameters');
    try {
      final response = await Dio().get<Map<String, dynamic>>(jsonUrl);
      return response.data;
    } on DioError catch (error) {
      throw Exception('Alphabet serwer error ${error.error}');
    }
  }
}
