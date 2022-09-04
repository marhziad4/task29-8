import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_emp/controller/TaskDbController.dart';
import 'package:todo_emp/model/taskModel.dart';

import '../main.dart';

class TaskProvider extends ChangeNotifier {
  List<taskModel> tasks = <taskModel>[];
  List<taskModel> taskss = <taskModel>[];
  // List<taskModel> isDeletedTasks = <taskModel>[];
  List<taskModel> completeTasks = <taskModel>[];
  List<taskModel> doneAsync= <taskModel>[];
  List<taskModel> NotAsync= <taskModel>[];

  TaskDbController _taskDbController = TaskDbController();

  TaskProvider() {
    // print('TaskProvider');
    //print(jsonEncode(taskss));

    read();
    read2();
    // readCounter(counter);
  }

  Future<bool> readAll() async {

    taskss.clear();
    taskss = await _taskDbController.read();
     taskss.reversed;
    notifyListeners();
    //============================
    completeTasks.clear();
    completeTasks = await _taskDbController.read2();
    completeTasks.reversed;
// print(jsonEncode(completeTasks));
    notifyListeners();

    //====================
    doneAsync.clear();
    doneAsync = await _taskDbController.doneAsync();
    notifyListeners();

    return true;

  }

  // fillTasksLists(List<taskModel> tasks) {
  //   taskss = tasks;
  //   completeTasks = tasks.where((element) => element.counter==2).toList();
  //   asyncTasks = tasks.where((element) => element.async==0).toList();
  //   notifyListeners();
  // }

  Future<bool> create({required taskModel task}) async {
    //  taskModel task = taskModel()
    int id = await _taskDbController.create(task);
    taskss.clear();
    taskss = await _taskDbController.read();

    notifyListeners();
    return true;

  }

  Future<List<taskModel>?> read() async {
    completeTasks.clear();
    // completeTasks = await _taskDbController.read2();
    taskss = await _taskDbController.read();

    // print(jsonEncode(completeTasks));
    // print(jsonEncode(taskss));
    notifyListeners();
    notifyListeners();
    return taskss;
  }
  Future<List<taskModel>?> read2() async {
    // print('completeTasks');
    completeTasks = await _taskDbController.read2();

    notifyListeners();
    return completeTasks;
  }
  Future<List<taskModel>?> readAsync() async {
    doneAsync = await _taskDbController.doneAsync();
    notifyListeners();
    return doneAsync;
  }
  Future<List<taskModel>?> NotAsync1() async {
    NotAsync = await _taskDbController.TaskNotAsync();
    notifyListeners();
    return NotAsync;
  }




  Future<bool> update({required taskModel? task}) async {
    bool updated = await _taskDbController.update(task!);

    int index = tasks.indexWhere((element) => element.id == task.id);
    if (index != -1) {
      //completeTasks.removeAt(index);
      readAll();
      notifyListeners();
      return true;
    }
    return false;
  }


  Future<bool> update1({required taskModel task}) async {
    bool updated = await _taskDbController.update1(task);
    if (updated) {
      int index = tasks.indexWhere((contact) => contact.id == task.id);
      //taskss[index] = task;
      notifyListeners();
    }
    notifyListeners();
    readAll();
    return updated;
  }

  Future<bool> updateRow({required taskModel task}) async {
    bool updated = await _taskDbController.update(task);
    if (updated) {
      int index = tasks.indexWhere((contact) => contact.id == task.id);
      //taskss[index] = task;
      notifyListeners();
    }
    return updated;
  }

  Future<bool> delete(int id) async {
     bool deleted = await TaskDbController().delete(id);

    int index = tasks.indexWhere((element) => element.id == id);
    if (index != -1) {
      //completeTasks.removeAt(index);
      readAll();
      notifyListeners();
      return true;
    }
    return false;
  }
}
