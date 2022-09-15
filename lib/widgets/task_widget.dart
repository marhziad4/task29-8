import 'dart:convert';

import 'package:cron/cron.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/main.dart';
import 'package:todo_emp/model/location.dart';
import 'package:todo_emp/model/taskImage.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:todo_emp/preferences/user_pref.dart';
import 'package:todo_emp/providers/TaskProvider.dart';
import 'package:todo_emp/providers/images_provider.dart';
import 'package:todo_emp/providers/location_provider.dart';
import 'package:todo_emp/screen/MapScreen.dart';
import 'package:todo_emp/screen/to_do_ui/control/EditTaskScreen.dart';
import 'package:todo_emp/utils/helpers.dart';

class TaskWidget extends StatefulWidget {
  taskModel task;

  TaskWidget(this.task);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> with Helpers {
  // bool visible = true;
  String chek = 'false';

  final cron = Cron();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<TaskProvider>(builder: (context, provider, x) {
      return InkWell(
        onTap: () async {
          if(widget.task.counter!=0){
            await Provider.of<ImagesProvider>(context, listen: false)
                .readId(widget.task.id??0);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MapScreen(widget.task)));
          }else{
            context.showFlashDialog(
              persistent: true,
              title:  Text('يجب بدء المهمة'),
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
                            Text(
                              widget.task.id.toString() + ") ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.black87),
                            ),
                            Text(
                              widget.task.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.black87),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: 25.0,
                              ),
                              color: Colors.grey, //<-- SEE HERE

                              onPressed: () async {
                                // int v=await Provider.of<TaskProvider>(context, listen: false)
                                //   .counterCmp;
                                // print('counter$v');
                                // asyncTasks = await TaskProvider().readAsync();
                                // if (asyncTasks!.isEmpty) {
                                //   print('null');
                                // } else {
                                //   for (int i = 0; i < asyncTasks!.length; i++) {
                                //     print(
                                //         'index ${i} id ${asyncTasks![i].id} details ${asyncTasks![i].details}'
                                //             'image ${asyncTasks![i].image} isDeleted ${asyncTasks![i].isDeleted}  '
                                //             ' status ${asyncTasks![i].status} '
                                //             ' counter ${asyncTasks![i].counter} '
                                //             ' async ${asyncTasks![i].async} '
                                //             ' title ${asyncTasks![i].title}');
                                //   }
                                // }
                                List<taskModel>?completeTasks;
                                 completeTasks = await TaskProvider().read2();
                                 if (completeTasks!.isEmpty) {
                                   print('null');
                                 } else {
                                   for (int i = 0; i < completeTasks.length; i++) {
                                     print(
                                         'index ${i} id ${completeTasks[i].id} details ${completeTasks[i].details}'
                                             'image ${completeTasks[i].image} isDeleted ${completeTasks[i].isDeleted}  '
                                             ' status ${completeTasks[i].status} '
                                             ' counter ${completeTasks[i].counter} '
                                             ' async ${completeTasks[i].async} '
                                             ' title ${completeTasks[i].title}');
                                   }
                                 }
                                List<taskModel>? TasksImage;
                                TasksImage = await Provider.of<TaskProvider>(
                                        context,
                                        listen: false)
                                    .read();
                                print(jsonEncode(TasksImage));
                                print("____________________________");
                                // print('chek : ${UserPreferences().chek}}');
                                // List<taskModel>? Tasks;
                                // Tasks = await Provider.of<TaskProvider>(context, listen: false).read();
                                // // asyncTasks =Provider.of<TaskProvider>(context, listen: false).asyncTasks;
                                // if (Tasks!.isEmpty) {
                                //   print('null');
                                // } else {
                                //   for (int i = 0; i < Tasks.length; i++) {
                                //     print(
                                //         'index ${i} id ${Tasks[i].id} details ${Tasks[i].details}'
                                //             'image ${Tasks[i].image} isDeleted ${Tasks[i].isDeleted}  '
                                //             ' status ${Tasks[i].status} '
                                //             ' counter ${Tasks[i].counter} '
                                //             ' async ${Tasks[i].async} '
                                //             ' chek ${Tasks[i].chek} '
                                //         //   ' img ${Tasks[i].image} '
                                //             ' title ${Tasks[i].title}');
                                //   }
                                // }

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditTaskScreen(widget.task)));
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  size: 25.0,
                                ),
                                color: Colors.grey, //<-- SEE HERE

                                onPressed: () async {
                                  // AlertDialog(
                                  //   content: new Text("هل تريد حذف المهمة؟ "),
                                  //   actions: <Widget>[
                                  //     new ElevatedButton(
                                  //       child: new Text("موافق"),
                                  //       onPressed: () async {
                                  //         await Provider.of<TaskProvider>(
                                  //             context, listen: false)
                                  //             .delete(task.id);
                                  //       },
                                  //     ),
                                  //     new ElevatedButton(
                                  //       child: new Text("الغاء"),
                                  //       onPressed: ()  {
                                  //         Navigator.pop(context);
                                  //       },
                                  //     ),
                                  //   ],
                                  // );
                                  if (widget.task.status == false) {
                                    showSnackBar(
                                        context: context,
                                        content:
                                            'الرجاء انتهاء المهمة قبل الحذف',
                                        error: true);
                                  } else {
                                    await Provider.of<TaskProvider>(context,
                                            listen: false)
                                        .delete(widget.task.id??0);
                                    widget.task.isDeleted = 1;
                                    // TaskProvider().update(task: widget.task);
                                    await Provider.of<TaskProvider>(context,
                                            listen: false)
                                        .update(task: widget.task);
                                    await Provider.of<TaskProvider>(context,
                                            listen: false)
                                        .readAll();

                                    showSnackBar(
                                        context: context,
                                        content: 'تم الحذف',
                                        error: false);
                                  }
                                }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
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



// completeTasks = await TaskProvider().read2();

                                setState(() {
                                  if (widget.task.counter == 0 &&
                                      widget.task.chek == 'false') {
                                    chek = 'true';
                                    UserPreferences().setChek(chek);
                                    print('1${UserPreferences().chek}');
                                    widget.task.counter = 1;
                                    widget.task.status = 1;
                                    task_id = widget.task.id??0;

                                    widget.task.chek = UserPreferences().chek;
                                    Provider.of<TaskProvider>(context,
                                            listen: false)
                                        .update(task: widget.task);
                                    cron.schedule(Schedule.parse('*/1 * * * *'),
                                            () async {
                                              print('every one minutes');

                                              print('Cron readLocation');

                                          readLocation();
                                        });

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
                                        .update(task: widget.task);
                                    Provider.of<TaskProvider>(context,
                                        listen: false).read();
                                    Provider.of<TaskProvider>(context, listen: false).read2();

                                    Provider.of<TaskProvider>(context, listen: false).completeTasks;
                                    Provider.of<TaskProvider>(context, listen: false).completeTasks.length;

                                  }
                                });
//  await Provider.of<TaskProvider>(context, listen: false).readAll();
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
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Spacer(),

                            Text(
                              widget.task.time,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.blueGrey),
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
