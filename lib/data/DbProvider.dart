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
            'image TEXT,'
            'details TEXT,'
            'status INTEGER,'
            'counter INTEGER,'
            'userId TEXT,'
            'async INTEGER,'
            'chek TEXT'

            ')');
        // 'isComplete INTEGER,'
        await db.execute('CREATE TABLE IF NOT EXISTS images ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'image TEXT,'
            'task_id INTEGER'
            ')');
        await db.execute('CREATE TABLE IF NOT EXISTS users ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'email TEXT,'
            'password TEXT'
            ')');
        await db.execute('CREATE TABLE IF NOT EXISTS location ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'latitude TEXT,'
            'longitude TEXT,'
            'time TEXT,'
            'updatetime TEXT,'
            'users_id TEXT,'
            'task_id INTEGER'
            ')');

      },
    );
  }
  Future<void> backup()async{
    var databasesPath = await getDatabasesPath();
    File source1 = File('$databasesPath/app_database.db');
print(source1);

   // Directory copyTo = await getApplicationDocumentsDirectory();
    Directory copyTo =
    Directory("/storage/emulated/0/Download/MyOrganization2");

    if ((await copyTo.exists())) {
      print("Path exist");
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    } else {
      print("not exist");
      if (await Permission.storage.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
      try{
        await copyTo.create();

      }catch(e){
        print("object$e");
      }

      } else {
        print('Please give permission');
      }
    }

    String newPath = "${copyTo.path}/app_database.db";
    print(newPath);
    await source1.copy(newPath);
  }

  Future<void> restore()async{
    var databasesPath = await getDatabasesPath();
    var dbPath = join(databasesPath,'app_database.db');
    FilePickerResult? result =
    await FilePicker.platform.pickFiles();
    if (result != null) {
      File source = File(result.files.single.path!);
      await source.copy(dbPath);

      print('Successfully Restored DB');
    } else {
      print('User canceled the picker');

      // User canceled the picker
    }
  }
}
