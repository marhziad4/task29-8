import 'package:sqflite/sqflite.dart';
import 'package:todo_emp/data/DbOperations.dart';
import 'package:todo_emp/data/DbProvider.dart';
import 'package:todo_emp/model/taskModel.dart';

class TaskDbController extends DbOperations<taskModel> {
  Database _database = DbProvider().database;
  TaskDbController():_database =  DbProvider().database;

  @override
  Future<int> create(taskModel object) async {

    return await _database.insert('tasks', object.toJson());
  }

  @override
  Future<bool> delete(int id) async {

    int countOfDeletedRows =
    await _database.delete('tasks', where: 'id = ?', whereArgs: [id]);
    return countOfDeletedRows > 0;
  }
  Future<List<taskModel>> getComTask() async {

    List<Map<String, dynamic>>  rows = await _database.rawQuery("SELECT * FROM tasks WHERE counter=2");
    if (rows.isNotEmpty ) {
      return rows.map((rowMap) => taskModel.fromJson(rowMap)).toList();
    }
    return [];
  }

  @override
  Future<List<taskModel>> show(int counter) async {
    // TODO: implement show
    List<Map<String, dynamic>> data = await _database
        .query('tasks', where: 'counter = 2',whereArgs: [counter]);
    if (data.isNotEmpty) {
      return data.map((rowMap) => taskModel.fromJson(rowMap)).toList();

    }
    return [];

  }
  @override
  Future<List<taskModel>> read() async {
    List<Map<String, dynamic>> rows = await _database.query('tasks',where: 'counter != 2',orderBy:'time ASC');
    if (rows.isNotEmpty ) {
      return rows.map((rowMap) => taskModel.fromJson(rowMap)).toList();
    }
    return [];
  }
  @override
  Future<List<taskModel>> read2() async {
    List<Map<String, dynamic>> rows = await _database.query('tasks',where: 'counter = 2',orderBy:'time ASC');//,where: 'counter = 2'
    if (rows.isNotEmpty ) {
      return rows.map((rowMap) => taskModel.fromJson(rowMap)).toList();
    }
    return [];
  }
  @override
  Future<List<taskModel>> readTaskAsync() async {
    List<Map<String, dynamic>> rows = await _database.query('tasks',where: 'async = 0 and counter = 2',orderBy:'time DESC');
    if (rows.isNotEmpty ) {
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
    List<Map<String, dynamic>> rows = await _database.query('tasks' );
    if (rows.isNotEmpty) {
      return rows.map((rowMap) => taskModel.fromJson(rowMap)).toList();
    }
    return [];
  }

  @override
  Future<bool> update(taskModel task) async {

    // TODO: implement update
    int countOfUpdatedRows = await _database.update(
        'tasks', task.toJson(),
        where: 'id = ?', whereArgs: [task.id]);
    return countOfUpdatedRows != 0;
  }

  @override
  Future<bool> update1(taskModel task) async {

    // TODO: implement update
    int countOfUpdatedRows = await _database.update(
        'tasks', task.toMap1(),
        where: 'id = ?', whereArgs: [task.id]);
    return countOfUpdatedRows != 0;
  }

  @override
  Future<List<taskModel>> show2() {
    // TODO: implement show2
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