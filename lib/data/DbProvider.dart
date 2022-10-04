import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  DbProvider._();
  static final DbProvider _dbProvider = DbProvider._();
  late Database _database;

  factory DbProvider() {
    return _dbProvider;
  }

  Database get database => _database;



  Future<void> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    print('${directory.path}');
    String path = join(directory.path, 'app_database.db');
    _database = await openDatabase(
      path,
      version: 1,
      onOpen: (Database db) {},
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE IF NOT EXISTS tasks ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'title TEXT,'
            'description TEXT,'
            'time TEXT,'
            'date TEXT,'
            'isDeleted INTEGER,'
            'details TEXT,'
            'status INTEGER,'
            'counter INTEGER,'
            'userId TEXT,'
            'async INTEGER,'
            'chek TEXT,'
            'id_pk TEXT'

            ')');
        // 'isComplete INTEGER,'
        await db.execute('CREATE TABLE IF NOT EXISTS images ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'image TEXT,'
            'task_id INTEGER'
            ')');

        await db.execute('CREATE TABLE IF NOT EXISTS location ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'latitude TEXT,'
            'longitude TEXT,'
            'time TEXT,'
            'updatetime TEXT,'
            'users_id TEXT,'
            'task_id INTEGER,'
            'image_id INTEGER'
            ')');

      },
    );
  }

}
