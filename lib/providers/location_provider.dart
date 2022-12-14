import 'package:flutter/material.dart';
import 'package:todo_emp/controller/LocationDbController.dart';
import 'package:todo_emp/main.dart';
import 'package:todo_emp/model/location.dart';

class LocationProvider extends ChangeNotifier {
  List<Location> locations = <Location>[];
  List<Location> locationsByIdTask = <Location>[];
  LocationDbController _locationDbController = LocationDbController();

  Future<bool> addLocation({required Location location}) async {
    int id = await _locationDbController.create(location);
    if (id != 0) {
      location.id = id;
      locations.add(location);
      notifyListeners();
      image_Id=null;
      return true;
    }
    return false;
  }

  Future<List<Location>?> read() async {
    locations = await _locationDbController.read();
    notifyListeners();
    return locations;
  }
  Future<List<Location>?> readByTask(int taskId) async {
    locationsByIdTask.clear();
    locationsByIdTask = await _locationDbController.readByTask(taskId);
    notifyListeners();
    return locationsByIdTask;
  }
  // Future<List<Location>?> show(int task_id) async {
  //   //SELECT * FROM categories WHERE}) async {
  //   locationas = await _locationDbController.show(task_id);
  //   notifyListeners();
  //   return locationas;
  // }

  Future<List<Location>?> lastRow() async {
    locations = await _locationDbController.lastRow();
    notifyListeners();
    return locations;
  }

  Future<bool> update({required Location location}) async {
    bool updated = await _locationDbController.update(location);
    if (updated) {
      int index = locations.indexWhere((element) => element.id == location.id);
      if (index != -1) {
        locations[index] = location;
        notifyListeners();
        return true;
      }
    }
    return false;
  }
  Future<bool> update2({required Location location}) async {
    bool updated = await _locationDbController.update1(location);
    if (updated) {
      int index = locations.indexWhere((element) => element.id == location.id);
      if (index != -1) {
        locations[index] = location;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<bool> delete(int id) async {
    bool deleted = await _locationDbController.delete(id);
    if (deleted) {
      int index = locations.indexWhere((element) => element.task_id == id);
      if (index != -1) {
        locations.removeAt(index);
        notifyListeners();
        return true;
      }
    }
    return false;
  }
}
