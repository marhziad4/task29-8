import 'dart:io';
import 'package:flash/flash.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/api/api_settings.dart';
import 'package:todo_emp/controller/TaskDbController.dart';
import 'package:todo_emp/mixins/api_mixin.dart';
import 'package:todo_emp/mixins/helpersApi.dart';
import 'package:todo_emp/model/base_generic_array_response.dart';
import 'package:todo_emp/model/base_response.dart';
import 'package:todo_emp/model/location.dart';
import 'package:todo_emp/model/taskImage.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:todo_emp/providers/TaskProvider.dart';
import 'package:todo_emp/providers/images_provider.dart';
import 'package:todo_emp/providers/location_provider.dart';

class TaskApiController with ApiMixin, HelpersApi {
  //{required BuildContext context}
  String id_pk='0';
  Future<List<taskModel>> getTasks() async {
    var url = Uri.parse(ApiSettings.getTask);
    var response = await http.get(url, headers: requestHeaders);
    var jsonResponse =  jsonDecode(response.body);
    var jsonResponseBody = jsonDecode(response.body)['tasks'] as List;

    if (response.statusCode == 200) {
      // print(jsonResponse);
      // print('id_pk ${jsonResponse['tasks'][0]['id_pk']}');
      id_pk=jsonResponse['tasks'][0]['id_pk'];
      await TaskProvider().update2(task: task);
       List<taskModel> tasksList = <taskModel>[];
      jsonResponseBody.forEach((v) {
        print(v);
        tasksList.add(new taskModel.fromJson2(v));
        for(int i =0 ;i<=tasksList.length;i++){
          print(i);
        }

      });

        return tasksList;
        // BaseGenericArrayResponse<Tasks> genericArrayResponse = BaseGenericArrayResponse.fromJson(jsonResponseBody);
        // return genericArrayResponse.tasks;
      }
      return [];

  }
  taskModel get task {
    taskModel task = taskModel();
    task.id_pk = id_pk;
    task.id = 1;
    // task.image = photoName.toString();

    return task;
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
        File? imageFile;
        // completeTasks.add(completeTasks[i].id);
        print('taskid   :$taskid');
        print('taskimage   :${completeTasks[i].image}');
        List<taskImage>? taskImagebyId =
            await Provider.of<ImagesProvider>(context, listen: false)
                .readId(taskid!);

        if (taskImagebyId!.isNotEmpty) {
          for (int i = 0; i < taskImagebyId.length; i++) {
            imageFile = File(
                '/storage/emulated/0/Pictures/pla_todo/${taskImagebyId[i].image}');

            taskImagebyId[i].image = base64Encode(imageFile.readAsBytesSync());
          }
        } else {
          print('image is empty');
        }

        List<Location>? Location1 = await LocationProvider().readByTask(taskid);

        newList.add({
          "info": completeTasks[i],
          "locations": (Location1!.length > 0) ? Location1 : null,
          'photos': (taskImagebyId.length > 0) ? taskImagebyId : null
        });
      }

      var body = jsonEncode({"tasks": newList});
      print(body);
      var url = Uri.parse(ApiSettings.ADDTASKS);

      var response = await http.post(url, body: body, headers: requestHeaders);
      print("no ${response.statusCode}");
      print("no ${response.body}");

      if (isSuccessRequest(response.statusCode)) {
        print("no ${response.statusCode}");
        print('${response.body}');
        if (response.statusCode == 200) {
          await Provider.of<TaskProvider>(context, listen: false).read2();

          Provider.of<TaskProvider>(context, listen: false).completeTasks;

          Provider.of<TaskProvider>(context, listen: false).doneAsync;


          for (int i = 0; i < completeTasks.length; i++) {
            completeTasks[i].async = 1;
            Provider.of<TaskProvider>(context, listen: false)
                .update(task: completeTasks[i]);
            // TaskProvider().update(task: completeTasks![i]);
          }
        }
        Provider.of<TaskProvider>(context, listen: false).completeTasks;
        Provider.of<TaskProvider>(context, listen: false).doneAsync;
        // Navigator.pushNamed(context, '/TodoMainPage');

        Navigator.pop(context);
        context.showFlashDialog(
          persistent: true,
          title: Text(''),
          content: Text('تم ترحيل المهام '),


        );
        return true;
      } else if (response.statusCode == 401) {
        context.showFlashDialog(
          persistent: true,
          title: Text(''),
          content: Text('خطا في تسجيل الدخول '),


        );
        // showSnackBar(
        //     context: context, message: 'خطا في تسجيل الدخول', error: true);
        // await UserApiController().logout(context: context);
        // Navigator.pushReplacementNamed(context, '/Login_screen');

      } else {
        handleServerError(context);
      }
    } else {
      showFlash(
        context: context,
        duration: const Duration(seconds: 3),
        builder: (_, c) {
          return Flash(
            controller: c,
            barrierDismissible: false,
            alignment: const Alignment(0, 0.8),
            borderRadius: BorderRadius.circular(12),
            backgroundColor: Colors.black87,
            margin: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 12),
            child: const Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                "لا يوجد مهام لترحيلها",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      );
    }

    return false;
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

// BaseGenericArrayResponse<Tasks> genericArrayResponse = BaseGenericArrayResponse.fromJson(jsonResponseBody);
// return genericArrayResponse.tasks;
