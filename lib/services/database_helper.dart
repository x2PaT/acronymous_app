import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const databaseName = 'database.db';

  static const acronymsTableName = 'acronyms';
  static const alphabetTableName = 'alphabet';
  static const metadataTableName = 'metadata';

  static const primaryKeyType = 'INTEGER PRIMARY KEY';
  static const intType = 'INTEGER';
  static const stringType = 'TEXT';
  static const boolType = 'BOOLEAN NOT NULL';

  static const acronymsTable =
      ('CREATE TABLE $acronymsTableName (id $primaryKeyType, acronym $stringType, meaning $stringType)');
  static const alphabetTable =
      ('CREATE TABLE $alphabetTableName (id $primaryKeyType, letter $stringType, name $stringType,pronunciation $stringType,useFrequency $stringType)');
  static const metadataTable =
      ('CREATE TABLE $metadataTableName (id $stringType,private $boolType,createdAt $stringType,name $stringType)');

  static Future<Database> _initDatabase() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, databaseName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute(acronymsTable);
    db.execute(alphabetTable);
    db.execute(metadataTable);
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

  Future<int> wipeTableInDatabase(String tableName) async {
    Database db = await DatabaseHelper._initDatabase();
    return db.rawDelete('DELETE FROM $tableName');
  }

  Future<void> reInitTableInDatabase(
    String TableName,
    String tableSQL,
  ) async {
    Database db = await DatabaseHelper._initDatabase();
    await db.rawDelete('DROP TABLE $TableName');
    await db.execute(tableSQL);
  }

  Future<List<Map<String, dynamic>>> getTableFromDatabase(
      String tableName) async {
    Database db = await DatabaseHelper._initDatabase();
    return db.rawQuery('SELECT * FROM $tableName');
  }

  Future<List<Map<String, dynamic>>> getOneRecordFromDatabase(
      String tableName, String metadataName) async {
    Database db = await DatabaseHelper._initDatabase();
    return db.query(tableName, where: 'name = ?', whereArgs: [metadataName]);
  }

  Future<int> createRecordInDatabase(
      String tableName, Map<String, Object?> record) async {
    Database db = await DatabaseHelper._initDatabase();
    return db.insert(tableName, record);
  }

  Future<int> updateMetadataInDatabase(String tableName, record) async {
    Database db = await DatabaseHelper._initDatabase();
    return db.update(
      tableName,
      record,
      where: 'id = ?',
      whereArgs: [record['id']],
    );
  }

  Future<int> deleteRecordFromDatabase(String tableName, int recordID) async {
    Database db = await DatabaseHelper._initDatabase();
    return db.delete(tableName, where: 'id = ?', whereArgs: [recordID]);
  }
}



// import 'dart:io';

// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   DatabaseHelper._privateconstuctor();


//   static final DatabaseHelper instance = DatabaseHelper._privateconstuctor();

//   static Database? _database;
//   Future<Database> get database async => _database ??= await _initDatabase();

//   Future<Database> _initDatabase() async {
//     Directory docDirectory = await getApplicationDocumentsDirectory();
//     String path = join(docDirectory.path, databaseName);
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }

//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//         CREATE TABLE $acronymsTableName(
//           id $primaryKeyType,
//           acronym $stringType,
//           meaning $stringType
//         )''');
//     db.execute('''
//         CREATE TABLE $alphabetTableName(
//           id $primaryKeyType,
//           letter $stringType,
//           name $stringType,
//           pronunciation $stringType,
//           useFrequency $stringType
//         )''');
//     db.execute('''
//         CREATE TABLE $metadataTableName(
//           id $primaryKeyType,
//           private $intType,
//           createdAt $stringType,
//           name $stringType
//         )''');
//   }

//   Future<List<Map<String, dynamic>>> getTableFromDatabase(
//       String tableName) async {
//     Database db = await instance.database;
//     return await db.query(tableName);
//   }

//   Future<Map<String, dynamic>> getOneRecordFromDatabaseTable(
//       String tableName, int recordID) async {
//     Database db = await instance.database;
//     final result =
//         await db.query(tableName, where: 'id = ?', whereArgs: [recordID]);
//     return result.first;
//   }

//   Future<int> createRecordInDatabase(String tableName, record) async {
//     Database db = await instance.database;
//     return await db.insert(tableName, record.toJson());
//   }

//   updateRecordInDatabase(String tableName, record) async {
//     Database db = await instance.database;
//     return await db.update(tableName, record.toJson(),
//         where: 'id = ?', whereArgs: [record.id]);
//   }

//   deleteRecordFromDatabase(String tableName, int recordID) async {
//     Database db = await instance.database;
//     return await db.delete(tableName, where: 'id = ?', whereArgs: [recordID]);
//   }
// }
