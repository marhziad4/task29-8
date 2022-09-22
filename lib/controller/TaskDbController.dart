import 'package:sqflite/sqflite.dart';
import 'package:todo_emp/data/DbOperations.dart';
import 'package:todo_emp/data/DbProvider.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:todo_emp/preferences/user_pref.dart';

class TaskDbController extends DbOperations<taskModel> {
  Database _database = DbProvider().database;

  TaskDbController() : _database = DbProvider().database;

  @override
  Future<int> create(taskModel object) async {
    return await _database.insert('tasks', object.toJson());
  }
  @override
  Future<List<taskModel>> allTask() async {
    List<Map<String, dynamic>> rows = await _database.query('tasks',
        where:
        ' id_pk =0 and counter != 2 and userId = ${UserPreferences().IdUser}'); //,orderBy:'id DESC'
    if (rows.isNotEmpty) {
      return rows.map((rowMap) => taskModel.fromJson(rowMap)).toList();
    }
    return [];
  }
  @override
  Future<bool> delete(int id) async {
    int countOfDeletedRows =
        await _database.delete('tasks', where: 'id = ?', whereArgs: [id]);
    return countOfDeletedRows > 0;
  }



  @override
  Future<List<taskModel>> show(int counter) async {
    // TODO: implement show
    List<Map<String, dynamic>> data = await _database
        .query('tasks', where: 'counter = 2', whereArgs: [counter]);
    if (data.isNotEmpty) {
      return data.map((rowMap) => taskModel.fromJson(rowMap)).toList();
    }
    return [];
  }

  @override
  Future<List<taskModel>> read() async {
    List<Map<String, dynamic>> rows = await _database.query('tasks',
        where:
            ' id_pk =0 and counter != 2 and userId = ${UserPreferences().IdUser}'); //,orderBy:'id DESC'
    if (rows.isNotEmpty) {
      return rows.map((rowMap) => taskModel.fromJson(rowMap)).toList();
    }
    return [];
  }

  @override
  Future<List<taskModel>> read2() async {
    List<Map<String, dynamic>> rows = await _database.query('tasks',
        where:
            ' async = 0 and counter = 2 and userId = ${UserPreferences().IdUser}',
        orderBy: 'id DESC'); //,where: 'counter = 2'
    if (rows.isNotEmpty) {
      return rows.map((rowMap) => taskModel.fromJson(rowMap)).toList();
    }

    return [];
  }

  Future<List<taskModel>> readTaskAdmin() async {
    List<Map<String, dynamic>> rows = await _database.query('tasks',
        where:
            ' id_pk !=0 and async !=2 and counter!=2 and userId = ${UserPreferences().IdUser}',
        orderBy: 'id DESC'); //,where: 'counter = 2'
    if (rows.isNotEmpty) {
      return rows.map((rowMap) => taskModel.fromJson(rowMap)).toList();
    }

    return [];
  }

  @override
  Future<List<taskModel>> doneAsync() async {
    List<Map<String, dynamic>> rows = await _database.query('tasks',
        where:
            'async = 1 and counter = 2  and userId = ${UserPreferences().IdUser}',
        orderBy: 'id DESC');
    if (rows.isNotEmpty) {
      return rows.map((rowMap) => taskModel.fromJson(rowMap)).toList();
    }
    return [];
  }

  @override
  Future<List<taskModel>> TaskNotAsync() async {
    List<Map<String, dynamic>> rows = await _database.query('tasks',
        where:
            'async = 0 and counter = 2 and userId = ${UserPreferences().IdUser}',
        orderBy: 'time DESC');
    if (rows.isNotEmpty) {
      return rows.map((rowMap) => taskModel.fromJson(rowMap)).toList();
    }
    return [];
  }

  //AND isDelete= false
  // @override
  // Future<List<taskModel>> read2() async {
  //   List<Map<String, dynamic>> rows = await _database.rawQuery('SELECT counter from tasks WHERE counter > 1 ');
  //   if (rows.isNotEmpty ) {
  //     return rows.map((e) => taskModel.fromJson(e)).toList();
  //   }
  //   return [];
  // }
  Future<List<taskModel>?> updateRow() async {
    //SELECT * FROM categories;
    List<Map<String, dynamic>> rows = await _database.query('tasks');
    if (rows.isNotEmpty) {
      return rows.map((rowMap) => taskModel.fromJson(rowMap)).toList();
    }
    return [];
  }

  @override
  Future<bool> update(taskModel task) async {
    // TODO: implement update
    int countOfUpdatedRows = await _database
        .update('tasks', task.toJson(), where: 'id = ?', whereArgs: [task.id]);
    return countOfUpdatedRows != 0;
  }

  Future<bool> update3(taskModel task) async {
    // TODO: implement update
    await _database
        .rawUpdate('''
    UPDATE tasks
    SET chek = ?
    ''',
        ['true']);
    int countOfUpdatedRows = await _database
        .update('tasks', task.toJson(), where: 'id = ?', whereArgs: [task.id]);

    return countOfUpdatedRows != 0;
  }
  Future<bool> update4(taskModel task) async {
    // TODO: implement update
    await _database
        .rawUpdate('''
    UPDATE tasks
    SET chek = ?
    ''',
        ['false']);
    int countOfUpdatedRows = await _database
        .update('tasks', task.toJson(), where: 'id = ?', whereArgs: [task.id]);

    return countOfUpdatedRows != 0;
  }
/*
  Future<dynamic> alterTable(String details ) async {

    var count = await _database.execute("ALTER TABLE tasks ADD "
        "COLUMN detailsLocation TEXT;");
    print('detailsll');
    print(await _database.query('tasks'));
    return count;
  }*/

  @override
  Future<bool> update1(taskModel task) async {
    // TODO: implement update
    int countOfUpdatedRows = await _database
        .update('tasks', task.toMap1(), where: 'id = ?', whereArgs: [task.id]);
    return countOfUpdatedRows != 0;
  }

  @override
  Future<bool> update2(taskModel task) async {
    // TODO: implement update
    print('update2');
    int countOfUpdatedRows = await _database
        .update('tasks', task.toMap2(), where: 'id = ?', whereArgs: [task.id]);
    return countOfUpdatedRows != 0;
  }

  @override
  Future<List<taskModel>> show2() {
    // TODO: implement show2
    throw UnimplementedError();
  }

  @override
  Future<List<taskModel>> readId(int id) {
    // TODO: implement readId
    throw UnimplementedError();
  }

// @override
// Future<bool> updateRow(taskModel task) async {
//
//   // TODO: implement update
//   int countOfUpdatedRows = await _database.update(
//       'tasks', task.toMap1(),
//       where: 'id = ?', whereArgs: [task.id]);
//   return countOfUpdatedRows != 0;
// }
}
