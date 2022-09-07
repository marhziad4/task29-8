import 'package:sqflite/sqflite.dart';
import 'package:todo_emp/data/DbOperations.dart';
import 'package:todo_emp/data/DbProvider.dart';
import 'package:todo_emp/model/users.dart';

class UserDbController implements DbOperations<User> {
  Database _database ;
 UserDbController():_database =  DbProvider().database;
 //to provider
  @override
  Future<int> create(User object) async {
    //SQL:: INSERT INTO categories (name) VALUES ('NEW NAME');
    return await _database.insert('users', object.toMap());
  }

  // @override
  // Future<int> createLocation(Location object) async {
  //   //SQL:: INSERT INTO categories (name) VALUES ('NEW NAME');
  //   return await _database.insert('users', object.toMap());
  // }

  @override
  Future<bool> update(User object) async {
    //UPDATE categories SET name = 'NEW NAME';
    //UPDATE categories SET name = 'NEW NAME' WHERE id = 1;
    int countOfUpdatedRows = await _database.update(
        'users', object.toMap(),
        where: 'id = ?', whereArgs: [object.id]);
    return countOfUpdatedRows > 0;
  }

  @override
  Future<bool> delete(int id) async {
    //DELETE FROM categories;
    //DELETE FROM categories WHERE id = 1;
    int countOfDeletedRows =
    await _database.delete('users', where: 'id = ?', whereArgs: [id]);
    return countOfDeletedRows > 0;
  }


  @override
  Future<List<User>> read() async {
    //SELECT * FROM categories;
    List<Map<String, dynamic>> rows = await _database.query('users');
    if (rows.isNotEmpty) {
      return rows.map((rowMap) => User.fromMap(rowMap)).toList();
    }
    return [];
  }

  @override
  Future<List<User>> show(int id) {
    // TODO: implement show
    throw UnimplementedError();
  }

  @override
  Future<List<User>> show2() {
    // TODO: implement show2
    throw UnimplementedError();
  }

  @override
  Future<List<User>> read2() {
    // TODO: implement read2
    throw UnimplementedError();
  }

  @override
  Future<List<User>> readId(int id) {
    // TODO: implement readId
    throw UnimplementedError();
  }
  //
  // @override
  // Future<User?> show(int id) async {
  //   //SELECT * FROM categories WHERE id = 1;
  //   List<Map<String, dynamic>> rows =
  //   await _database.query('users', where: 'id = ?', whereArgs: [id]);
  //   if (rows.isNotEmpty) {
  //     return rows.map((rowMap) => User.fromMap(rowMap)).first;
  //   }
  //   return null;
  // }

}
