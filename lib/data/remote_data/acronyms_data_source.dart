import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

class AcronymsRemoteDataSource {
  Future<Map<String, dynamic>?> getAcronyms() async {
    const binID = '634d3c0e65b57a31e69950f6';
    const parameters = 'meta=false';

    final jsonUrl =
        p.join('https://api.jsonbin.io/v3/b/', binID, 'latest?$parameters');
    try {
      final response = await Dio().get<Map<String, dynamic>>(jsonUrl);
      return response.data;
    } on DioError catch (error) {
      throw Exception('Acronyms serwer error ${error.error}');
    }
  }
}
