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
    await db.execute('''
        CREATE TABLE $acronymsTableName(
          id $primaryKeyType,
          acronym $stringType,
          meaning $stringType
        )''');
    db.execute('''
        CREATE TABLE $alphabetTableName(
          id $primaryKeyType,
          letter $stringType,
          name $stringType,
          pronunciation $stringType,
          useFrequency $stringType
        )''');
    db.execute('''
        CREATE TABLE $metadataTableName(
          id $stringType,
          private $boolType,
          createdAt $stringType,
          name $stringType
        )''');
  }

  wipeTableInDatabase(String tableName) async {
    Database db = await DatabaseHelper._initDatabase();
    await db.rawDelete('DELETE FROM $tableName');
  }

  reInitAcronymsTableInDatabase() async {
    Database db = await DatabaseHelper._initDatabase();
    await db.rawDelete('DROP TABLE $acronymsTableName');
    await db.execute('''
        CREATE TABLE $acronymsTableName(
          id $primaryKeyType,
          acronym $stringType,
          meaning $stringType
        )''');
  }

  reInitAlphabetTableInDatabase() async {
    Database db = await DatabaseHelper._initDatabase();
    await db.rawDelete('DROP TABLE $alphabetTableName');
    await db.execute('''
        CREATE TABLE $alphabetTableName(
          id $primaryKeyType,
          letter $stringType,
          name $stringType,
          pronunciation $stringType,
          useFrequency $stringType
        )''');
  }

  reInitMetadataTableInDatabase() async {
    Database db = await DatabaseHelper._initDatabase();
    await db.rawDelete('DROP TABLE $metadataTableName');
    await db.execute('''
        CREATE TABLE $metadataTableName(
          id $stringType,
          private $boolType,
          createdAt $stringType,
          name $stringType
        )''');
  }

  Future<List<Map<String, dynamic>>> getTableFromDatabase(
      String tableName) async {
    Database db = await DatabaseHelper._initDatabase();
    await Future.delayed(const Duration(milliseconds: 250));
    return await db.rawQuery('SELECT * FROM $tableName').onError((e, s) => []);
  }

  Future<List<Map<String, dynamic>>> getOneRecordFromDatabase(
      String tableName, String metadataName) async {
    Database db = await DatabaseHelper._initDatabase();
    final result =
        await db.query(tableName, where: 'name = ?', whereArgs: [metadataName]);
    return result;
  }

  Future<int> createRecordInDatabase(
      String tableName, Map<String, Object?> record) async {
    Database db = await DatabaseHelper._initDatabase();
    return await db.insert(tableName, record);
  }

  updateMetadataInDatabase(String tableName, record) async {
    Database db = await DatabaseHelper._initDatabase();
    return await db
        .update(tableName, record, where: 'id = ?', whereArgs: [record['id']]);
  }

  deleteRecordFromDatabase(String tableName, int recordID) async {
    Database db = await DatabaseHelper._initDatabase();
    return await db.delete(tableName, where: 'id = ?', whereArgs: [recordID]);
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
