import 'package:todo_emp/model/taskModel.dart';

class BaseGenericArrayResponse<T> {

  late List<taskModel> tasks;

  BaseGenericArrayResponse.fromJson(Map<String, dynamic> json) {

    if (json['tasks'] != null) {
      print('not null task');
        tasks = <taskModel>[];
        json['tasks'].forEach((v) {
          tasks.add(taskModel.fromJson(v));
        });


    }
  }
}