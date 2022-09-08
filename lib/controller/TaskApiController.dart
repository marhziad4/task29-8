import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/api/api_settings.dart';
import 'package:todo_emp/controller/TaskDbController.dart';
import 'package:todo_emp/mixins/api_mixin.dart';
import 'package:todo_emp/mixins/helpersApi.dart';
import 'package:todo_emp/model/location.dart';
import 'package:todo_emp/model/taskImage.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:http/http.dart' as http;
import 'package:todo_emp/preferences/user_pref.dart';
import 'package:todo_emp/providers/TaskProvider.dart';
import 'package:todo_emp/providers/images_provider.dart';
import 'package:todo_emp/providers/location_provider.dart';
import 'package:todo_emp/utils/helpers.dart';

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
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/Pictures/pla_todo/text.txt');
  }
  Future createTask({required BuildContext context}) async {
    //
    List<Map> newList = [];
    List<taskModel>? completeTasks;
    completeTasks = await TaskProvider().read2();
    List<taskImage>? TasksImage;
    if (completeTasks!.isNotEmpty) {
      for (int i = 0; i < completeTasks.length; i++) {
        var taskid = completeTasks[i].id;
        File ?imageFile;
        print('taskid   :$taskid');
        print('taskimage   :${completeTasks[i].image}');
        List<taskImage>? taskImagebyId =await Provider.of<ImagesProvider>(context, listen: false).readId(taskid);

        if(taskImagebyId!.isNotEmpty){
          for(int i = 0; i < taskImagebyId.length; i++){
            //print('taskimage   :${taskImagebyId[i].image}');

            // final path = '/storage/emulated/0/Pictures/pla_todo/${TasksImage[i].image}';
            // final checkPathExistence = await Directory(path).exists();
            // print(checkPathExistence);
            imageFile= File('/storage/emulated/0/Pictures/pla_todo/${taskImagebyId[i].image}');

            taskImagebyId[i].image=base64Encode(imageFile.readAsBytesSync());
            // print(imageFile);
            // print('${  base64Encode(imageFile.readAsBytesSync())}');
            // print(imageFile);
          }

        }else{
          print('image is empty');
        }



        List<Location>? Location1 = await LocationProvider().readByTask(taskid);

          newList.add({"info": completeTasks[i], "locations": (Location1!.length > 0)?Location1:null,  'photos': (taskImagebyId.length >0) ?
          taskImagebyId : null});

        // print('Location1');
        //
        // for (int j = 0; j < Location1.length; j++) {
        //   print(jsonEncode(Location1[j]));
        // }
       // print(UserPreferences().token);

        // for (int j = 0; j < completeTasks.length; j++) {
        //   print(jsonEncode(completeTasks[j]));
        // }
        // List<taskModel>? NotAsync;
        // NotAsync = await TaskProvider().NotAsync1();
        // print('NotAsync');
        // for (int j = 0; j < NotAsync!.length; j++) {
        //   print(jsonEncode(NotAsync[j]));
        // }
      }
      var body = jsonEncode({"tasks": newList});
      print(body);
      var url = Uri.parse(ApiSettings.ADDTASKS);

      var response = await http.post(url, body: body, headers: requestHeaders);
      print("no ${response.statusCode}");

      if (isSuccessRequest(response.statusCode)) {
        print("no ${response.statusCode}");
        print('${response.body}');
        if (response.statusCode == 200) {
          showSnackBar(
              context: context, message: 'تم الترحيل', error: false);
          print('async');
          print('${response.body}');

          for (int i = 0; i < completeTasks.length; i++) {
            print('here');
            completeTasks[i].async = 1;
            Provider.of<TaskProvider>(context, listen: false)
                .update(task: completeTasks[i]);
            // TaskProvider().update(task: completeTasks![i]);
            print('async');
          }
        }
      } else if (response.statusCode == 401) {
        print("no ${response.statusCode}");

        showSnackBar(
            context: context, message: 'خطا في تسجيل الدخول', error: true);
        // await UserApiController().logout(context: context);
        // Navigator.pushReplacementNamed(context, '/Login_screen');

      } else {
        print("no ${response.statusCode}");

        handleServerError(context);
      }
    } else {
      showSnackBar(
          context: context, message: 'لا يوجد مهام لترحيلها', error: true);
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
