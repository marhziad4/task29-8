import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/controller/TaskApiController.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:todo_emp/providers/TaskProvider.dart';

import '../../providers/task_api_provider.dart';


class ApiTasksScreen extends StatefulWidget {
  @override
  State<ApiTasksScreen> createState() => _ApiTasksScreenState();
}

class _ApiTasksScreenState extends State<ApiTasksScreen> {
  late Future<List<taskModel>> _future;
  List<taskModel> tasks = <taskModel>[];
  List<taskModel> tasksAdmin = <taskModel>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = TaskApiController().getTasks();

    // print(jsonEncode(_future));

    // Provider.of<TasksApiProvider>(context, listen: false)
    //     .getTasks(context: context);
  }
  // @override
  // void initState() {
  //   super.initState();
  //   Provider.of<AllGoodsViewModel>(context, listen: false).fetchAllItems(id: widget.category.id);
  // }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //final model = Provider.of<AllGoodsViewModel>(context);
     return FutureBuilder<List<taskModel>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          tasksAdmin = snapshot.data!;
          return ListView.separated(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: 150,
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
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 25,
                              width: 0,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                              '${tasksAdmin[index].title}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        color: Colors.black87),


                            ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Row(
                                children: [
                                  Text(
                                    '${tasksAdmin[index].description}',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black87),
                                  ),

                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Spacer(),

                                Text(
                                    '${tasksAdmin[index].start_date}',
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
                                  width:10,
                                ),

                                Text(
                                  '${tasksAdmin[index].end_date}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.blueGrey),
                                ),
                              ],
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
                  );


            },
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: tasksAdmin.length,
          );
        } else {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.grey.shade500,
                  size: 80,
                ),
                Text(
                  'NO DATA',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
// ListView(
// children: [
// ...snapshot.data!.map((e) =>ListTile(
// title: Text(
// '${tasks[index].title} ${tasks[index].description}'),
// FutureBuilder<List<Tasks>>(
// future: TaskApiController().getTasks(),
// builder: (context, snapshot) {
// if  (snapshot.connectionState == ConnectionState.waiting) {
// print('length111111');
// return Center(child: CircularProgressIndicator());
// } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
// print('length2222222');
// tasks = snapshot.data!;
// print('length${tasks.length}');
// return ListView.separated(
// itemBuilder: (context, index) {
// return ListTile(
// title: Text(
// '${tasks[index].title} ${tasks[index].description}'),
// );
// },
// separatorBuilder: (context, index) {
// return Divider();
// },
// itemCount: tasks.length,
// );
// } else {
// return Center(
// child: Column(
// mainAxisSize: MainAxisSize.min,
// children: [
// Icon(
// Icons.warning,
// color: Colors.grey.shade500,
// size: 80,
// ),
// Text(
// 'لا يوجد بيانات',
// style: TextStyle(
// color: Colors.grey.shade500,
// fontWeight: FontWeight.bold,
// fontSize: 16,
// ),
// )
// ],
// ),
// );
// }
// },
// );
