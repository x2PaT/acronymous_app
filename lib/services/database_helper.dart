import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const databaseName = 'database.db';

  static const acronymsTableName = 'acronyms';
  static const alphabetTableName = 'alphabet';
  static const metadataTableName = 'metadata';
  static const namesTableName = 'names';
  static const userWordsTableName = 'userword';

  static const primaryKeyType = 'INTEGER PRIMARY KEY';
  static const primaryKeyTypeAutoInc = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const intType = 'INTEGER';
  static const stringType = 'TEXT';
  static const boolType = 'BOOLEAN NOT NULL';

  static const tablesNamesList = [
    acronymsTableName,
    alphabetTableName,
    metadataTableName,
    namesTableName,
    userWordsTableName,
  ];
  static const tablesList = [
    acronymsTable,
    alphabetTable,
    metadataTable,
    namesTable,
    userWordsTable,
  ];
  static const acronymsTable =
      ('''CREATE TABLE if not exists $acronymsTableName 
      (id $primaryKeyType, 
      acronym $stringType, 
      meaning $stringType)''');

  static const alphabetTable =
      ('''CREATE TABLE if not exists $alphabetTableName 
      (id $primaryKeyType, 
      letter $stringType, 
      name $stringType,
      pronunciation $stringType, 
      useFrequency $stringType)''');

  static const metadataTable = ('''
CREATE TABLE if not exists $metadataTableName 
      (id $stringType, 
      private $boolType, 
      createdAt $stringType,
      name $stringType,
      sqlquery $stringType)''');

  static const namesTable = ('''
CREATE TABLE if not exists $namesTableName 
      (id $primaryKeyType, 
      name $stringType)''');

  static const userWordsTable = ('''
CREATE TABLE if not exists $userWordsTableName 
      (id $primaryKeyType, 
      word $stringType)''');

  static Future<Database> _initDatabase() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, databaseName);
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future _onCreate(Database db, int version) async {
    for (var table in tablesList) {
      await db.execute(table);
    }
  }

  Future<List> gettablesList() async {
    Database db = await DatabaseHelper._initDatabase();
    return db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name");
  }

  Future<void> createTable(String table) async {
    Database db = await DatabaseHelper._initDatabase();
    await db.execute(table);
  }

  Map<String, dynamic> formatMetadata(metadata) {
    final result = {
      'id': metadata['id'],
      'private': metadata['private'] ? 1 : 0,
      'createdAt': metadata['createdAt'],
      'name': metadata['name'],
    };
    return result;
  }

  Future<int> wipeTable(String tableName) async {
    Database db = await DatabaseHelper._initDatabase();
    return db.rawDelete('DELETE FROM $tableName');
  }

  Future<void> reInitTable(
    String tableName,
    String table,
  ) async {
    Database db = await DatabaseHelper._initDatabase();
    await db.rawDelete('DROP TABLE $tableName');
    return db.execute(table);
  }

  Future<List<Map<String, dynamic>>> getTable(String tableName) async {
    Database db = await DatabaseHelper._initDatabase();
    return db.rawQuery('SELECT * FROM $tableName');
  }

  Future<List<Map<String, dynamic>>> getOneMetedataRecord(
      String tableName, String metadataName) async {
    Database db = await DatabaseHelper._initDatabase();
    return db.query(tableName, where: 'name = ?', whereArgs: [metadataName]);
  }

  Future<List<Map<String, dynamic>>> getOneRecordByID(
      String tableName, int id) async {
    Database db = await DatabaseHelper._initDatabase();
    return db.query(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> createRecord(
      String tableName, Map<String, Object?> record) async {
    Database db = await DatabaseHelper._initDatabase();
    return db.insert(tableName, record);
  }

  Future<int> updateRecordByID(String tableName, record) async {
    Database db = await DatabaseHelper._initDatabase();
    return db.update(
      tableName,
      record,
      where: 'id = ?',
      whereArgs: [record['id']],
    );
  }

  Future<int> deleteRecord(String tableName, int recordID) async {
    Database db = await DatabaseHelper._initDatabase();
    return db.delete(tableName, where: 'id = ?', whereArgs: [recordID]);
  }

  Future<void> deleteTable(String tableName) async {
    Database db = await DatabaseHelper._initDatabase();
    await db.rawDelete('DROP TABLE $tableName');
  }
}
