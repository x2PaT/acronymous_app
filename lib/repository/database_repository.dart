import 'dart:io';

import 'package:acronymous_app/data/remote_data/acronyms_data_source.dart';
import 'package:acronymous_app/data/remote_data/alphabet_data_source.dart';
import 'package:acronymous_app/services/database_helper.dart';

class DatabaseRepository {
  DatabaseRepository({
    required this.acronymsRemoteDataSource,
    required this.alphabetRemoterDataSource,
    required this.databaseHelper,
  });

  final AcronymsRemoteDataSource acronymsRemoteDataSource;
  final AlphabetRemoterDataSource alphabetRemoterDataSource;

  final DatabaseHelper databaseHelper;

  Future<bool> readDataToDatabase() async {
    // await databaseHelper.reInitMetadataTableInDatabase();
    // await databaseHelper.reInitAcronymsTableInDatabase();
    // await databaseHelper.reInitAlphabetTableInDatabase();

    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await writeAcronymsToDatabase();
        await writeAlphabetToDatabase();

        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  Future<void> writeAcronymsToDatabase() async {
    bool updateDatabase = false;

    final json = await acronymsRemoteDataSource.getAcronyms();
    if (json == null) {
      throw Exception('Error. Json is null');
    }

    final List jsonData = json['record']['acronyms'];
    final jsonMetadata = formatMetadata(json['record']['metadata']);

    List dbMetadata = await databaseHelper.getOneRecordFromDatabase(
        DatabaseHelper.metadataTableName, DatabaseHelper.acronymsTableName);

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
      if (dbMetadata.isNotEmpty &&
          jsonMetadata['createdAt'] != dbMetadata.first['createdAt']) {
        await databaseHelper.updateMetadataInDatabase(
            DatabaseHelper.metadataTableName, jsonMetadata);
      }

      await databaseHelper.wipeTableInDatabase(
        DatabaseHelper.acronymsTableName,
      );

      for (var acronym in jsonData) {
        await databaseHelper.createRecordInDatabase(
            DatabaseHelper.acronymsTableName, acronym);
      }
    }
  }

  Future<void> writeAlphabetToDatabase() async {
    bool updateDatabase = false;

    final json = await alphabetRemoterDataSource.getAlphabet();
    if (json == null) {
      throw Exception('Error. Json is null');
    }

    final List jsonData = json['record']['alphabet'];
    final jsonMetadata = formatMetadata(json['record']['metadata']);

    List dbMetadata = await databaseHelper.getOneRecordFromDatabase(
        DatabaseHelper.metadataTableName, DatabaseHelper.alphabetTableName);

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
      if (dbMetadata.isNotEmpty &&
          jsonMetadata['createdAt'] != dbMetadata.first['createdAt']) {
        await databaseHelper.updateMetadataInDatabase(
            DatabaseHelper.metadataTableName, jsonMetadata);
      }

      await databaseHelper.wipeTableInDatabase(
        DatabaseHelper.alphabetTableName,
      );

      for (var letter in jsonData) {
        await databaseHelper.createRecordInDatabase(
            DatabaseHelper.alphabetTableName, letter);
      }
    }
  }

  formatMetadata(metadata) {
    final result = {
      'id': metadata['id'],
      'private': metadata['private'] ? 1 : 0,
      'createdAt': metadata['createdAt'],
      'name': metadata['name'],
    };
    return result;
  }
}
