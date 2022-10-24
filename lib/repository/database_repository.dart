// ignore_for_file: avoid_print

import 'dart:io';

import 'package:acronymous_app/data/remote_data/fetch_api_data.dart';
import 'package:acronymous_app/models/metadata_model.dart';
import 'package:acronymous_app/services/database_helper.dart';

class DatabaseRepository {
  DatabaseRepository({
    required this.databaseHelper,
    required this.fetchApiData,
  });
  final FetchApiData fetchApiData;

  final DatabaseHelper databaseHelper;

  Future<bool> readDataToDatabase() async {
    final reinit = false;
    if (reinit) {
      await databaseHelper.reInitTableInDatabase(
          DatabaseHelper.acronymsTableName, DatabaseHelper.acronymsTable);
      await databaseHelper.reInitTableInDatabase(
          DatabaseHelper.alphabetTableName, DatabaseHelper.alphabetTable);
      await databaseHelper.reInitTableInDatabase(
          DatabaseHelper.metadataTableName, DatabaseHelper.metadataTable);
    }

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
    MetadataModel dbMetadataModel = MetadataModel();

    final json = await fetchApiData.getApiData(binID);
    if (json == null) {
      throw Exception('Error. Json is null');
    }

    final List jsonData = json['record'][binName];
    final jsonMetadata = databaseHelper.formatMetadata(
      json['record']['metadata'],
    );

    final dbMetadata = await databaseHelper.getOneRecordFromDatabase(
        DatabaseHelper.metadataTableName, binName);

    final jsonMetadataModel = MetadataModel.fromJson(jsonMetadata);
    if (dbMetadata.isNotEmpty) {
      dbMetadataModel = MetadataModel.fromJson(dbMetadata[0]);
    }

    print('Checking database $binName');
    if (dbMetadata.isEmpty) {
      updateDatabase = true;

      await databaseHelper.createRecordInDatabase(
          DatabaseHelper.metadataTableName, jsonMetadata);
    } else {
      if (jsonMetadataModel.createdAt != dbMetadataModel.createdAt) {
        updateDatabase = true;
      }
    }

    if (updateDatabase) {
      print('Updating database $binName');

      if (dbMetadata.isNotEmpty) {
        if (jsonMetadataModel.createdAt != dbMetadataModel.createdAt) {
          await databaseHelper.updateMetadataInDatabase(
              DatabaseHelper.metadataTableName, jsonMetadata);
        }
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
