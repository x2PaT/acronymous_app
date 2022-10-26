
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

class FetchApiData {
  Future<Map<String, dynamic>?> getApiData(String binID) async {
    String parameters = '';

    final jsonUrl =
        p.join('https://api.jsonbin.io/v3/b/', binID, 'latest?$parameters');
    try {
      final response = await Dio().get<Map<String, dynamic>>(jsonUrl);
      return response.data;
    } on DioError catch (error) {
      throw Exception('FetchApiData serwer error ${error.error}');
    }
  }

  Future<List> getApiDataList(
    String binID,
    String keyValue,
  ) async {
    String parameters = '';

    final jsonUrl =
        p.join('https://api.jsonbin.io/v3/b/', binID, 'latest?$parameters');
    try {
      final responseRaw = await Dio().get<Map<String, dynamic>>(jsonUrl);
      final response = responseRaw.data;

      if (response == null) {
        throw Exception('Error. Json is null');
      }

      return response['record'][keyValue];
    } on DioError catch (error) {
      throw Exception('FetchApiData serwer error ${error.error}');
    }
  }
}
