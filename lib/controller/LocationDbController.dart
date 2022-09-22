import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_emp/data/DbOperations.dart';
import 'package:todo_emp/data/DbProvider.dart';
import 'package:todo_emp/main.dart';
import 'package:todo_emp/model/location.dart';


class LocationDbController implements DbOperations<Location> {
  Database _database ;
  LocationDbController():_database =  DbProvider().database;
  //to provider
  @override
  Future<int> create(Location object) async {
    //SQL:: INSERT INTO categories (name) VALUES ('NEW NAME');
    return await _database.insert('location', object.toMap());
  }

  // @override
  // Future<int> createLocation(Location object) async {
  //   //SQL:: INSERT INTO categories (name) VALUES ('NEW NAME');
  //   return await _database.insert('users', object.toMap());
  // }

  @override
  Future<bool> update(Location object) async {
    //UPDATE categories SET name = 'NEW NAME';
    //UPDATE categories SET name = 'NEW NAME' WHERE id = 1;
    int countOfUpdatedRows = await _database.update(
        'location', object.toMap1(),
        where: 'id = ?', whereArgs: [object.id]);
    return countOfUpdatedRows > 0;
  }

  @override
  Future<bool> delete(int id) async {
    //DELETE FROM categories;
    //DELETE FROM categories WHERE id = 1;
    int countOfDeletedRows =
    await _database.delete('location', where: 'id = ?', whereArgs: [id]);
    return countOfDeletedRows > 0;
  }


  @override
  Future<List<Location>> read() async {
    //SELECT * FROM categories;
    List<Map<String, dynamic>> rows = await _database.query('location');
    if (rows.isNotEmpty) {
      return rows.map((rowMap) => Location.fromMap(rowMap)).toList();
    }
    return [];
  }



  Future<List<Location>> readByTask(int taskId) async {
    //SELECT * FROM categories;
    List<Map<String, dynamic>> rows = await _database.query('location',
        where: 'task_id = ?',whereArgs: [taskId]);
    if (rows.isNotEmpty) {
      return rows.map((rowMap) => Location.fromMap(rowMap)).toList();
    }
    return [];
  }
  // @override
  // Future<List<Location>> read() async {
  //   //SELECT * FROM categories;
  //   List<Map<String, dynamic>> rows = await _database.query('location',where: 'task_id = ?', whereArgs: [task_id]);
  //   if (rows.isNotEmpty) {
  //     return rows.map((rowMap) => Location.fromMap(rowMap)).toList();
  //   }
  //   return [];
  // }



  Future<List<Location>> lastRow() async {
    //SELECT * FROM categories;
    List<Map<String, dynamic>> rows = await _database.query('location',orderBy:'id DESC', limit:1 );
    if (rows.isNotEmpty) {
      return rows.map((rowMap) => Location.fromMap(rowMap)).toList();
    }
    return [];
  }




  @override
  Future<List<Location>> show(int task_id) async {
    //SELECT * FROM categories WHERE id = 1;
    List<Map<String, dynamic>> rows =
    await _database.query('location', where: 'task_id = ?', whereArgs: [task_id]);
    if (rows.isNotEmpty) {
      return rows.map((rowMap) => Location.fromMap(rowMap)).toList();

    }
    return [];

  }

  @override
  Future<List<Location>> show2() {
    // TODO: implement show2
    throw UnimplementedError();
  }

  @override
  Future<List<Location>> read2() {
    // TODO: implement read2
    throw UnimplementedError();
  }

  @override
  Future<List<Location>> readId(int id) {
    // TODO: implement readId
    throw UnimplementedError();
  }

}
