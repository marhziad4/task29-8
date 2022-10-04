import 'dart:io';
import 'package:flash/flash.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/api/api_settings.dart';
import 'package:todo_emp/mixins/api_mixin.dart';
import 'package:todo_emp/mixins/helpersApi.dart';
import 'package:todo_emp/model/location.dart';
import 'package:todo_emp/model/taskImage.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:todo_emp/preferences/user_pref.dart';
import 'package:todo_emp/providers/TaskProvider.dart';
import 'package:todo_emp/providers/images_provider.dart';
import 'package:todo_emp/providers/location_provider.dart';

class TaskApiController with ApiMixin, HelpersApi {
  String id_pk = '0';
  String title = '0';
  String description = '0';
  String start_date = '0';
  String end_date = '0';
  String create_date = '0';
  String update_date = '0';

  Future<List<taskModel>> getTasks({required BuildContext context}) async {
    var url = Uri.parse(ApiSettings.getTask);
    var response = await http.get(url, headers: requestHeaders);
    print("no ${response.statusCode}");
    print("no ${response.body}");
    var jsonResponseBody = jsonDecode(response.body)['tasks'] as List;
    if (jsonResponseBody.isNotEmpty) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var jsonResponseBody = jsonDecode(response.body)['tasks'] as List;
        id_pk = jsonResponse['tasks'][0]['id_pk'];
        print(jsonResponseBody);
        List<taskModel> tasksList = <taskModel>[];
        jsonResponseBody.forEach((v) async {
          print(v);
          tasksList.add(new taskModel.fromJson2(v));

          id_pk = v['id_pk'];
          title = v['title'];
          description = v['description'];
          start_date = v['start_date'];
          end_date = v['end_date'];
          create_date = v['create_date'];
          update_date = v['update_date'];
          bool saved = await TaskProvider().create(task: tasks);
          await Provider.of<TaskProvider>(context, listen: false).readTaskAd();

          print(v['id_pk']);
        });
        return tasksList;
      }
    }

    return [];
  }

  taskModel get tasks {
    taskModel task = taskModel();
    task.title = title;
    task.userId = UserPreferences().IdUser;
    task.id_pk = id_pk;
    task.description = description;
    task.status = 0;
    task.counter = 0;
    task.isDeleted = 0;
    task.chek = UserPreferences().chek;
    task.date = start_date;
    task.time = start_date;
    task.details = null;
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
          content: Text('يرجى اعادة تسجيل الدخول '),
        );
        // showSnackBar(
        //     context: context, message: 'خطا في تسجيل الدخول', error: true);

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
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
}
