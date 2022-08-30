import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/api/api_settings.dart';
import 'package:todo_emp/controller/TaskDbController.dart';
import 'package:todo_emp/main.dart';
import 'package:todo_emp/mixins/api_mixin.dart';
import 'package:todo_emp/mixins/helpersApi.dart';
import 'package:todo_emp/model/location.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:http/http.dart' as http;
import 'package:todo_emp/providers/TaskProvider.dart';
import 'package:todo_emp/providers/location_provider.dart';

class TaskApiController with ApiMixin, HelpersApi {
  Future<List<taskModel>> getTasks({required BuildContext context}) async {
    var url = Uri.parse(ApiSettings.TASKS);
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      print('hello');
      var jsonResponseBody = jsonDecode(response.body)
          .map(((e) => taskModel.fromJson(e)))
          .toList();
      TaskDbController().create(jsonResponseBody);
      print(jsonResponseBody);
      return jsonResponseBody;
      // BaseGenericArrayResponse<Tasks> genericArrayResponse = BaseGenericArrayResponse.fromJson(jsonResponseBody);
      // return genericArrayResponse.tasks;
    }
    return [];
  }

  Future createTask({required BuildContext context}) async {
    //
     List<Map> newList= [] ;

     if(completeTasks!.isNotEmpty){
       for (int i = 0; i < completeTasks!.length; i++) {
         var taskid = completeTasks![i].id;
         print(taskid);
         List<Location>? Location1 = await LocationProvider().readByTask(taskid);

         if(Location1!.length>0)
           newList.add({"info":completeTasks![i],"locations":Location1});
         else newList.add({"info":completeTasks![i],"locations":null});
         print('completeTasks');

         for (int j = 0; j < Location1.length; j++) {
           print( jsonEncode(Location1[j]));
         }

         print('completeTasks');

         for (int j = 0; j < completeTasks!.length; j++) {
           print( jsonEncode(completeTasks![j]));
         }
         // print('asyncTasks');
         // for (int j = 0; j < asyncTasks!.length; j++) {
         //   print( jsonEncode(asyncTasks![j]));
         // }
       }
     }else{
       print('no data');

     }

    var body = jsonEncode({"tasks": newList});
     print(body);
    var url = Uri.parse(ApiSettings.ADDTASKS);

    var response = await http.post(url, body: body, headers: requestHeaders);
    print("no");
    print("$response");

    if (isSuccessRequest(response.statusCode)) {
      print("no ${response.statusCode}");
      print('${response.body}');
      if (response.statusCode == 200) {
        print('async');
        for (int i = 0; i < completeTasks!.length; i++) {
          print('here');
          completeTasks![i].async = 1;
          Provider.of<TaskProvider>(context, listen: false).update(task: completeTasks![i]);
          // TaskProvider().update(task: completeTasks![i]);
          print('async');
        }
      }

    } else if (response.statusCode != 500) {
      print("no ${response.statusCode}");
    } else {
      print("no ${response.statusCode}");

      handleServerError(context);
    }

    return null;
  }

  Future<bool> deleteTask(BuildContext context, {required int id}) async {
    var response = await http.delete(getUrl(ApiSettings.TASKS + '/$id'),
        headers: requestHeaders);

    if (isSuccessRequest(response.statusCode)) {
      return true;
    } else if (response.statusCode != 500) {
      showMessage(context, response, error: true);
    } else {
      handleServerError(context);
    }

    return false;
  }

  Future<bool> updateTask(BuildContext context,
      {required taskModel task}) async {
    var response = await http.put(getUrl(ApiSettings.TASKS + '/${task.id}'),
        headers: requestHeaders);

    if (isSuccessRequest(response.statusCode)) {
      return true;
    } else if (response.statusCode != 500) {
      showMessage(context, response, error: true);
    } else {
      handleServerError(context);
    }
    return false;
  }
}
//   return (response.data as List).map((employee) {
//     print('Inserting $employee');
//     DBProvider.db.createEmployee(Employee.fromJson(employee));
//     return await _database.insert('tasks', object.toMap());
//     TaskDbController().create(task);
//   }).toList();
// }
// print(requestHeaders);

// var jsonResponse = jsonDecode(response.body);
//  print("hhhh>>${jsonResponse}");
// var jsonObject = jsonResponse['tasks'];
// return Tasks.fromJson(jsonResponse);



















// newList.add({
//   'title':title,/*
//   'description':description,
//   'done':done.toString(),
//       'start_date':start_date,
//       'end_date':end_date,
//       'status':status,
//       'create_user':create_user,
//       'update_user':update_user,
//       'priority':priority,
//       'create_dept':create_dept,
//       'to_dept':to_dept,
//       'userId':userId*/
// });
// newList.add({
//   'title':title,/*
//   'description':description,
//   'done':done.toString(),
//       'start_date':start_date,
//       'end_date':end_date,
//       'status':status,
//       'create_user':create_user,
//       'update_user':update_user,
//       'priority':priority,
//       'create_dept':create_dept,
//       'to_dept':to_dept,
//       'userId':userId*/
// });
// newList.add({
//   'title':title,/*,
//   'description':description,
//   'done':done.toString(),
//       'start_date':start_date,
//       'end_date':end_date,
//       'status':status,
//       'create_user':create_user,
//       'update_user':update_user,
//       'priority':priority,
//       'create_dept':create_dept,
//       'to_dept':to_dept,
//       'userId':userId*/
// });

// List<List<dynamic>?> TaskWithLocation = [];
//print(jsonEncode(completeTasks));