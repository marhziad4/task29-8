import 'dart:convert';

import 'package:cron/cron.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/main.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:todo_emp/preferences/user_pref.dart';
import 'package:todo_emp/providers/TaskProvider.dart';
import 'package:todo_emp/providers/images_provider.dart';
import 'package:todo_emp/screen/MapScreen.dart';
import 'package:todo_emp/utils/helpers.dart';

class TaskWidgetAdmin extends StatefulWidget {
  taskModel task;

  TaskWidgetAdmin(this.task);

  @override
  State<TaskWidgetAdmin> createState() => _TaskWidgetAdminState();
}

class _TaskWidgetAdminState extends State<TaskWidgetAdmin> with Helpers {
  // bool visible = true;
  String chek = 'false';

  final cron = Cron();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<TaskProvider>(builder: (context, provider, x) {
      return InkWell(
        onTap: () async {
          if (widget.task.counter != 0) {
            await Provider.of<ImagesProvider>(context, listen: false)
                .readId(widget.task.id ?? 0);
            // Provider.of<LocationProvider>(context, listen: false).readByTask(task_id);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MapScreen(widget.task)));
          } else {
            context.showFlashDialog(
              persistent: true,
              title: Text('يجب بدء المهمة'),
              content: Text(''),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SizedBox(
            height: 200,
            child: Card(
              // width: double.infinity,
              // height: 200.h,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 0.16,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.symmetric(horizontal: 15),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   borderRadius: BorderRadius.circular(25.r),
              //   boxShadow: AppShadow.shadow036,
              // ),
              child: Stack(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                        width: 0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            // Text(
                            //   widget.task.id.toString() + ") ",
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 25,
                            //       color: Colors.black87),
                            // ),
                            Text(
                              widget.task.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35),
                        child: Row(
                          children: [
                            Text(
                              widget.task.description,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black87),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () async {
                                // print('-1${UserPreferences().chek}');
                                // await UserPreferences().setChek(true);
                                // print('-2${UserPreferences().chek}');
                                // List<Location>? Location1 = await LocationProvider().readByTask(1);
                                //
                                //
                                // for (int j = 0; j < Location1!.length; j++) {
                                //   print('jsonEncode${ jsonEncode(Location1[j])}');
                                // }
                                // print('jsonEncode${ jsonEncode(Location1)}');

                                print(widget.task.counter);
                                print(widget.task.id);
                                print(widget.task.status);
                                print(UserPreferences().chek);
                                // completeTasks = await TaskProvider().read2();
                                //status false => شغال
                                List<taskModel>? tasks;

                                tasks = await TaskProvider().read();

                                //&& tasks![i].status ==false && chek==false&&widget.task.counter ==1
                                if (widget.task.counter == 0 &&
                                    UserPreferences().chek == 'true') {
                                  showSnackBar(
                                      context: context,
                                      content: 'هناك مهمة قيد العمل',
                                      error: true);
                                } else if (widget.task.counter == 1 &&
                                    UserPreferences().chek == 'true') {
                                  showSnackBar(
                                      context: context,
                                      content: 'تم انجاز المهمة',
                                      error: false);
                                }

                                setState(() {
                                  if (widget.task.counter == 0 &&
                                      widget.task.chek == 'false') {
                                    chek = 'true';
                                    UserPreferences().setChek(chek);
                                    print('1${UserPreferences().chek}');
                                    Provider.of<TaskProvider>(context,
                                            listen: false)
                                        .update(task: widget.task);
                                    widget.task.counter = 1;
                                    widget.task.status = 1;
                                    taskId = widget.task.id ?? 0;
                                    widget.task.chek = UserPreferences().chek;

                                    Provider.of<TaskProvider>(context,
                                            listen: false)
                                        .update3(task: widget.task);
                                    cron.schedule(Schedule.parse('*/1 * * * *'),
                                        () async {
                                      readLocation();
                                    });

                                    // Provider.of<TaskProvider>(context,
                                    //     listen: false)
                                    //     .update(task: widget.task);
//       status = tasks[i].status;
                                    //    print(" ${UserPreferences().chek}");
                                  } else if (widget.task.counter == 1 &&
                                      widget.task.chek == 'true') {
                                    //     print(" ${UserPreferences().chek}");

                                    chek = 'false';
                                    UserPreferences().setChek(chek);
                                    //    print('2${UserPreferences().chek}');
                                    widget.task.status = 0;
                                    widget.task.counter = 2;
                                    widget.task.chek = UserPreferences().chek;

                                    Provider.of<TaskProvider>(context,
                                            listen: false)
                                        .update4(task: widget.task);

                                    // Provider.of<TaskProvider>(context,
                                    //     listen: false)
                                    //     .read();
                                    // Provider.of<TaskProvider>(context,
                                    //     listen: false)
                                    //     .read2();

                                  }
                                });
                                await Provider.of<TaskProvider>(context,
                                        listen: false)
                                    .readAll();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                height: 40,
                                width: 100,
                                child: widget.task.counter == 2
                                    ? Container(
                                        child: Text(
                                        'تمت المهمة',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ))
                                    : widget.task.counter == 0
                                        ? Text(
                                            'بدء المهمة',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          )
                                        : Text(
                                            'انهاء المهمة',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                decoration: BoxDecoration(
                                    color: widget.task.status == 0
                                        ? Color(0xff1A6FD1)
                                        : Color(0xff338f2f),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 90, vertical: 30),
                        child: Row(
                          children: [
                            //.replaceRange(0,11, '')
                            Text(
                              widget.task.time,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.blueGrey),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              widget.task.date,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.blueGrey),
                            ),
                          ],
                        ),
// Checkbox(
//   value:value ,
//     //Provider.of<DatabaseProvider>(context).isComplete
//   onChanged: (value) {
//     Provider.of<DatabaseProvider>(context, listen: false)
//         .changeIsCompleteOnNewTaskScreen();
//   },
//   title: Text('I have complete this task'),
// ),
                      ),
// const SizedBox(
//   height: 25,
//   width: 0,
// ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
//   child: ListTile(
//     trailing: IconButton(
//       icon: Icon(Icons.delete),
//       onPressed: () {
//         // Provider.of<TaskProvider>(context,listen: false).delete(id:provider.tasks[index].id);
//       },
//     ),
//     title: Text(
//       provider.tasks[index].title,
//       style: TextStyle(fontWeight: FontWeight.bold),
//     ),
//       subtitle: Text(provider.tasks[index].description),
//
//   ),
      );
    });
  }
}
