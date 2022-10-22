// ignore_for_file: avoid_print

import 'dart:io';

import 'package:acronymous_app/data/remote_data/fetch_api_data.dart';
import 'package:acronymous_app/services/database_helper.dart';

class DatabaseRepository {
  DatabaseRepository({
    required this.databaseHelper,
    required this.fetchApiData,
  });
  final FetchApiData fetchApiData;

  final DatabaseHelper databaseHelper;

  Future<bool> readDataToDatabase() async {
    // await databaseHelper.reInitMetadataTableInDatabase();
    // await databaseHelper.reInitAcronymsTableInDatabase();
    // await databaseHelper.reInitAlphabetTableInDatabase();

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await writeApiDataToDatabase(
          binName: 'acronyms',
          binID: '634d3c0e65b57a31e69950f6',
        );
        await writeApiDataToDatabase(
          binName: 'alphabet',
          binID: '634d3c5b65b57a31e6995131',
        );
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  Future<void> writeApiDataToDatabase({
    required String binName,
    required String binID,
  }) async {
    bool updateDatabase = false;

    final json = await fetchApiData.getApiData(binID);
    if (json == null) {
      throw Exception('Error. Json is null');
    }

    final List jsonData = json['record'][binName];
    final jsonMetadata =
        databaseHelper.formatMetadata(json['record']['metadata']);

    List dbMetadata = await databaseHelper.getOneRecordFromDatabase(
        DatabaseHelper.metadataTableName, binName);

    print('Checking database $binName');
    if (dbMetadata.isEmpty) {
      updateDatabase = true;

      await databaseHelper.createRecordInDatabase(
          DatabaseHelper.metadataTableName, jsonMetadata);
    } else {
      if (jsonMetadata['createdAt'] != dbMetadata.first['createdAt']) {
        updateDatabase = true;
      }
    }

    if (updateDatabase) {
      print('Updating database $binName');

      if (dbMetadata.isNotEmpty &&
          jsonMetadata['createdAt'] != dbMetadata.first['createdAt']) {
        await databaseHelper.updateMetadataInDatabase(
            DatabaseHelper.metadataTableName, jsonMetadata);
      }

      await databaseHelper.wipeTableInDatabase(
        binName,
      );

      for (var item in jsonData) {
        await databaseHelper.createRecordInDatabase(binName, item);
      }
    }
  }
}
