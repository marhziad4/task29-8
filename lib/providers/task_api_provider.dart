import 'package:flutter/material.dart';
import 'package:todo_emp/controller/TaskApiController.dart';
import 'package:todo_emp/model/taskModel.dart';

import '../model/tasks.dart';

class TasksApiProvider extends ChangeNotifier{
  List<taskModel> tasks = [];
  TaskApiController _tasksApiController =TaskApiController();
   bool _Loading = false;

  void _startLoading(){
    _Loading =true;
}
  void _stopLoading(){
    _Loading =false;
  }
  bool get loading => _Loading;
}