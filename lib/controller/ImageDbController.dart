import 'package:todo_emp/data/DbOperations.dart';
import 'package:todo_emp/data/DbProvider.dart';
import 'package:todo_emp/model/taskImage.dart';
import 'package:sqflite/sqflite.dart';


class ImageDbController extends DbOperations<taskImage> {
  Database _database = DbProvider().database;

  ImageDbController() : _database = DbProvider().database;

  @override
  Future<int> create(taskImage object) async {
    // TODO: implement create
    return await _database.insert('images', object.toJson());
  }

  @override
  Future<List<taskImage>> read() async {
    List<Map<String, dynamic>> rows =
        await _database.query('images', orderBy: 'id DESC');
    if (rows.isNotEmpty) {
      return rows.map((rowMap) => taskImage.fromJson(rowMap)).toList();
    }
    return [];
  }

  @override
  Future<List<taskImage>> readId(int id) async {
    // TODO: implement readId
    List<Map<String, dynamic>> rows = await _database.query('images',
        where: 'id = $id');
    if (rows.isNotEmpty) {
      return rows.map((rowMap) => taskImage.fromJson(rowMap)).toList();
    }
    return [];
  }

  Future<List<taskImage>> readTaskId(int id) async {
    // TODO: implement readId
    List<Map<String, dynamic>> rows = await _database.query('images',
        where: 'task_id = $id', orderBy: 'id DESC');
    if (rows.isNotEmpty) {
      return rows.map((rowMap) => taskImage.fromJson(rowMap)).toList();
    }
    return [];
  }

  @override
  Future<bool> delete(int task_id) async {
    int countOfDeletedRows =
        await _database.delete('images', where: 'task_id = ?', whereArgs: [task_id]);
    return countOfDeletedRows > 0;
  }

  @override
  Future<List<taskImage>> read2() {
    // TODO: implement read2
    throw UnimplementedError();
  }

  @override
  Future<List<taskImage>> show(int counter) {
    // TODO: implement show
    throw UnimplementedError();
  }

  @override
  Future<List<taskImage>> show2() {
    // TODO: implement show2
    throw UnimplementedError();
  }


}
