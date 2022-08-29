import 'package:todo_emp/model/taskModel.dart';

class BaseGenericArrayResponse<T> {

  late List<T> tasks;

  BaseGenericArrayResponse.fromJson(Map<String, dynamic> json) {

    if (json['tasks'] != null) {
      if(T == taskModel){
        tasks = <T>[];
        json['tasks'].forEach((v) {
          tasks.add(taskModel.fromJson(v) as T);
        });
      }
    }
  }
}