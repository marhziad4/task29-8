import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_emp/controller/ImageDbController.dart';
import 'package:todo_emp/controller/TaskDbController.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:todo_emp/providers/location_provider.dart';

import '../main.dart';

class TaskProvider extends ChangeNotifier {
  List<taskModel> tasks = <taskModel>[];
  List<taskModel> taskss = <taskModel>[];

  // List<taskModel> isDeletedTasks = <taskModel>[];
  List<taskModel> completeTasks = <taskModel>[];
  List<taskModel> readTaskAdmin = <taskModel>[];
  List<taskModel> doneAsync = <taskModel>[];
  List<taskModel> NotAsync = <taskModel>[];

  TaskDbController _taskDbController = TaskDbController();
  int? counterCmp;

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
    //====================
    readTaskAdmin.clear();
    readTaskAdmin = await _taskDbController.readTaskAdmin();
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

  Future<List<taskModel>?> readAllTask() async {
    completeTasks.clear();
    tasks = await _taskDbController.allTask();
    notifyListeners();
    return tasks;
  }

  Future<List<taskModel>?> read() async {
    completeTasks.clear();
    // completeTasks = await _taskDbController.read2();
    taskss = await _taskDbController.read();

    // print(jsonEncode(completeTasks));
    // print(jsonEncode(taskss));
    notifyListeners();
    return taskss;
  }

  Future<List<taskModel>?> read2() async {
    // print('completeTasks');
    completeTasks = await _taskDbController.read2();
    // counterCmp=completeTasks.length;
    counterCmp2();

    notifyListeners();
    return completeTasks;
  }

  Future<List<taskModel>?> readTaskAd() async {
    // print('completeTasks');
    readTaskAdmin = await _taskDbController.readTaskAdmin();
    // counterCmp=completeTasks.length;
    counterCmp2();

    notifyListeners();
    return readTaskAdmin;
  }

  int count = 0;

  Future<int> counterCmp2() async {
    for (int i = 0; i < completeTasks.length; i++) {
      count++;
    }
    counterCmp = completeTasks.length;

    notifyListeners();
    return completeTasks.length;
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

    int index = taskss.indexWhere((element) => element.id == task.id);
    if (index != -1) {
      taskss[index] = task;

      notifyListeners();
      return updated;
    }
    return updated;
  }

  Future<bool> update3({required taskModel? task}) async {
    bool updated = await _taskDbController.update3(task!);

    int index = taskss.indexWhere((element) => element.id == task.id);
    if (index != -1) {
      taskss[index] = task;

      notifyListeners();
      return updated;
    }
    return updated;
  }

  Future<bool> update4({required taskModel? task}) async {
    bool updated = await _taskDbController.update4(task!);

    int index = taskss.indexWhere((element) => element.id == task.id);
    if (index != -1) {
      taskss[index] = task;

      notifyListeners();
      return updated;
    }
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
    readAll();
    return updated;
  }

  Future<bool> update2({required taskModel task}) async {
    bool updated = await _taskDbController.update2(task);
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

  Future<bool> delete2(int task_id) async {

    return true;

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
