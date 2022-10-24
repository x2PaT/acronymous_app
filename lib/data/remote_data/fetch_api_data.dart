// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

class FetchApiData {
  Future<Map<String, dynamic>?> getApiData(String binID) async {
    print('reading $binID');
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
}
