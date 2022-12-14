import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/controller/TaskApiController.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:todo_emp/providers/TaskProvider.dart';
import 'package:todo_emp/widgets/task_widget.dart';
import 'package:todo_emp/widgets/task_widget_admin.dart';

class ApiTasksScreen extends StatefulWidget {
  @override
  State<ApiTasksScreen> createState() => _ApiTasksScreenState();
}

class _ApiTasksScreenState extends State<ApiTasksScreen> {
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshTasks();
  }

  Future refreshTasks() async {
    TaskApiController().getTasks(context: context);
    await Provider.of<TaskProvider>(context, listen: false).readTaskAd();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TaskProvider>(context, listen: false).readTaskAd();
    // TODO: implement build
    return Container(
      child: Consumer<TaskProvider>(
        builder: (
          BuildContext context,
          TaskProvider provider,
          Widget? child,
        ) {
          if (provider.readTaskAdmin.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                Future.delayed(Duration(seconds: 1)).then((v) {
                  TaskApiController().getTasks(context: context);
                });
              },
              child: ListView.builder(
                  itemCount: provider.readTaskAdmin.length,
                  itemBuilder: (context, index) {
                    taskModel task = provider.readTaskAdmin[index];

                    return TaskWidgetAdmin(
                      provider.readTaskAdmin.toList()[index],
                    );
                  }),
            );
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning,
                    size: 80,
                    color: Colors.grey.shade500,
                  ),
                  Text(
                    '???? ???????? ????????????',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 24,
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
