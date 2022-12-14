// ignore_for_file: avoid_print

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

  static const acronymsBinName = DatabaseHelper.acronymsTableName;
  static const acronymsBinID = '634d3c0e65b57a31e69950f6';
  static const metadataBinName = DatabaseHelper.metadataTableName;
  static const metadataBinID = '635936aa65b57a31e6a314b1';
  static const alphabetBinName = DatabaseHelper.alphabetTableName;
  static const alphabetBinID = '634d3c5b65b57a31e6995131';
  static const namesBinName = DatabaseHelper.namesTableName;
  static const namesBinID = '63597cf82b3499323beb8de2';

  Future<bool> isTableEmpty(String tableName) async {
    final result = await databaseHelper.getTable(tableName);

    if (result.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> createTableIfNotExist() async {
    final currentTables = await databaseHelper.gettablesList();
    final currentTablesList = currentTables.map((e) => e['name']).toList();

    const tablesList = DatabaseHelper.tablesList;
    const tablesNamesList = DatabaseHelper.tablesNamesList;

    for (int i = 0; i < tablesNamesList.length; i++) {
      var table = tablesNamesList[i];
      currentTablesList.contains(table)
          ? null
          : databaseHelper.createTable(tablesList[i]);
    }
  }

  Future<void> writeDataToDatabase() async {
    await Future.wait(
      [
        writeApiDataToDatabase(binName: acronymsBinName, binID: acronymsBinID),
        writeApiDataToDatabase(binName: alphabetBinName, binID: alphabetBinID),
        writeApiDataToDatabase(binName: metadataBinName, binID: metadataBinID),
        writeApiDataToDatabase(binName: namesBinName, binID: namesBinID),
      ],
    );
  }

  Future<void> checkDatabaseIntegrity() async {
    final metadataDatabase = await databaseHelper.getTable(
      DatabaseHelper.metadataTableName,
    );
    final metadataApi = await fetchApiData.getApiDataList(
        metadataBinID, DatabaseHelper.metadataTableName);

    for (int i = 0; i < metadataApi.length; i++) {
      final metadataTableModel = MetadataModel.fromJson(metadataDatabase[i]);
      final metadataJsonModel = MetadataModel.fromJson(
        databaseHelper.formatMetadata(metadataApi[i]),
      );
      final tableName = metadataTableModel.name!;
      final binID = metadataTableModel.id!;

      print('Checking $tableName');
      if (metadataTableModel.createdAt == metadataJsonModel.createdAt) {
      } else {
        await databaseHelper.updateRecordByID(
          DatabaseHelper.metadataTableName,
          databaseHelper.formatMetadata(metadataApi[i]),
        );

        final jsonData = await fetchApiData.getApiDataList(binID, tableName);

        print('Wiping $tableName');

        await databaseHelper.wipeTable(tableName);

        for (var item in jsonData) {
          await databaseHelper.createRecord(tableName, item);
        }
      }
    }
  }

  Future<void> writeApiDataToDatabase({
    required String binName,
    required String binID,
  }) async {
    print('reading $binName');
    final json = await fetchApiData.getApiData(binID);
    if (json == null) {
      throw Exception('Error. Json is null');
    }

    final List jsonData = json['record'][binName];

    if (binName != metadataBinName) {
      await databaseHelper.wipeTable(binName);

      for (var item in jsonData) {
        await databaseHelper.createRecord(binName, item);
      }
    } else {
      final jsonDataModified =
          jsonData.map((e) => databaseHelper.formatMetadata(e)).toList();

      for (var item in jsonDataModified) {
        await databaseHelper.createRecord(binName, item);
      }
    }
  }
}
