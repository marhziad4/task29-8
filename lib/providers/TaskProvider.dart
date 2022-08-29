import 'package:flutter/material.dart';
import 'package:todo_emp/controller/TaskDbController.dart';
import 'package:todo_emp/model/taskModel.dart';

import '../main.dart';

class TaskProvider extends ChangeNotifier {
  List<taskModel> tasks = <taskModel>[];
  List<taskModel> taskss = <taskModel>[];
  List<taskModel> isDeletedTasks = <taskModel>[];
  List<taskModel> completeTasks = <taskModel>[];
  List<taskModel> asyncTasks= <taskModel>[];

  TaskDbController _taskDbController = TaskDbController();

  TaskProvider() {
    read();
    read2();
    // readCounter(counter);
  }

  fillTasksLists(List<taskModel> taasks) {
    //    tasks = tasks;
    //   int i=0;
    //   int index  = tasks.where((element) => !element.isDeleted);
    //   if (index != -1) {
    //     tasks.removeAt(index);
    //     notifyListeners();
    //     return true;
    //
    //   }
    //    // completeTasks.add(taasks);
    //   // isDeletedTasks = taasks.where((element) => !element.counter).toList();
    //   notifyListeners();
    //   int index = tasks.indexWhere((element) => element.counter == 2);
    //   if (index != -1)
    //     tasks.removeAt(index);
    //     notifyListeners();
    //     return true;
    //
    //   }
  }

  Future<bool> create({required taskModel task}) async {
    //  taskModel task = taskModel()
    int id = await _taskDbController.create(task);
    if (id != 0) {
      task.id = id;
      tasks.add(task);
      notifyListeners();
      return true;
    }
    return true;
  }

  Future<List<taskModel>?> read() async {
    tasks = await _taskDbController.read();
    notifyListeners();
    return tasks;
  }
  Future<List<taskModel>?> read2() async {
    completeTasks = await _taskDbController.read2();
    notifyListeners();
    return completeTasks;
  }
  Future<List<taskModel>?> readAsync() async {
    asyncTasks = await _taskDbController.readTaskAsync();
    notifyListeners();
    return asyncTasks;
  }




  Future<bool> update({required taskModel? task}) async {
    bool updated = await _taskDbController.update(task!);
    if (updated) {
      int index = tasks.indexWhere((contact) => contact.id == task.id);
      tasks[index] = task;
      notifyListeners();
    }
    notifyListeners();

    return updated;
  }

  Future<bool> update1({required taskModel task}) async {
    bool updated = await _taskDbController.update1(task);
    if (updated) {
      int index = tasks.indexWhere((contact) => contact.id == task.id);
      tasks[index] = task;
      notifyListeners();
    }
    notifyListeners();

    return updated;
  }

  Future<bool> updateRow({required taskModel task}) async {
    bool updated = await _taskDbController.update(task);
    if (updated) {
      int index = tasks.indexWhere((contact) => contact.id == task.id);
      tasks[index] = task;
      notifyListeners();
    }
    return updated;
  }

  Future<bool> delete(int id) async {
     bool deleted = await TaskDbController().delete(id);

    int index = tasks.indexWhere((element) => element.id == id);
    if (index != -1) {
      tasks.removeAt(index);
      notifyListeners();
      return true;
    }
    return false;
  }
}
