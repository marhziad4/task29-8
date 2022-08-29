import 'package:flutter/material.dart';
import 'package:todo_emp/controller/TaskApiController.dart';
import 'package:todo_emp/model/taskModel.dart';

import '../model/tasks.dart';

class TasksApiProvider extends ChangeNotifier{
  List<Tasks> tasks = [];
  TaskApiController _tasksApiController =TaskApiController();
   bool _Loading = false;

  // Future<void> getTasks({required BuildContext context})async{
  //    _startLoading();
  //   List<taskModel> data = await _tasksApiController.getTasks(context: context);
  //   if(data.isNotEmpty){
  //     tasks=data;
  //     _stopLoading();
  //     notifyListeners();
  //   }
  // }
  //

  // Future<bool> createTask(
  //     {required BuildContext context, required Tasks newTask}) async {
  //   Tasks? task = await TaskApiController().createTask(context, task: newTask);
  //   if (task != null) {
  //     tasks.add(task);
  //     notifyListeners();
  //     return true;
  //   }
  //   return false;
  // }

  Future<bool> deleteTask(
      {required BuildContext context, required int id}) async {
    bool deleted = await _tasksApiController.deleteTask(context, id: id);
    if (deleted) {
      int index = tasks.indexWhere((element) => element.id == id);
      if (index != -1) {
        tasks.removeAt(index);
        notifyListeners();
        return true;
      }
    }
    return false;
   }

  // Future<bool> updateTask(
  //     {required BuildContext context, required taskModel updatedTask}) async {
  //   bool updated =
  //   await _tasksApiController.updateTask(context, task: updatedTask);
  //   if (updated) {
  //     int index = tasks.indexWhere((element) => element.id == updatedTask.id);
  //     if (index != -1) {
  //       tasks[index] = updatedTask;
  //     }
  //     return true;
  //   }
  //   return false;
  // }

  void _startLoading(){
    _Loading =true;
}
  void _stopLoading(){
    _Loading =false;
  }
  bool get loading => _Loading;
}