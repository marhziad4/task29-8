import 'package:flutter/material.dart';
import 'package:todo_emp/controller/UserDbController.dart';
import 'package:todo_emp/model/users.dart';

class UserProvider extends ChangeNotifier{
  List<User> users = <User>[];
  UserDbController _userDbController = UserDbController();
  Future<bool> addUser({required User user}) async {
    int id = await _userDbController.create(user);
    if (id != 0) {
      user.id = id;
      users.add(user);
      notifyListeners();
      return true;
    }
    return false;
  }
  Future<void> read() async {
    users = await _userDbController.read();
    notifyListeners();
  }

  Future<bool> update({required User user}) async {
    bool updated = await _userDbController.update(user);
    if(updated){
      int index = users.indexWhere((element) => element.id == user.id);
      if(index != -1){
        users[index] = user;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<bool> delete({required int id}) async {
    bool deleted = await _userDbController.delete(id);
    if(deleted){
      int index = users.indexWhere((element) => element.id == id);
      if(index != -1){
        users.removeAt(index);
        notifyListeners();
        return true;
      }
    }
    return false;
  }
  // Future<bool> addLocation({required Location location}) async {
  //   int createLocation = await _userDbController.createLocation(location);
  //
  //   return true;
  // }
}